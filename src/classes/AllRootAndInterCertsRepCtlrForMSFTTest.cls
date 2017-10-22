/**

Test Case for the following Controller Extension:
    AllRootAndInterCertsReportCtlrForMSFT

**/

@isTest 
public class AllRootAndInterCertsRepCtlrForMSFTTest{

  static testMethod void validateTest() {
  
     AllRootAndInterCertsReportCtlrForMSFT pacrc = new AllRootAndInterCertsReportCtlrForMSFT();
     pacrc.getCurrentDate();
  }

}