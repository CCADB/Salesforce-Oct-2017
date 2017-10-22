/**

Test Case for the following Controller Extension:
CCAInformationReportController

**/

@isTest 
public class CAInformationReportControllerTest{

  static testMethod void validateTest() {
  
  PageReference pref = Page.CAInformationReport;
  Test.setCurrentPage(pref);
  
  CAInformationReportController pacrc = new CAInformationReportController();
  
  }

}