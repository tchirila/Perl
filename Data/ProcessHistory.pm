package Data::ProcessHistory;
use warnings;
use Exporter qw(import);
use Data::Dumper;

@EXPORT_OK =
  qw(getProcessDate setProcessDate setUserStarted getUserStarted getSuccessful setSuccessful getContributions setContributions getType
  setType );

$| = 1;

sub new {
	my $class          = shift;
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
	print " Number of contributions added : "
	  . $processHistory->{num_contributions_added} . "\n";
	print " Type : " . $processHistory->{type} . "\n";
}

sub setProcessDate {
	my $processHistory = shift;
	my $newDate        = shift;
	$processHistory->{"process_date"} = $newDate;
}

sub getProcessDate {
	return shift->{"process_date"};
}

sub setUserStarted {
	my $processHistory = shift;
	my $newUser        = shift;
	$processHistory->{"user_started"} = $newUser;
}

sub getUserStarted {
	return shift->{"user_started"};
}

sub setSuccessful {
	my $processHistory = shift;
	my $newSuccessful  = shift;
	$processHistory->{"successful"} = $newSuccessful;
}

sub getSuccessful {
	return shift->{"successful"};
}

sub setContributions {
	my $processHistory        = shift;
	my $newContributionsAdded = shift;
	$processHistory->{"num_contributions_added"} = $newContributionsAdded;
}

sub getContributions {
	return shift->{"num_contributions_added"};
}

sub setType {
	my $processHistory = shift;
	my $newType        = shift;
	$processHistory->{"type"} = $newType;
}

sub getType {
	return shift->{"type"};
}

1;
