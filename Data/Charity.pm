package Data::Charity;

use strict;
use warnings;
use Exporter qw(import);

@EXPORT_OK = qw(getName);


# Create a Charity object
# if not a pre-existing charity, expect id to be -1
sub new(  )
{
	my $class = shift;
	my $self = { 
		"id" => shift, 
		"name" => shift,
		"address_line_1" => shift,
		"address_line_2" => shift,
		"city" => shift,
		"postcode" => shift,
		"country" => shift,
		"telephone" => shift
	};

	bless($self, $class);
}


sub getName()
{
	return shift->{name};
}


sub setName()
{
	my $self = shift;
	my $newName = shift;
    $self->{"name"} = $newName; 
}



1;