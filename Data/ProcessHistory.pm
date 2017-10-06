use strict;
use warnings;
package Data::ProcessHistory;

sub new {
	my $class = shift;

	my $processHistory = {
		"process_date"            => shift,
		"user_started"            => shift,
		"successful",             => shift,
		"num_contributions_added" => shift,
		"type"                    => shift,
	};

	bless( $processHistory, $class );

	return $processHistory;
}

sub print_details {
	my ($processHistory) = @_;
	print " Process Date : " . $processHistory->{process_date} . "\n";
	print " User Started : " . $processHistory->{user_started} . "\n";
	print " Successful : " . $processHistory->{successful} . "\n";
	print " Number of contributions added : " . $processHistory->{num_contributions_added} . "\n";
	print " Type : " . $processHistory->{type} . "\n";
}

1;
