package Data::Charity;

use warnings;
use Exporter qw(import);

@EXPORT_OK = qw(getName);


# Create a Charity object
# if not a pre-existing charity, expect id to be -1

sub new {
	my $class = shift;
	my $self = {
		"id" => shift,
		"name" => shift,
		"address_line_1" => shift,
		"address_line_2" => shift,
		"city" => shift,
		"postcode" => shift,
		"country" => shift,
		"telephone" => shift,
	};

	bless($self, $class);

	return $self;
}


#Param1: Charity object
sub getId	{
	return shift->{"id"};
}

#Param1: Charity object
#Param2: New ID
sub setId	{
	my $charity = shift;
	my $newId = shift;
	$charity->{"id"} = $newId;
}


sub getName	{
	return shift->{"name"};
}

sub setName	{
	my $charity = shift;
	my $newName = shift;
	$charity->{"name"} = $newName;
}


sub getAddressLine1	{
	return shift->{"address_line_1"};
}

sub setAddressLine1	{
	my $charity = shift;
	my $newLine1 = shift;
	$charity->{"address_line_1"} = $newLine1;
}


sub getAddressLine2	{
	return shift->{"address_line_2"};
}

sub setAddressLine2	{
	my $charity = shift;
	my $newLine2 = shift;
	$charity->{"address_line_2"} = $newLine2;
}


sub getCity	{
	return shift->{"city"};
}

sub setCity	{
	my $charity = shift;
	my $newCity = shift;
	$charity->{"city"} = $newCity;
}


sub getPostCode	{
	return shift->{"postcode"};
}

sub setPostCode	{
	my $charity = shift;
	my $newPostCode = shift;
	$charity->{"postcode"} = $newPostCode;
}


sub getCountry	{
	return shift->{"country"};
}

sub setCountry	{
	my $charity = shift;
	my $newCountry = shift;
	$charity->{"country"} = $newCountry;
}


sub getTel	{
	return shift->{"telephone"};
}

sub setTel	{
	my $charity = shift;
	my $newTel = shift;
	$charity->{"telephone"} = $newTel;
}


1;