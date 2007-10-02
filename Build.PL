use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Catalyst::Controller::Atompub',
    license             => 'perl',
    dist_author         => 'Takeru INOUE <takeru.inoue _ gmail.com>',
    dist_version_from   => 'lib/Catalyst/Controller/Atompub.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,

	'Atompub' => '0.1.6',
	'Catalyst::Runtime' => 5.7,
	'Catalyst::Plugin::Static::Simple' => 0.16, # for samples/
        'File::Slurp' => 0,
	'FindBin' => 0,
        'HTTP::Status' => 0,
	'MIME::Base64' => 0,
	'POSIX' => 0,
	'Time::HiRes' => 0,
        'Test::Perl::Critic' => 0,
	'Test::WWW::Mechanize::Catalyst' => 0,
	'URI::Escape' => 0,
    },
    add_to_cleanup      => [ 'Catalyst-Controller-Atompub-*' ],
);

$builder->create_build_script();
