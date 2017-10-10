#!D:/Program Files/Perl64/bin/perl.exe

use strict;
use warnings;
use CGI;

my $cgi = new CGI();
my $role = $cgi->param('role');

sub main()
{
	print $cgi->header();
	my $homePage = "generalHome.cgi";
	
	if($role eq "HRAdmin"){
		$homePage = "adminHome.cgi"
	}
	
	print qq{
		<html>
			<h1>Charities</h1>
			
			<table>
				<tr><td><a href="$homePage">Home</a></td></tr>
			</table>
		</html>
	};	
}

main();