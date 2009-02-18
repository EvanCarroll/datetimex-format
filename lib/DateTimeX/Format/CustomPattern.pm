package DateTimeX::Format::CustomPattern;
use strict;
use warnings;

use Moose::Role;
use Carp;

has 'pattern' => (
	isa         => 'Maybe[Str]'
	, is        => 'rw'
	, required  => 1
	, predicate => 'has_pattern'
);

around 'parse_datetime' => sub {
	my ( $sub, $self, $time, $env, @args ) = @_;

	croak "The key 'override' is not present in the env HashRef\n"
		unless exists $env->{override}
	;

	## Set Pattern: from args, then from object
	my $pattern = $env->{ override }->{ pattern }
		// $self->has_pattern
		? $self->pattern
		: croak "No pattern supplied to constructor or the call to parse_datetime"
	;

	$env->{ pattern } = $pattern;
	
	## Calls the sub ( time, env, addtl args )
	my $dt = $self->$sub( $time , $env , @args );

};

no Moose::Role;

1;

__END__

=head1 NAME

DateTimeX::Format::CustomPattern

=head1 DESCRIPTION

This role must be composed B<before> L<DateTimeX::Format>.

It adds an attribute "pattern", and behavies cosistant with the call-overriding environment of L<DateTimeX::Format>.

=head1 SYNOPSIS
	
	package DateTimeX::Format::RequiresPattern;
	with 'DateTimeX::Format::CustomPattern';
	with 'DateTimeX::Format';

	package main;

	my $dt = DateTimeX::Format::RequiresPattern->new({
		locale     => $locale
		, timezone => $timezone
		, pattern  => '%H:%M:%S'
		, debug    => 0|1
		, defaults => 0|1
	});

	$dt->parse_datetime( $time, {pattern => '%H:%M'} );
