package MyBlog::Controller::MediaCollection;

use strict;
use warnings;

use Atompub::DateTime qw( datetime );
use Atompub::MediaType qw( media_type );
use MIME::Base64;
use HTTP::Status;
use POSIX qw( strftime );
use String::CamelCase qw( camelize );
use Time::HiRes qw( gettimeofday );

use base qw( Catalyst::Controller::Atompub::Collection );

my $ENTRIES_PER_PAGE = 10;
my $TABLE_NAME       = 'resources';

my $MODEL = join '::', 'DBIC', camelize( $TABLE_NAME );

sub get_feed :Atompub(list) {
    my ( $self, $c ) = @_;

    ## URI without parameters
    my $uri = $self->collection_resource->uri;

    my $feed = $self->collection_resource->body;

    my $cond = {
	uri  => { like => "$uri/%" },
	type => media_type('entry'),
    };

    my $page = $c->req->param('page') || 1;

    my $attr = {
	offset   => ( $page - 1 ) * $ENTRIES_PER_PAGE,
	rows     => $ENTRIES_PER_PAGE,
	order_by => 'edited desc',
    };

    my $rs = $c->model( $MODEL )->search( $cond, $attr );

    while ( my $entry_resource = $rs->next ) {
	my $entry = XML::Atom::Entry->new( \$entry_resource->body );
	$feed->add_entry( $entry );
    }

    my $num_entries = $rs->count;

    $feed->first_link( $uri );
    $feed->previous_link( "$uri?page=" . ($page-1) ) if $page > 1;
    $feed->next_link( "$uri?page=" . ($page+1) ) if $num_entries >= $ENTRIES_PER_PAGE;

    return $self;
}

sub create_resource :Atompub(create) {
    my ( $self, $c ) = @_;

    my $prefix = $self->media_resource->uri;
    $prefix =~ s{(?<=\.)[^./]+$}{};

    return $self->error( $c, RC_CONFLICT, "Resource name is used (change Slug): $prefix" )
	if $c->model( $MODEL )->search( { uri => { like => "$prefix%" } } )->count;

    # URI of the new Media Resource, which was determined by C::C::Atompub
    my $uri = $self->media_resource->uri;

    my $media = MIME::Base64::encode( $self->media_resource->body );

    # Edit $media if needed

    my $vals = {
	uri    => $uri,
	edited => $self->media_resource->edited->iso,
	etag   => $self->calculate_new_etag( $c, $uri ),
	type   => $self->media_resource->type,
	body   => $media,
    };

    $c->model( $MODEL )->create( $vals )
	|| return $self->error( $c, RC_INTERNAL_SERVER_ERROR,
				'Cannot create new media resource' );

    # URI of the new Media Link Entry, which was determined by C::C::Atompub
    $uri = $self->media_link_entry->uri;

    my $entry = $self->media_link_entry->body;

    # Edit $entry if needed

    $vals = {
	uri    => $uri,
	edited => $self->media_link_entry->edited->iso,
	etag   => $self->calculate_new_etag( $c, $uri ),
	type   => media_type('entry'),
	body   => $entry->as_xml,
    };

    $c->model( $MODEL )->create( $vals )
	|| return $self->error( $c, RC_INTERNAL_SERVER_ERROR,
				'Cannot create new media link entry' );

    return $self;
}

sub get_resource :Atompub(read) {
    my ( $self, $c ) = @_;

    my $uri = $c->req->uri;

    my $rs = $c->model( $MODEL )->find( { uri => $uri } )
	|| return $self->error( $c, RC_NOT_FOUND );

    my $body;
    if ( ! media_type( $rs->type )->is_a('entry') ) { # if Media Resource
	$self->media_resource->type( $rs->type );
	$self->media_resource->body( MIME::Base64::decode( $rs->body ) );
    }
    else {
	$self->media_link_entry->body( XML::Atom::Entry->new( \$rs->body ) );
    }

    return $self;
}

sub update_resource :Atompub(update) {
    my ( $self, $c ) = @_;

    my $uri = $c->req->uri;

    my $edited;
    my $type;
    my $body;
    if ( $self->media_resource ) {
	$edited = $self->media_resource->edited->iso;
	$type   = $self->media_resource->type;
	$body   = MIME::Base64::encode( $self->media_resource->body );
    }
    elsif ( $self->media_link_entry ) {
	$edited = $self->media_link_entry->edited->iso;
	$type   = media_type('entry');
	$body   = $self->media_link_entry->body->as_xml;
    }
    else {
	return $self->error( $c, RC_INTERNAL_SERVER_ERROR, 'No resource' );
    }

    # Edit $body if needed

    my $vals = {
	uri    => $uri,
	edited => $edited,
	etag   => $self->calculate_new_etag( $c, $uri ),
	type   => $type,
	body   => $body,
    };

    my $rs = $c->model( $MODEL )->find( { uri => $uri } )
	|| return $self->error( $c, RC_NOT_FOUND );

    $rs->update( $vals )
	|| return $self->error( $c, RC_INTERNAL_SERVER_ERROR, "Cannot update resource: $uri" );

    return $self;
}

sub delete_resource :Atompub(delete) {
    my ( $self, $c ) = @_;

    my $prefix = my $uri = $c->req->uri;
    $prefix =~ s{(?<=\.)[^./]+$}{};

    # delete entry and media resources at once
    my $cond = { uri => { like => "$prefix%" } };

    my $rs = $c->model( $MODEL )->search( $cond )
	|| return $self->error( $c, RC_NOT_FOUND );

    $rs->delete
	|| return $self->error( $c, RC_INTERNAL_SERVER_ERROR, "Cannot delete resource: $uri" );

    return $self;
}

sub make_edit_uri {
    my ( $self, $c, @args ) = @_;

    my @uris = $self->SUPER::make_edit_uri( $c, @args );

    # return, if $uris[0] is not used
    return wantarray ? @uris : $uris[0]
	unless $c->model( $MODEL )->find( { uri => $uris[0] } );

    my ( $sec, $usec ) = gettimeofday;
    my $dt = strftime '%Y%m%d-%H%M%S', localtime( $sec );
    $usec  = sprintf '%06d', $usec;

    # insert $dt-$usec before extension
    $_ =~ s{(\.[^./?]+)$}{-$dt-$usec$1} for @uris;

    return @uris;
}

sub find_version {
    my ( $self, $c, $uri ) = @_;

    my $rs = $c->model( $MODEL )->find( { uri => $uri } ) || return;

    return ( etag => $rs->etag );
#    return ( etag => $rs->etag, last_modified => datetime( $rs->edited )->str );
}

sub calculate_new_etag {
    my ( $self, $c, $uri ) = @_;
    my ( $sec, $usec ) = gettimeofday;
    my $dt = join '-', strftime( '%Y%m%d-%H%M%S', localtime($sec) ), sprintf( '%06d', $usec );
    join '/', $uri, $dt;
}

1;
