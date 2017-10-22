/**

Test Case for the following Controller Extension:
IncludedCACertificateReportCtlrForMSFT

**/

@isTest 
public class IncludedCACertificateReportTestForMSFT{

  static testMethod void validateTest() {
  
       PageReference pref = Page.IncludedCACertificateReportForMSFTCSV;
       Test.setCurrentPage(pref);
  
      IncludedCACertificateReportCtlrForMSFT certs = new IncludedCACertificateReportCtlrForMSFT();
  
  }

}