/**

Test Case for the following Controller Extension:
PendingCACertificateReportController

**/

@isTest 
public class PendingCACertificateReportControllerTest{

  static testMethod void validateTest() {
  
  PageReference pref = Page.PendingCACertificateReportCSVFormat;
  Test.setCurrentPage(pref);
  
  PendingCACertificateReportController pacrc = new PendingCACertificateReportController();
  
  }

}