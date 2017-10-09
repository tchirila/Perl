package Data::Contribution;
use warnings;
use Exporter qw(import);

@EXPORT_OK = qw(setType);
@EXPORT_OK = qw(setContpc);
@EXPORT_OK = qw(setContAmount);
@EXPORT_OK = qw(setSalary);
@EXPORT_OK = qw(setProcessDate);
@EXPORT_OK = qw(setEffectiveDate);
@EXPORT_OK = qw(setCharityId);
@EXPORT_OK = qw(setEmployeesId);
@EXPORT_OK = qw(getType);
@EXPORT_OK = qw(getContpc);
@EXPORT_OK = qw(getContAmount);
@EXPORT_OK = qw(getSalary);
@EXPORT_OK = qw(getProcessDate);
@EXPORT_OK = qw(getEffectiveDate);
@EXPORT_OK = qw(getCharityId);
@EXPORT_OK = qw(getEmployeesId);
@EXPORT_OK = qw(getId);



sub new{
	my $class = shift;
	
	my $contribution = {
		"id" => shift,
		"type" => shift,
		"cont_pc" => shift,
		"cont_amount" => shift,
		"salary" => shift,
		"process_date" => shift,
		"effective_date" => shift,
		"employees_id" => shift,
		"charity_id" => shift,	
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
sub setEmployeesId{
	my $contribution = shift;
	my $toChange = shift;
	$contribution->{"employees_id"} = $toChange;
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

sub getEmployeesId{
	return shift->{"employees_id"};
}

sub getId{
	return shift->{"id"};
}

1;