package DAO::ProcessHistoryDao;
use strict;
use warnings;
use Data::Dumper;
use lib '..'; 
use Exporter qw(import);
require Data::ProcessHistory;
require DAO::ConnectionDao;

$| = 1;                  

sub getAProcessHistory() {
	my $processHistoryID = shift; 

	my $connection = DAO::ConnectionDao::getDbConnection();

	my $sql = 'select id, process_date, user_started, successful, num_contr_added, type from process_history where id = ? ';
	my $stmtGetAProcess = $connection->prepare($sql);
	unless ( defined($stmtGetAProcess) ) {
		die("Could not prepare statement for export from db\n");
	}

	unless ( $stmtGetAProcess->execute($processHistoryID) ) {
		die "Could not retrieve process $processHistoryID from db\n";
	}
}

sub getAllProcessHistory() {
	my $connection = DAO::ConnectionDao::getDbConnection();

	my $sql = 'select id, process_date, user_started, successful, num_contr_added, type from process_history order by process_date desc ';
	my $stmtGetAllProcess = $connection->prepare($sql);
	unless ( defined($stmtGetAllProcess) ) {
		die("Could not prepare statement for export from db\n");
	}

	unless ( $stmtGetAllProcess->execute() ) {
		die "Could not retrieve processhistory from db\n";
	}
}

sub removeProcess()
{
	my $processNum =  shift;   

	my $connection = DAO::ConnectionDao::getDbConnection();
	$connection->do("delete from process_history where process_id = '$processNum'");
	DAO::ConnectionDao::closeDbConnection($connection);
}

sub addProcess()
{
	my $connection = DAO::ConnectionDao::getDbConnection();
	my $stmtAddProcess = $connection->prepare('insert into process_history (process_date, user_started, successful, num_contr_added, type) values (?, ?, ?, ?, ?)');
	
	unless($stmtAddProcess)   
	{
		die ("Error preparing process insert SQL\n");	
	}
   
	my ($process_date, $user_started, $successful, $num_contr_added, $type) = @_; 
	unless($stmtAddProcess->execute($process_date, $user_started, $successful, $num_contr_added, $type))
	{
		print "Error executing SQL\n";
		return 0;
	}  
	
	print "Process added successfully....\n";
		
	$stmtAddProcess->finish();
	DAO::ConnectionDao::closeDbConnection($connection);
	return 1;
}