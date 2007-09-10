use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Catalyst::Controller::Atompub',
    AUTHOR              => 'Takeru INOUE <takeru.inoue _ gmail.com>',
    VERSION_FROM        => 'lib/Catalyst/Controller/Atompub.pm',
    ABSTRACT_FROM       => 'lib/Catalyst/Controller/Atompub.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'version'    => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Catalyst-Controller-Atompub-*' },
);
