package DateTimeX::Format::RequiresPattern;
use Moose;
with 'DateTimeX::Format::CustomPattern';

sub parse_datetime {
	my ( $self, $time, $env, @args ) = @_;

	die $env->{time_zone};
}

sub format_datetime {

}

package main;

my $dt = DateTimeX::Format::RequiresPattern->new({
	time_zone  => 'floating'
	, pattern    => '%H:%M:%S'
	, debug      => 0|1
	, defaults   => 0|1
});

$dt->parse_datetime(1234);
