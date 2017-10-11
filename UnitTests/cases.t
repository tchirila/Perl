use strict;
use warnings;

use Test::More qw(no_plan);

BEGIN	{

    ## ----------------------- DAO modules -----------------------
    use_ok ('DAO::CharityDao'); #Test module implementation.
    can_ok('DAO::CharityDao', ('getCharitiesFromCSV','hashAddCharity','hashGetCharity','hashRemoveCharity',
            'addCharity','removeCharity','readCharities','getCharity','getAllCharities',)); #Check sub-routine implementations.


    use_ok ('DAO::ConnectionDao'); #Test module implementation.
    can_ok('DAO::ConnectionDao', ('getDbConnection','isValid','closeDbConnection',)); #Check sub-routine implementations.


    #TODO: To be fixed. Failing test.
    use_ok ('DAO::ContributionDao'); #Test module implementation.
    can_ok('DAO::ContributionDao', ('getAllContributionsForEmployeeId','readContributions','addContribution',
            'validateInput', 'getAllContributionsForEmployeeIdFromCSV','hashAddContribution','addContributionToCSV',)); #Check sub-routine implementations.


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
            'setCountry','getTel', 'setTel', 'getApprovalStatus', 'setApprovalStatus','getDiscardStatus','setDiscardStatus',));

    use_ok('Data::Contribution');
    can_ok('Data::Contribution', ('new','setType','setContPc','setContAmount','setSalary','setProcessDate',
            'setEffetiveDate','setCharityId','setEmployeesId','getType','getContPc','getContAmount','getSalary',
            'getProcessDate','getEffectiveDate','getCharityId','getEmployeesId','getId',));

    use_ok('Data::Employee');
    can_ok('Data::Employee',('new','getName','setName','getNumber','setNumber','getDOB','setDOB','getSalary',
            'setSalary','getEmployerContribution','setEmployerContribution','getEmployeeContribution',
            'setEmployeeContribution','getEmployeeRole','setEmployeeRole','getEmployeePassword','setEmployeePassword',));

    use_ok('Data::ProcessHistory');
    can_ok('Data::ProcessHistory',('new','print_details','setProcessDate','getProcessDate','setUserStarted',
            'getUserStarted','setSuccessful','getSuccessful','setContributions','getContributions','setType','getType',));

    ## ----------------------- Contribution modules -----------------------
    #TODO: To be fixed. Failing test.
    use_ok('Contribution::ContributionEngine');
    can_ok('Contribution::ContributionEngine',('generateAnnualAnniversaryContributions','updateSystemProcessRecords',
            'getMissingAnnualContrDatesForEmployee','getMissingMnthContrDates',));

    ## ----------------------- Utilities modules -----------------------
    #TODO: To be fixed. Failing test.
    use_ok('Utilities::Time');
    #TODO: To be fixed. Failing test.
    can_ok('Utilities::Time' ,('getCurrentTimestamp','setMonth','setDay','getCurrentDate','getCurrentTimestampTime',));


	
}
