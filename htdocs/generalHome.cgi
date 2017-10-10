#!D:/Program Files/Perl64/bin/perl.exe

use strict;
use warnings;
use CGI;

my $cgi = new CGI();

sub main()
{
	print $cgi->header();
	my $role = "General";
	
	print qq{
		<html>
			<h1>Pension Scheme: General</h1>
			<table>
				<tr><td><a href="employeeDetails.cgi?role=$role">View Your Details</a></td></tr>
				<tr><td><a href="contributions.cgi?role=$role">View Pension Contributions</a></td></tr>
				<tr><td><a href="charities.cgi?role=$role">Charities</a></td></tr>
			</table>
		</html>
	};	
}

main();