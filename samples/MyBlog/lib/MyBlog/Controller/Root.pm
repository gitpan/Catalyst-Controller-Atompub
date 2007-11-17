package MyBlog::Controller::Root;

use strict;
use warnings;
use base 'Catalyst::Controller';

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

MyBlog::Controller::Root - Root Controller for MyBlog

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

sub auto :Private {
    my ( $self, $c ) = @_;

    # authentication not required, if GET
    return 1 if $c->req->method eq 'GET';

    my $realm = $c->config->{authentication}{http}{realm};
    $c->authorization_required( realm => $realm );

    return 1;
}

=head2 default

=cut

sub default : Private {
    my ( $self, $c ) = @_;
    $c->res->redirect('html');
}

=head2 end

Attempt to render a view, if needed.

=cut 

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Takeru INOUE,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
