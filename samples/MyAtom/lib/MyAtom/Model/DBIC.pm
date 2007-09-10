package MyAtom::Model::DBIC;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'MyAtom::Model::Schema',
    connect_info => [
        'dbi:mysql:test',
        'test',
        'test',
        
    ],
);

=head1 NAME

MyAtom::Model::DBIC - Catalyst DBIC Schema Model
=head1 SYNOPSIS

See L<MyAtom>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<MyAtom::Model::Schema>

=head1 AUTHOR

Takeru INOUE,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
