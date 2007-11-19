package # hide from PAUSE
    MyBlog::View::TT;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config({
    CATALYST_VAR => 'Catalyst',
    INCLUDE_PATH => [
        MyBlog->path_to( 'root', 'src' ),
        MyBlog->path_to( 'root', 'lib' )
    ],
    PRE_PROCESS  => 'config/main',
    WRAPPER      => 'site/wrapper',
    ERROR        => 'error.tt2',
    TIMER        => 0,
    TEMPLATE_EXTENSION => '.tt2',
});

=head1 NAME

MyBlog::View::TT - Catalyst TTSite View

=head1 SYNOPSIS

See L<MyBlog>

=head1 DESCRIPTION

Catalyst TTSite View.

=head1 AUTHOR

Takeru INOUE,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

