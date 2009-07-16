use inc::Module::Install;

name     'DateTimeX-Format';
all_from 'lib/DateTimeX/Format.pm';
author   'Evan Carroll <me@evancarroll.com>';
license  'perl';

requires 'Moose';
requires 'MooseX::Types::DateTime::ButMaintained' => '0.07';
requires 'Moose::Role';

requires 'namespace::clean';

requires 'DateTime';
requires 'DateTime::Locale';
requires 'DateTime::TimeZone';
requires 'Carp';

repository 'git@github.com:EvanCarroll/datetimex-format.git';

build_requires 'Test::More';

auto_install;

WriteAll;

