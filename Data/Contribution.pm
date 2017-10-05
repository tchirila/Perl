package Data::Contribution;
use Exporter qw(import);

@EXPORT_OK = qw(setType);
@EXPORT_OK = qw(setContpc);
@EXPORT_OK = qw(setContAmount);
@EXPORT_OK = qw(setSalary);
@EXPORT_OK = qw(setProcessDate);
@EXPORT_OK = qw(setEffectiveDate);
@EXPORT_OK = qw(setCharityId);
@EXPORT_OK = qw(setApprovedBy);

@EXPORT_OK = qw(getType);
@EXPORT_OK = qw(getContpc);
@EXPORT_OK = qw(getContAmount);
@EXPORT_OK = qw(getSalary);
@EXPORT_OK = qw(getProcessDate);
@EXPORT_OK = qw(getEffectiveDate);
@EXPORT_OK = qw(getCharityId);
@EXPORT_OK = qw(getApprovedBy);


sub new{
	my $class = shift;
	
	my $contribution = {
		"type" = shift,
		"cont_pc" = shift,
		"cont_amount" = shift,
		"salary" = shift,
		"process_date" = shift,
		"effective_date" = shift,
		"charity_id" = shift,
		"approved_by" = shift,
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
	return shif->{"type"};
}

sub getContPc{
	return shif->{"cont_pc"};
}

sub getContAmount{
	return shif->{"cont_amount"};
}

sub getSalary{
	return shif->{"salary"};
}

sub getProcessDate{
	return shif->{"process_date"};
}

sub getEffectiveDate{
	return shif->{"effective_date"};
}

sub getCharityId{
	return shif->{"charity_id"};
}

sub getApprovedBy{
	return shif->{"approved_by"};
}

1;