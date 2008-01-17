use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Catalyst::Controller::Atompub',
    license             => 'perl',
    dist_author         => 'Takeru INOUE <takeru.inoue _ gmail.com>',
    dist_version_from   => 'lib/Catalyst/Controller/Atompub.pm',
    requires => {
        'version'    => 0,
	'Atompub' => '0.1.6',
	'Catalyst::Devel' => 0,
	'Catalyst::Plugin::ConfigLoader' => 0,
	'Catalyst::Runtime' => 5.7,
        'File::Slurp' => 0,
	'FindBin' => 0,
        'HTTP::Status' => 0,
	'MIME::Base64' => 0,
	'POSIX' => 0,
	'Text::CSV' => 0,
	'Time::HiRes' => 0,
	'URI::Escape' => 0,
    },
    build_requires => {
        'Test::More' => 0,
        'Test::Perl::Critic' => 0,
	'Test::WWW::Mechanize::Catalyst' => 0,
    },
    recommends => {
	'Catalyst::Action::RenderView' => 0,
	'Catalyst::Devel' => 0,
        'Catalyst::Model::DBIC::Schema' => 0,
	'Catalyst::Plugin::Authentication::Credential::HTTP' => 0,
	'Catalyst::Plugin::Authentication::Store::DBIC' => 0,
	'Catalyst::Plugin::Static::Simple' => 0.16,
	'Catalyst::View::TT' => 0,
	'DBD::SQLite' => 1.13,
	'DBIx::Class::Schema::Loader' => 0,
	'String::CamelCase' => 0,
    }, 
    create_makefile_pl => 'traditional',
    add_to_cleanup      => [ 'Catalyst-Controller-Atompub-*' ],
);

$builder->create_build_script();
