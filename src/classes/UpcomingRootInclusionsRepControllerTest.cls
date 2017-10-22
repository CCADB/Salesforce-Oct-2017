/**

Test Case for the following Controller Extension:
UpcomingRootInclusionsReportController

**/

@isTest 
public class UpcomingRootInclusionsRepControllerTest{

  static testMethod void validateTest() {
  
  PageReference pref = Page.UpcomingRootInclusionsReportCSVFormat;
  Test.setCurrentPage(pref);
  
  UpcomingRootInclusionsReportController pacrc = new UpcomingRootInclusionsReportController();
  
  }

}