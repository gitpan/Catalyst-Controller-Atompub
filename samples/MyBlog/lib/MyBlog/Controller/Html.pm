package MyBlog::Controller::Html;

use strict;
use warnings;
use base 'Catalyst::Controller';

=head1 NAME

MyBlog::Controller::Html - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

use Atompub::DateTime qw( datetime );
use Atompub::MediaType qw( media_type );
use Atompub::Util qw( is_acceptable_media_type );
use String::CamelCase qw( camelize );

my $ENTRIES_PER_PAGE = 10;
my $TABLE_NAME       = 'resources';

my $MODEL = join '::', 'DBIC', camelize( $TABLE_NAME );

sub _read_collection {
    my ( $self, $c, $coll, $is_media ) = @_;

    return unless $coll;

    my $cond = {
	uri  => { like => $coll->href . '/%' },
	type => media_type('entry'),
    };

    my $page = $c->req->param('page') || 1;

    my $attr = {
	offset   => ( $page - 1 ) * $ENTRIES_PER_PAGE,
	rows     => $ENTRIES_PER_PAGE,
	order_by => 'edited desc',
    };

    my $rs = $c->model( $MODEL )->search( $cond, $attr );

    my @entries;
    while ( my $entry_resource = $rs->next ) {
	my $entry = XML::Atom::Entry->new( \$entry_resource->body );

	my $content;
	if ( $is_media ) {
	    my $uri = $entry->edit_media_link;
	    $content = qq{<a href="$uri"><img src="$uri"/></a>};
	}
	else {
	    $content = $entry->content->body;
	}

	my $uri = $entry->edit_link;
	my $title = qq{<a href="$uri">} . $entry->title . '</a>';

	push @entries, { updated => datetime( $entry->updated )->str,
			 title   => $title,
			 content => $content };
    }

    return {
	title => $coll->title,
	entries => \@entries,
    };
}

sub index : Private {
    my ( $self, $c ) = @_;

    my $collection_info = Catalyst::Controller::Atompub::Info->instance( $self );

    my @colls = map { $self->_read_collection( $c, $_->[0], $_->[1] ) }
                map { [ $_, is_acceptable_media_type( $_, 'image/png' ) ] }
                map { $collection_info->get( $c, $_ ) }
              keys %{ $c->components };

    $c->stash->{collections} = \@colls;
}


=head1 AUTHOR

Takeru INOUE,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
