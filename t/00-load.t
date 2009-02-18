#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'DateTimeX::Format' );
}

diag( "Testing DateTimeX::Format $DateTimeX::Format::VERSION, Perl $], $^X" );
