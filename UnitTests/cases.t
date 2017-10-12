use strict;
use warnings;
use Test::More qw(no_plan);
use Test::Exception;


BEGIN	{

    ## ----------------------- DAO modules -----------------------
    use_ok ('DAO::CharityDao'); #Test module implementation.
    can_ok('DAO::CharityDao', ('getCharitiesFromCSV','hashAddCharity','hashGetCharity','hashRemoveCharity',
            'addCharity','removeCharity','readCharities','getCharity','getAllCharities',)); #Check sub-routine implementations.


    use_ok ('DAO::ConnectionDao'); #Test module implementation.
    can_ok('DAO::ConnectionDao', ('getDbConnection','isValid','closeDbConnection',)); #Check sub-routine implementations.


    #TODO: To be fixed. Failing test.
    use_ok ('DAO::ContributionDao'); #Test module implementation.
    can_ok('DAO::ContributionDao', ('getAllContributionsForEmployeeNumber','readContributions','addContribution',
            'validateInput', 'getAllContributionsForEmployeeIdFromCSV','addContributionToCSV','readContributionsArray',
        'getAllContributions',)); #Check sub-routine implementations.


    #TODO: To be fixed. Failing test.
    use_ok ('DAO::EmployeeDao'); #Test module implementation.
    #TODO: To be fixed. Failing test.
    can_ok('DAO::EmployeeDao', ('getEmployeesFromCSV','hashGetEmployee','hashRemoveEmployee','hashAddEmployee',
            'addEmployee','removeEmployee','readEmployees', 'getEmployee', 'getAllEmployees',)); #Check sub-routine implementations.

    #TODO: To be fixed. Failing test.
    use_ok ('DAO::ProcessHistoryDao'); #Test module implementation.
    #TODO: To be fixed. Failing test.
    can_ok('DAO::ProcessHistoryDao', ('getAProcessHistory','getAllProcessHistory','removeProcess','addProcess',)); #Check sub-routine implementations.

    ## ----------------------- Data modules -----------------------
    use_ok('Data::Charity');
    can_ok('Data::Charity',('new','getId', 'setId','getName','setName', 'getAddressLine1','setAddressLine1',
            'getAddressLine2','setAddressLine2','getCity','setCity','getPostCode','setPostCode','getCountry',
            'setCountry','getTel','setTel','getApprovalStatus','setApprovalStatus','getDiscardStatus','setDiscardStatus',));

    use_ok('Data::Contribution');
    can_ok('Data::Contribution', ('new','setType','setContPc','setContAmount','setSalary','setProcessDate',
            'setEffetiveDate','setCharityId','setEmployeesId','getType','getContPc','getContAmount','getSalary',
            'getProcessDate','getEffectiveDate','getCharityId','getEmployeesId','getId',));

    use_ok('Data::Employee');
    can_ok('Data::Employee',('new','getName','setName','getNumber','setNumber','getDOB','setDOB','getSalary',
        'setSalary','getEmployerContribution','setEmployerContribution','getEmployeeContribution',
        'setEmployeeContribution','getEmployeeRole','setEmployeeRole','getEmployeePassword','setEmployeePassword',
        'getCharityId','setCharityId','getStartDate','setStartDate'));

    use_ok('Data::ProcessHistory');
    can_ok('Data::ProcessHistory',('new','print_details','setProcessDate','getProcessDate','setUserStarted',
            'getUserStarted','setSuccessful','getSuccessful','setContributions','getContributions','setType','getType',));

    ## ----------------------- Contribution modules -----------------------
    #TODO: To be fixed. Failing test.
    use_ok('Contribution::ContributionEngine');
    can_ok('Contribution::ContributionEngine',('generateAnnualAnniversaryContributions','updateSystemProcessRecords',
            'getMissingAnnualContrDatesForEmployee','getMissingMnthContrDates','getAnnualContribution','setAnnualContribution'));

    ## ----------------------- Utilities modules -----------------------
    #TODO: To be fixed. Failing test.
    use_ok('Utilities::Time');
    #TODO: To be fixed. Failing test.
    can_ok('Utilities::Time' ,('getCurrentTimestamp','setMonth','setDay','getCurrentDate','getCurrentTimestampTime',));


    ## ----------------------- Data::Charity -----------------------
    my $charity = Data::Charity->new('1122564','Gobaith i Ethiopia','8 Penymaes Avenue','Wrexham','Wrexham','LL12 7AP','Wales','01978 351964','1','0');
    ok( defined $charity && $charity->isa('Data::Charity'), 'Charity Object defined & blessed.');

    is($charity->getId, '1122564', 'Charity::getId() returns ID.');
    is($charity->setId('0000001'), '0000001', 'Charity::setId() changes ID.');
    is($charity->setId(), undef, 'Charity::setId() \'undef\' on NULL param.');

    is($charity->getName, 'Gobaith i Ethiopia', 'Charity::getName() returns name.');
    is($charity->setName('Hope for Ethiopia'), 'Hope for Ethiopia', 'Charity::setName() changes name.');
    is($charity->setName(), undef, 'Charity::setName() \'undef\' on NULL param.');

    is($charity->getAddressLine1, '8 Penymaes Avenue', 'Charity::getAddressLine1() returns AdressLine1.');
    is($charity->setAddressLine1('8 Penymaes Ave.'), '8 Penymaes Ave.', 'Charity::setAddressLine1() changes AdressLine1.');
    is($charity->setAddressLine1(), undef, 'Charity::setAddressLine1() \'undef\' on NULL param.');

    is($charity->getAddressLine2, 'Wrexham', 'Charity::getAddressLine2() returns AdressLine2.');
    is($charity->setAddressLine2('Llanbradach'), 'Llanbradach', 'Charity::setAddressLine2() change AdressLine2.');
    is($charity->setAddressLine2(), undef, 'Charity::setAddressLine2() \'undef\' on NULL param.');

    is($charity->getCity, 'Wrexham', 'Charity::getCity() returns city.');
    is($charity->setCity('Caerphilly'), 'Caerphilly', 'Charity::setCity() change city.');
    is($charity->setCity(), undef, 'Charity::setCity() \'undef\' on NULL param.');

    is($charity->getPostCode, 'LL12 7AP', 'Charity::getPostCode() returns postcode.');
    is($charity->setPostCode('CF83 1JD'), 'CF83 1JD', 'Charity::setPostCode() change postcode.');
    is($charity->setPostCode(), undef, 'Charity::setPostCode() \'undef\' on NULL param.');

    is($charity->getCountry, 'Wales', 'Charity::getCountry() returns country.');
    is($charity->setCountry('Cymru'), 'Cymru', 'Charity::setCountry() change country.');
    is($charity->setCountry(), undef, 'Charity::setCountry() \'undef\' on NULL param.');

    is($charity->getTel, '01978 351964', 'Charity::getTel() returns telephone.');
    is($charity->setTel('01978 000064'), '01978 000064', 'Charity::setTel() change telephone.');
    is($charity->setTel(), undef, 'Charity::setTel() \'undef\' on NULL param.');

    is($charity->getApprovalStatus, '1', 'Charity::getApprovalStatus() returns approval status.');
    is($charity->setApprovalStatus('0'), '0', 'Charity::setApprovalStatus() change approval status.');
    is($charity->setApprovalStatus(), undef, 'Charity::setApprovalStatus() \'undef\' on NULL param.');

    is($charity->getDiscardStatus, '0', 'Charity::getDiscardStatus() returns discard status.');
    is($charity->setDiscardStatus('1'), '1', 'Charity::setDiscardStatus() change discard status.');
    is($charity->setDiscardStatus(), undef, 'Charity::setDiscardStatus() \'undef\' on NULL param.');

    ## ----------------------- DAO::CharityDao -----------------------
    my $charity_file = "UnitTests/Testdata/charities.csv";
    my $invalid_charity_file = "dir/UnitTests/Testdata/charities.csv";
    my $newCharity = Data::Charity->new('225971','British Heart Foundation','180 Hampstead Road','*****','London','NW1 7AW','UK','020 7554 0000','1','0');

    my %hash = DAO::CharityDao::getCharitiesFromCSV($charity_file);
    isnt(DAO::CharityDao::getCharitiesFromCSV($charity_file),undef,'CharityDao::getCharitiesFromCSV() does not return \'undef\'.');
    cmp_ok( keys %hash,'eq',7, 'CharityDao::getCharitiesFromCSV() read all records from file.');

    dies_ok(sub {DAO::CharityDao::getCharitiesFromCSV($invalid_charity_file)}, 'CharityDao::getCharitiesFromCSV() dies: Invalid file.');
    dies_ok(sub {DAO::CharityDao::getCharitiesFromCSV()}, 'CharityDao::getCharitiesFromCSV() dies: NULL param.');

    DAO::CharityDao::hashAddCharity(\%hash,$newCharity);
    is(%hash->{$newCharity->getId()}->getName(),'British Heart Foundation', 'CharityDao::hashAddCharity() added charity to hash,');

    is_deeply(DAO::CharityDao::hashGetCharity(\%hash, '225971'), $newCharity, 'CharityDao::hashGetCharity() valid returned data structure.' );
    is(DAO::CharityDao::hashGetCharity(\%hash, '000000'), undef, 'CharityDao::hashGetCharity() return \'undef\' when invalid param passed.');

    my $count = keys %hash; #hash size = 8
    DAO::CharityDao::hashRemoveCharity(\%hash, $newCharity->getId);
    is($count - keys %hash, 1, 'CharityDao::hashRemoveCharity() 1 charity removed from hash.');

    my $empl = Data::Employee->new('7','Said Yousef','992','1980-03-22','85500','2.2','14.5','E','password992','1154109','2010-04-01','0.5');
    ok( defined $empl && $empl->isa('Data::Employee'), 'Employee Object defined & blessed.');



    ## ----------------------- Data::Employee -----------------------
    # id,Name,number,DOB,salary,employer_contribution,employee_contribution,role,pass,charity,start_date,annual_contr
    my $empl = Data::Employee->new('7','Said Yousef','992','1980-03-22','85500','2.2','14.5','E','password992','1154109','2010-04-01','0.5');
    ok( defined $empl && $empl->isa('Data::Employee'), 'Employee Object defined & blessed.');

    is($empl->getId, '7', 'Employee::getId() returns ID.');
    is($empl->setId('8'), '8', 'Employee::setId() change ID.');
    is($empl->setId(), undef, 'Employee::setId() \'undef\' on NULL param.');

    is($empl->getName, 'Said Yousef', 'Employee::getName() returns ID.');
    is($empl->setName('Said Yousef Said'), 'Said Yousef Said', 'Employee::setName() change name.');
    is($empl->setName(), undef, 'Employee::setName() \'undef\' on NULL param.');









    ## ---------------- DB CONNECTION SUB-ROUTINES -----------------
    ## ----------------------- Data::Employee -----------------------
#    # #TODO: Below units require db connection to test. ----- DAO::CharityDao ------
#    is( DAO::CharityDao::addCharity($newCharity), 1, 'CharityDao::addCharity() add chatity to db.');
#    is( DAO::CharityDao::addCharity(), undef, 'CharityDao::addCharity() \'undef\' on NULL param.');
#
#    is( DAO::CharityDao::removeCharity($newCharity->getId()), 1, 'CharityDao::removeCharity() delete charity from db.');
#    is( DAO::CharityDao::removeCharity('9999'), 0, 'CharityDao::removeCharity() delete (INVALID) charity from db.');
#    is( DAO::CharityDao::removeCharity(), undef, 'CharityDao::removeCharity()  \'undef\' on NULL param.');
#
#    my %dbHash = DAO::CharityDao::readCharities($charity_file);
#    my $stmt1 = DAO::ConnectionDao::getDbConnection()->prepare('SELECT * FROM charities');
#    isnt(DAO::CharityDao::readCharities($stmt1),undef,'CharityDao::readCharities() does not return \'undef\'.');
#    cmp_ok( keys %dbHash,'eq',7, 'CharityDao::readCharities() read all records from file.'); ##TODO: update count (7) to reflect db table record count before testing.
#
#
#    my $dbCharity = DAO::CharityDao::getCharity('1122564');
#    ok( defined $dbCharity && $dbCharity->isa('Data::Charity'), 'CharityDao::getCharity returns defined & blessed charity object.' );
#    is(DAO::CharityDao::getCharity(),undef,'CharityDao::getCharity() returns \'undef\'on NULL param.');
#
#    isa_ok(DAO::CharityDao::getAllCharities(), 'HASH' , 'CharityDao::getAllCharities() returns hash value.');
#    my %dbHash2 = DAO::CharityDao::getAllCharities();
#    is(%dbHash2, 7, 'CharityDao::getAllCharities() returns all records from db table.');##TODO: update count (7) to reflect db table record count before testing.
#









}

done_testing();
