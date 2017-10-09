package DAO::CharityDao;
use strict;
use warnings;

#require Data::Charity;
require Data::Charity;



#Param1: FileName.
sub getCharitiesFromCSV	{
    my $inFile = shift;
    open(INPUT,$inFile) or die ("Missing file: $inFile");
    my @headers = split /\s*,\s*/, <INPUT>;

    my %hash;
    LOOP1: while(my $line = <INPUT>)	{
        $line =~ /\S+/ or next LOOP1; ## Skip blank lines.
        chomp $line;
        my @fields = split /\s*,\s*/, $line;
        if(scalar(@fields)<scalar(@headers))	{
            print "WARNING: Invalid row (".
                scalar(@fields)."/".scalar(@headers)." columns): '$line'\n";
            next LOOP1;
        }

        my $newCharity = new Data::Charity(
            $fields[0],
            $fields[1],
            $fields[2],
            $fields[3],
            $fields[4],
            $fields[5],
            $fields[6],
            $fields[7],
        );
        hashAddCharity(\%hash, $newCharity);
    }
    close INPUT;
    return %hash;
}


#Param1: Employees hash.
#Param2: Employee object.
sub hashAddCharity	{ #TODO: Get auth for this change.
    my ($charities, $charity) = @_;
    my $id = Data::Charity::getId($charity);
    #my $id = getId($charity);
    $charities->{$id} = $charity;
}


## Param1: charities hash.
##Param2: charity ID.
sub hashGetCharity	{
    my ($charities, $id) = @_;
    my $charity = $charities->{$id};
    return $charity;
}


#Param1: Charities hash.
#Param2: charity ID.
sub hashRemoveCharity	{
    my $charities = shift;
    my $id = shift;
    delete($charities->{$id});
}

#Param1: Charities hash.
#Param2: filename.
sub saveCharitiesToCSV	{
    my ($hash, $file) = @_;
    open(OUTPUT, '>'.$file) or die "Can't open file $file";
    print OUTPUT "id,name,address_line_1,address_line_2,city,postcode,country,telephone\n"; ##Header
    foreach my $value (values $hash)
    {
        my $line = Data::Charity::getId($value).","
            .Data::Charity::getName($value).","
            .Data::Charity::getAddressLine1($value).","
            .Data::Charity::getAddressLine2($value).","
            .Data::Charity::getCity($value).","
            .Data::Charity::getPostCode($value).","
            .Data::Charity::getCountry($value).","
            .Data::Charity::getTel($value)."\n";
        print OUTPUT $line;
    }
    close(OUTPUT);
}


1;