package DAO::EmployeeDao;
use Exporter qw(import);
use DBI;
use lib '..';

@EXPORT_OK = qw(getConnection);

$|=1;

my $DB_CREDENTIALS_FILE = "dbcreds.txt";


# PB IN PROGRESS
sub getDbConnection()
{
	# use global constant for file name
	
	
	
	#open(DB_INPUT, $DB_CREDENTIALS_FILE) or die("Could not find database file:" . $DB_CREDENTIALS_FILE)
	
	
	#close DB_INPUT;	
	
	
}


# PB IN PROGRESS
sub closeDbConnection()
{
	$connection = shift;
	unless(undefined($connection))
	{
		close($connection);		
	}
}

