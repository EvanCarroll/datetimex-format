package DateTimeX::Format::RequiresPattern;
use Moose;
with 'DateTimeX::Format::CustomPattern';

sub parse_datetime {
	my ( $self, $time, $env, @args ) = @_;
	die [ @_ ];
}

sub format_datetime { }


package main;

my $dt = DateTimeX::Format::RequiresPattern->new({
	time_zone    => 'floating'
	, locale     => 'en_US'
	, pattern    => '%H:%M:%S'
	, debug      => 1
	, defaults   => 1
});

$dt->parse_datetime('1:30 AM');
