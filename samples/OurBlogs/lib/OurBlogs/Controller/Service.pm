package # hide from PAUSE
    OurBlogs::Controller::Service;

use strict;
use warnings;

use base qw(Catalyst::Controller::Atompub::Service);

sub auto :Private {
    my($self, $c) = @_;
    my $realm = $c->config->{authentication}{http}{realm};
    $c->authorization_required(realm => $realm);
    1;
}

1;
