package Utilities::Time;
use strict;
use warnings;


sub getCurrentTimestamp{
	my $timeUnformatted = localtime();
	my @values = split /\s+/, $timeUnformatted;
	my $year = $values[4];
	my $month = setMonth($values[1]);
	my $day = setDay($values[2]);
	my $time = $values[3];
	my $separator = "-";
	my $result = ($year . $separator . $month . $separator . $day . " " . $time); 	
	
	return $result;
}

sub setMonth{
	my $month = shift;
	
	my %numericalMonths = (
		"Jan" => "01",
		"Feb" => "02",
		"Mar" => "03",
		"Apr" => "04",
		"May" => "05",
		"Jun" => "06",
		"Jul" => "07",
		"Aug" => "08",
		"Sep" => "09",
		"Oct" => "10",
		"Nov" => "11",
		"Dec" => "12",
	);
	
	return %numericalMonths{"$month"};
}

sub setDay{
	my $day = shift;
	
	if(length($day) == 1){
		$day = "0" . $day;
	}
	
	return $day;
}

sub getCurrentDate{
	my $timestamp = getCurrentTimestamp();
	my @date = (split " ", $timestamp);
	my $dateString = $date[0];

	return @date;
}

sub getCurrentTimestampTime{
	my $timestamp = getCurrentTimestamp();
	my @values = (split " ", $timestamp);
	my $time = @values[1];
	
	return $time;
}

1;
