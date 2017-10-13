
use strict;
use warnings;
#use Test::More tests => 35;
use Test::More qw(no_plan);

require Data::Charity;


my $EMPLOYEE_FILE = "dataFiles/employeeRecords.csv";
my $CHARITY_FILE = "TestData/charities.csv";

BEGIN	{

    ## ----------------------- Data::Charity -----------------------
    my $charity = Data::Charity->new('1122564','Gobaith i Ethiopia','8 Penymaes Avenue','Wrexham','Wrexham','LL12 7AP','Wales','01978 351964','1','0');

 #   my %hash = DAO::CharityDao::getCharitiesFromCSV("TestData/charities.csv");

    is(13, 13, 'check_Numbers');
 #   cmp_ok(keys %hash, 'eq',7, 'File_import_record_count'); # Count hash keys.

    ## ----------------------- Data::Charity -----------------------


    ## ----------------------- Data::Charity -----------------------


    ## ----------------------- Data::Charity -----------------------


    ## ----------------------- Data::Charity -----------------------


    ## ----------------------- Data::Charity -----------------------






    is(12.5, 12+0.5, 'addition'); #Compare numbers.
    isnt('Monday', 'MondaY', 'strings'); #Compare strings.

    like('12/20/2019',qr/..\/..\/../, 'dateFormat'); # Checks expression
    unlike('Holly Molly',qr/(\S.{11})/, 'charCount'); # Checks expression (non-space chars are <> 11).

    cmp_ok(999, 'ne', 998, 'binaryComparison'); # Compare using binary operator.

    my @days = ("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday",);
    my %months = ("Jan"=>1,"Mar"=>3,"Feb"=>2,"Apr"=>4,"May"=>5,"Jun"=>6,
        "Jul"=>7,"Aug"=>8,"Sep"=>9,"Oct"=>10,"Nov"=>11,"Dec"=>12,);

    cmp_ok(scalar @days, 'eq',7, 'countArray'); # Count array.
    cmp_ok(keys %months, 'ne',11, 'countHash'); # Count hash keys.

    #can_ok('percentOwnership', ('printOut','addition','multiple',)); # Check if module has implemented specified methods.



    #------------------- Non working tests ----------------------

    #    ref((DAO::CharityDao::getAllCharities) eq 'HASH');

    #    is(new Employee, undef, 'no params passed');

    #    my $empl = new Employee('on','tw','th','fo','fi','si',);
    #    isa_ok($empl, 'Employee'); #TODO: Fix this test.

    #    is($empl->getName(),'on','got name successfully');

    #isa_ok(@days, Array, 'checkType') or diag('Not working.'); #TODO: Read about this.

    #is_deeply($got, $expected, $testName); # Compares data structures (but not the data within).

    #fail($testName); #
 #  is($empl->new(),undef, 'no params passed');

    #TODO: Check-out Test::Unit and Test::Class (a port of JUnit) for OO testing.


}

