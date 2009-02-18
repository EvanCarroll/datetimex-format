package DateTimeX::Format;
use strict;
use warnings;

use Moose::Role;
use 5.010;
use mro 'c3';

use DateTime::Locale;
use DateTime::TimeZone;
use MooseX::Types::DateTime;
use Carp;

requires 'parse_datetime';

our $VERSION = '00.01_02';

has 'pattern' => (
	isa         => 'Maybe[Str]'
	, is        => 'rw'
	, required  => 1
	, predicate => 'has_pattern'
);

has 'locale' => (
	isa         => 'DateTime::Locale'
	, is        => 'rw'
	, coerce    => 1
	, predicate => 'has_locale'
);

has 'timezone' => (
	isa         => 'DateTime::TimeZone'
	, is        => 'rw'
	, coerce    => 1
	, predicate => 'has_timezone'
);

has 'defaults' => ( isa => 'Bool', is => 'ro', default => 1 );
has 'debug' => ( isa => 'Bool', is => 'ro', default => 0 );

around 'parse_datetime' => sub {
	my ( $sub, $self, $time, $override, @args ) = @_;


	## Set Pattern: from args, then from object
	my $pattern = $override->{ pattern }
		// $self->has_pattern
		? $self->pattern
		: croak "No pattern supplied to constructor or the call to parse_datetime"
	;


	## Set Timezone: from args, then from object
	my $timezone = $override->{ timezone };
	if ( not defined $timezone ) {
		if ( $self->has_timezone ) {
			$timezone = $self->timezone
		}
		elsif ( $self->defaults ) {
			carp "No timezone supplied to constructor or the call to parse_datetime -- defaulting to floating\n"
				if $self->debug
			;
			$timezone = DateTime::TimeZone->new( name => 'floating' );
		}
		else {
			carp "No timezone supplied instructed to not use defaults"
		};
	}


	## Set Locale: from args, then from object, then guess en_US
	my $locale = $override->{ locale };
	if ( not defined $locale ) {
		if ( $self->has_locale ) {
			$locale = $self->locale
		}
		elsif ( $self->defaults ) {
			carp "No locale supplied to constructor or the call to parse_datetime -- defaulting to en_US\n"
				if $self->debug
			;
			$locale = DateTime::Locale->load( 'en_US' );
		}
		else {
			carp "No timezone supplied instructed to not use defaults"
		};
	}

	my $env = {
		timezone   => $timezone
		, locale   => $locale
		, pattern  => $pattern
		, override => $override
	};

	## Calls the sub ( time, env, addtl args )
	my $dt = $self->$sub( $time , $env , @args );

	warn "Module did not return DateTime object"
		if ! blessed $dt eq 'DateTime'
		&& $self->debug
	;

	$dt;
	
};

sub new_datetime {
	my ( $self, $args ) = @_;

	if ( $self->debug ) {
		carp "Year Month and Day should be specified if Year Month or Day is specified\n"
			if ( $args->{day} // $args->{month} // $args->{year} )
			&& ( ! defined $args->{day} or ! defined $args->{month} or ! defined $args->{year} )
		;
		carp "Marking Year Month and Day as a default\n"
			if not defined ($args->{day} // $args->{months} // $args->{year})
		;
	}

	DateTime->new(
		time_zone => $args->{timezone}
		, locale  => $args->{locale}

		, nanosecond  => $args->{nanosecond}  // 0
		, second      => $args->{second}      // 0
		, minute      => $args->{minute}      // 0
		, hour        => $args->{hour}        // 0

		, day     => $args->{day}    // 1
		, month   => $args->{month}  // 1
		, year    => $args->{year}   // 1
	);

}

1;

no Moose::Role;
no MooseX::Types::DateTime;
no Carp;

__END__

=head1 NAME

DateTimeX::Format - Moose Roles for building next generation DateTime formats

=head1 SYNOPSIS

	package DateTimeX::Format::Bleh;
	with 'DateTimeX::Format';

	## If your module doesn't require a user sent pattern
	has '+pattern' => ( default => 'Undef' );

	sub parse_datetime {
		my ( $time, $env, @args ) = @_;
		# expr;
	}

	my $dt = DateTimeX::Format::Bleh->new({
		locale     => $locale
		, timezone => $timezone
		, debug    => 0|1
		, defaults => 0|1
	});

	$dt->debug(0);
	$dt->timezone( $timezone );
	$dt->locale( $locale );
	$dt->pattern( $pattern );
	$dt->defaults(1);

	$dt->parse_datetime( $time, {locale=>$locale_for_call} );

	my $env = {
		timezone  => $timezone_for_call
		, locale  => $locale_for_call
	};
	$dt->parse_datetime( $time, $env, @additional_arguments );

	$dt->parse_datetime( $time, {timezone=>$timezone_for_call} )

=head1 DESCRIPTION

This L<Moose::Role> simply provides an environment at instantation which can be overriden in the call to L<parse_data> by supplying a hash.

All of the DateTime based methods, locale and timezone, coerce in accordence to what the docs of L<MooseX::Types::DateTime> say -- the coercions only occur in the constructor.

In addition this module provides two other accessors to assist in the development of modules in the L<DateTimeX::Format> namespace, these are C<debug>, and C<defaults>.

=head1 OBJECT ENVIRONMENT

All of these slots correspond to the environment: they can be supplied in the constructor or through accessors.

=over 4

=item * locale

Can be overridden in the call to ->parse_datetime.

See the docs at L<MooseX::Types::DateTime> for informations about the coercions.

=item * timezone

Can be overridden in the call to ->parse_datetime.

See the docs at L<MooseX::Types::DateTime> for informations about the coercions.

=item * pattern( $str )

Can be overridden in the call to ->parse_datetime.

=item * debug( 1 | 0* )

Set to one to get debugging information

=item * defaults( 1* | 0 )

Set to 0 to force data to be sent to the module

=back

=head1 HELPER FUNCTIONS

=over 4

=item new_datetime( $hashRef )

Takes a hashRef of the name value pairs to hand off to DateTime->new

=back

=head1 AUTHOR

Evan Carroll, C<< <me at evancarroll.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-datetimex-format at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=DateTimeX-Format>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

perldoc DateTimeX::Format

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=DateTimeX-Format>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/DateTimeX-Format>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/DateTimeX-Format>

=item * Search CPAN

L<http://search.cpan.org/dist/DateTimeX-Format/>

=back

=head1 ACKNOWLEDGEMENTS

Dave Rolsky -- provided a some assistance with how DateTime works

=head1 COPYRIGHT & LICENSE

Copyright 2009 Evan Carroll, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
