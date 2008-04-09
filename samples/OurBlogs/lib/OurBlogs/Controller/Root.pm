package # hide from PAUSE
    OurBlogs::Controller::Root;

use strict;
use warnings;
use base qw(Catalyst::Controller);

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

sub end :ActionClass('RenderView') {}

1;
