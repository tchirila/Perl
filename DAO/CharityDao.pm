package DAO::CharityDao;
use strict;
use warnings;

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


#Param1: Charities hash.
#Param2: Charity object.
sub hashAddCharity	{
    my ($charities, $charity) = @_;
    my $id = Data::Charity::getId($charity);
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
#sub saveCharitiesToCSV	{
#    my ($hash, $file) = @_;
#    open(OUTPUT, '>'.$file) or die "Can't open file $file";
#    print OUTPUT "id,name,address_line_1,address_line_2,city,postcode,country,telephone\n"; ##Header
#    foreach my $value (values $hash)
#    {
#        my $line = Data::Charity::getId($value).","
#            .Data::Charity::getName($value).","
#            .Data::Charity::getAddressLine1($value).","
#            .Data::Charity::getAddressLine2($value).","
#            .Data::Charity::getCity($value).","
#            .Data::Charity::getPostCode($value).","
#            .Data::Charity::getCountry($value).","
#            .Data::Charity::getTel($value).","
#            .Data::Charity::getApprovalStatus($value).","
#            .Data::Charity::getDiscardStatus($value)."\n";
#        print OUTPUT $line;
#    }
#    close(OUTPUT);
#}

##------------ db sub-routines -----------

#TODO: Test func.
#Param1: Charity object.
sub addCharity   {
    my $connection = DAO::ConnectionDao::getDbConnection();
    my $stmt = $connection->prepare('INSERT INTO charities (name, address_line_1, address_line_2, city,
    postcode, country, telephone, approved, discarded) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)');

    unless($stmt)
    {
        die ("Error preparing charity insert SQL\n");
    }

    my $charity = shift;
    unless($stmt->execute(
        $charity->{"name"},
        $charity->{"address_line_1"},
        $charity->{"address_line_2"},
        $charity->{"city"},
        $charity->{"postcode"},
        $charity->{"country"},
        $charity->{"telephone"},
        $charity->{"approved"},
        $charity->{"discarded"}))
    {
        print "Error executing SQL\n";
        return 0;
    }

    print "Charity name ".$charity->{"name"}." added successfully....\n";

    $stmt->finish();
#    DAO::ConnectionDao::closeDbConnection($connection);
    return 1;
}


#TODO: Test func.
#Param1: Charity ID
sub removeCharity    {
    my $charityId =  shift;

    # prepare db connection
    my $connection = DAO::ConnectionDao::getDbConnection();
    my $error;
    $connection->do("DELETE FROM employees WHERE id = '$charityId'") or $error = "Failed to delete";
#    DAO::ConnectionDao::closeDbConnection($connection);

    if(defined($error))
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

#TODO: Test func.
#Param1: Prepared statement.
sub readCharities   {
    my $stmt = shift;
    my %hash;
    while (my $row = $stmt->fetchrow_hashref())    {
        my $charity = new Data::Charity(
            $row->{"id"},
            $row->{"name"},
            $row->{"address_line_1"},
            $row->{"address_line_2"},
            $row->{"city"},
            $row->{"postcode"},
            $row->{"country"},
            $row->{"telephone"},
            $row->{"approved"},
            $row->{"discarded"});
        hashAddCharity(\%hash, $charity);
        return %hash;
    }
}


#TODO: Test func.
#Param1: Charity ID.
sub getCharity{
    my $charityId =  shift;
    my $connection = DAO::ConnectionDao::getDbConnection();

    my $sql = 'SELECT id, name, address_line_1, address_line_2, city, postcode, country, telephone, approved, discarded FROM charities WHERE id = ? ';
    my $stmt = $connection->prepare($sql);
    unless(defined($stmt))
    {
        die("Could not prepare statement for export from db\n");
    }

    unless($stmt->execute($charityId))
    {
        die "Could not retrieve charity '$charityId' from db\n";
    }

    my %hash = readCharities($stmt);
    $stmt->finish();
    return %hash;
}


#TODO: Test func.
sub getAllCharities   {
    {
        # prepare db connection
        my $connection = DAO::ConnectionDao::getDbConnection();

        my $sql = 'SELECT id, name, address_line_1, address_line_2, city, postcode, country, telephone, approved, discarded FROM charities';
        my $stmt = $connection->prepare($sql);
        unless(defined($stmt))
        {
            die("Could not prepare statement for export from db\n");
        }

        unless($stmt->execute())
        {
            die "Could not retrieve charities from db\n";
        }

        my %hash = readCharities($stmt);
        $stmt->finish();
        return %hash;
    }

}

1;