package Catalyst::Controller::Atompub;

use warnings;
use strict;
use Carp;

use version; our $VERSION = qv('0.1.1');

use Atompub 0.1.2;
use Catalyst::Request;
use Catalyst::Response;

while ( my ( $method, $header ) = each %Atompub::REQUEST_HEADERS ) {
    no strict 'refs'; ## no critic
    if ( ! Catalyst::Request->can( $method ) ) {
	*{ "Catalyst::Request::$method" } = sub { shift->header( $header, @_ ) };
    }
}

while ( my ( $method, $header ) = each %Atompub::RESPONSE_HEADERS ) {
    no strict 'refs'; ## no critic
    if ( ! Catalyst::Response->can( $method ) ) {
	*{ "Catalyst::Response::$method" } = sub { shift->header( $header, @_ ) };
    }
}

while ( my ( $method, $header ) = each %Atompub::ENTITY_HEADERS ) {
    no strict 'refs'; ## no critic
    if ( ! Catalyst::Request->can( $method ) ) {
	*{ "Catalyst::Request::$method" } = sub { shift->header( $header, @_ ) };
    }
    if ( ! Catalyst::Response->can( $method ) ) {
	*{ "Catalyst::Response::$method" } = sub { shift->header( $header, @_ ) };
    }
}

1;
__END__

=head1 NAME

Catalyst::Controller::Atompub 
- A Catalyst controller for the Atom Publishing Protocol


=head1 DESCRIPTION

L<Catalyst::Controller::Atompub> provides a base class 
for the Atom Publishing Protocol servers.
This module handles all core server processing based on the Atom Publishing Protocol
described at L<http://www.ietf.org/internet-drafts/draft-ietf-atompub-protocol-17.txt>.

Implementations must subclass the following modules.

=over 4

=item * L<Catalyst::Controller::Atompub::Service>

Presents information of collections in a Service Document.

=item * L<Catalyst::Controller::Atompub::Collection>

Publishes and edits resources in the collection.

=back

At first, install sample C<samples/MyAtom> in L<SAMPLES> and read controller classes.
The code is explained in
L<Catalyst::Controller::Atompub::Service> and 
L<Catalyst::Controller::Atompub::Collection>.

L<Catalyst::Controller::Atompub> was tested in InteropTokyo2007
L<http://intertwingly.net/wiki/pie/July2007InteropTokyo>, 
and interoperated with other implementations.


=head1 SAMPLES

Sample codes are found in I<samples/> directory.
The following resources are required:

=over 4

=item * Catalyst v5.7 or later

=item * Catalyst::Model::DBIC::Schema v0.20 or later

=item * Catalyst::View::TT v0.25 or later (C<MyBlog> only)

=item * Catalyst Plugins (C<MyBlog> only)

    Authentication
    Authentication::Store::DBIC
    Authentication::Credential::HTTP

=item * MySQL v4.0 or later

Initialize your database with C<init.sql> before running the samples.
The initialization script assums that database name is 'test', 
username is 'test', and password is 'test'.

=back


=head2 samples/MyAtom

This sample is minimum implementation of the Atom Publishing Protocol.
It has a single collection containing Entry Resources.
Cache controll and feed paging are not provided.
Errors are ignored.

URI of the Service Document is http://localhost:3000/myservice .

This sample is a kind of tutorial.


=head2 samples/MyBlog

This sample implements many features of the Atom Publishing Protocol.
It has two collections; one collection contains Entry Resources, 
the other contains Media Resources (images).
The server provides basic authentication, cache controll and feed paging.
Duplicate detection of resource names is also implemented.
Errors are properly handled.

URI of the Service Document is http://localhost:3000/service .
This sample also provides a HTML view at http://localhost:3000/html .


=head1 AUTHOR

Takeru INOUE  C<< <takeru.inoue _ gmail.com> >>

I would like to thank Masaki NAKAGAWA for his valuable suggestions.


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2007, Takeru INOUE C<< <takeru.inoue _ gmail.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
