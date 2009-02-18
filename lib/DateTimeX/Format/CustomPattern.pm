package DateTimeX::Format;
use strict;
use warnings;

use Moose::Role;

has 'pattern' => (
	isa         => 'Maybe[Str]'
	, is        => 'rw'
	, required  => 1
	, predicate => 'has_pattern'
);

around 'parse_datetime' => sub {
	my ( $sub, $self, $time, $env, @args ) = @_;

	## Set Pattern: from args, then from object
	my $pattern = $override->{ pattern }
		// $self->has_pattern
		? $self->pattern
		: croak "No pattern supplied to constructor or the call to parse_datetime"
	;

	warn "Module did not return DateTime object"
		if ! blessed $dt eq 'DateTime'
		&& $self->debug
	;

	$dt;
	
};

no Moose::Role;
