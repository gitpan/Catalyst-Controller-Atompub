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
my $ENTRY_TABLE_NAME = 'entries';
my $MEDIA_TABLE_NAME = 'medias';

my $ENTRY_MODEL = join '::', 'DBIC', camelize( $ENTRY_TABLE_NAME );
my $MEDIA_MODEL = join '::', 'DBIC', camelize( $MEDIA_TABLE_NAME );

sub index : Private {
    my ( $self, $c ) = @_;

    my @colls;

    my $page = $c->req->param('page') || 1;

    my $attr = {
	offset   => ( $page - 1 ) * $ENTRIES_PER_PAGE,
	rows     => $ENTRIES_PER_PAGE,
	order_by => 'edited desc',
    };

    my $rs = $c->model( $ENTRY_MODEL )->search( {}, $attr );

    my @entries;
    while ( my $resource = $rs->next ) {
	my $entry = XML::Atom::Entry->new( \$resource->body );

	my $uri     = $entry->edit_link;
	my $title   = qq{<a href="$uri">} . $entry->title . '</a>';
	my $content = $entry->content->body;

	push @entries, { updated => datetime( $entry->updated )->str,
			 title   => $title,
			 content => $content };
    }

    push @colls, { title => 'Diary', entries => \@entries };

    $rs = $c->model( $MEDIA_MODEL )->search( {}, $attr );

    my @media_link_entries;
    while ( my $resource = $rs->next ) {
	my $entry = XML::Atom::Entry->new( \$resource->entry_body );

	my $uri     = $entry->content->src;
	my $title   = qq{<a href="$uri">} . $entry->title . '</a>';
	my $content = qq{<a href="$uri"><img src="$uri"/></a>};

	push @media_link_entries, { updated => datetime( $entry->updated )->str,
				    title   => $title,
				    content => $content };
    }

    push @colls, { title => 'Photo', entries => \@media_link_entries };

    $c->stash->{collections} = \@colls;
}


=head1 AUTHOR

Takeru INOUE,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
