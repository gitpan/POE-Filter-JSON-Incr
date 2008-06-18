#!/usr/bin/perl


use POE qw(Wheel::ReadWrite Filter::JSON::Incr);

use JSON qw(to_json);

use Scalar::Util qw(blessed);

POE::Session->create(
	inline_states => {
		_start => sub {
			$_[HEAP]{readwrite} = POE::Wheel::ReadWrite->new(
				Handle => \*STDIN,
				Filter => POE::Filter::JSON::Incr->new( errors => 1 ),
				InputEvent => "got_line",
			);
		},
		got_line => sub {
			my $input = $_[ARG0];

			if ( blessed($input) ) {
				warn $input->{error};
			} else {
				warn to_json($input) . "\n";
			}
		},
	},
);

$poe_kernel->run;
