use inc::Module::Install;

name     'DateTimeX-Format';
all_from 'lib/DateTimeX/Format.pm';
author   'Evan Carroll <me@evancarroll.com>';
license  'perl';

requires 'MooseX::Types::DateTime';
requires 'DateTime';
requires 'DateTime::Locale';
requires 'DateTime::TimeZone';
requires 'Carp';
requires 'Moose::Role';

build_requires 'Test::More';

auto_install;

WriteAll;

