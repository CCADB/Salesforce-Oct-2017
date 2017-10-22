/**

Test Case for the following Controller Extension:
PublicIntermediateCertsRevokedController

**/

@isTest 
public class PublicIntermediateCertsRevokedCtlrTest{

  static testMethod void validateTest() {
  
  PageReference pref = Page.PublicIntermediateCertsRevoked;
  Test.setCurrentPage(pref);
  
  PublicIntermediateCertsRevokedController pacrc = new PublicIntermediateCertsRevokedController();
  
  }

}