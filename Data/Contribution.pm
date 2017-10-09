package Data::Contribution;
use strict;
use warnings;
use Exporter qw(import);

my @EXPORT_OK = qw(setType);
my @EXPORT_OK = qw(setContpc);
my @EXPORT_OK = qw(setContAmount);
my @EXPORT_OK = qw(setSalary);
my @EXPORT_OK = qw(setProcessDate);
my @EXPORT_OK = qw(setEffectiveDate);
my @EXPORT_OK = qw(setCharityId);
my @EXPORT_OK = qw(setApprovedBy);

my @EXPORT_OK = qw(getType);
my @EXPORT_OK = qw(getContpc);
my @EXPORT_OK = qw(getContAmount);
my @EXPORT_OK = qw(getSalary);
my @EXPORT_OK = qw(getProcessDate);
my @EXPORT_OK = qw(getEffectiveDate);
my @EXPORT_OK = qw(getCharityId);
my @EXPORT_OK = qw(getApprovedBy);


sub new{
	my $class = shift;
	
	my $contribution = {
		"type" => shift,
		"cont_pc" => shift,
		"cont_amount" => shift,
		"salary" => shift,
		"process_date" => shift,
		"effective_date" => shift,
		"charity_id" => shift,
		"approved_by" => shift,
	};
	
	bless($contribution, $class);
	
	return $contribution;
}

sub setType{
	my $contribution = shift;
	my $toChange = shift;
	$contribution->{"type"} = $toChange;
}

sub setContPc{
	my $contribution = shift;
	my $toChange = shift;
	$contribution->{"cont_pc"} = $toChange;
}
sub setContAmount{
	my $contribution = shift;
	my $toChange = shift;
	$contribution->{"cont_amount"} = $toChange;
}

sub setSalary{
	my $contribution = shift;
	my $toChange = shift;
	$contribution->{"salary"} = $toChange;
}

sub setProcessDate{
	my $contribution = shift;
	my $toChange = shift;
	$contribution->{"process_date"} = $toChange;
}
sub setEffetiveDate{
	my $contribution = shift;
	my $toChange = shift;
	$contribution->{"effective_date"} = $toChange;
}

sub setCharityId{
	my $contribution = shift;
	my $toChange = shift;
	$contribution->{"charity_id"} = $toChange;
}
sub setApprovedBy{
	my $contribution = shift;
	my $toChange = shift;
	$contribution->{"approved_by"} = $toChange;
}

sub getType{
	return shift->{"type"};
}

sub getContPc{
	return shift->{"cont_pc"};
}

sub getContAmount{
	return shift->{"cont_amount"};
}

sub getSalary{
	return shift->{"salary"};
}

sub getProcessDate{
	return shift->{"process_date"};
}

sub getEffectiveDate{
	return shift->{"effective_date"};
}

sub getCharityId{
	return shift->{"charity_id"};
}

sub getApprovedBy{
	return shift->{"approved_by"};
}

1;