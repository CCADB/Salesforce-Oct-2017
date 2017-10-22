/**

Test Case for the following Controller Extension:
PublicInterCertsReadyToAddToOneCRLCtlr

**/

@isTest 
public class PublicInterCertsReadyToAddToOneCRLTest{

  static testMethod void validateTest() {
  
  PageReference pref = Page.PublicIntermediateCertsRevoked;
  Test.setCurrentPage(pref);
  
  PublicInterCertsReadyToAddToOneCRLCtlr pacrc = new PublicInterCertsReadyToAddToOneCRLCtlr();
  
  }

}