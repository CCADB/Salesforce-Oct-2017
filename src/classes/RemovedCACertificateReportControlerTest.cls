/**

Test Case for the following Controller Extension:
RemovedCACertificateReportController

**/

@isTest 
public class RemovedCACertificateReportControlerTest{

  static testMethod void validateTest() {
  
  PageReference pref = Page.RemovedCACertificateReportCSVFormat;
  Test.setCurrentPage(pref);

  RemovedCACertificateReportController pacrc = new RemovedCACertificateReportController();
  
  }

}