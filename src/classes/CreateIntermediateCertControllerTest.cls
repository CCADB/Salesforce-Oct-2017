/**

Test Case for the following Controller Extensions:
- CreateIntermediateCertController
- X509CertificateCheckerUtility

**/

@isTest 
public class CreateIntermediateCertControllerTest{

    static String PEMinfo;

    static testmethod void testInterMediateCert2(){
    
     PEMinfo = '-----BEGIN CERTIFICATE-----' +
               'MIID2jCCAsKgAwIBAgIDAjpWMA0GCSqGSIb3DQEBBQUAMEIxCzAJBgNVBAYTAlVT' +
               'MRYwFAYDVQQKEw1HZW9UcnVzdCBJbmMuMRswGQYDVQQDExJHZW9UcnVzdCBHbG9i' +
               'YWwgQ0EwHhcNMTAwNzIyMTUwNTQyWhcNMTcwNzIxMTUwNTQyWjB3MQswCQYDVQQG' +
               'EwJVUzETMBEGA1UEChMKQWV0bmEgSW5jLjEoMCYGA1UECxMfR2VvUm9vdCBDZXJ0' +
               'aWZpY2F0aW9uIEF1dGhvcml0eTEpMCcGA1UEAxMgQWV0bmEgSW5jLiBDZXJ0aWZp' +
               'Y2F0ZSBBdXRob3JpdHkwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCQ' +
               'tON+e/RhUkbAcFUsFadmEhsZfoHvYN1fDoExp8EK6d6Ry0Yq1zpc8cFj+hT16G9F' +
               'dEERryVrT/0YINaiilnvGRxdgg7YOsxTU1/1ZGm1KGevfJ/pkVXAcBSqK9ncoRUC' +
               'Y5Xuyda2AXrICbC1Yx2fiyKyQ4HI+G9h5NUTnjgUN6kXuTYV1idYQWYXYfiUVPV4' +
               '3tkgh5nvuCF6AcGpjhgd2aHDrfhong/WihhqqojEh/Lq71qtniVtT18V/1Cnp0hO' +
               'R5JyBQDod2bikP0qIQS2UGk0lsJu7mFruqQKc7/geodCD29jX7QD9jXWvrHauYWQ' +
               'COOuVI8Vfsevh83RGJJ5AgMBAAGjgaMwgaAwHwYDVR0jBBgwFoAUwHqYaI2J+6sF' +
               'ZAwRfap9ZbjKzE4wHQYDVR0OBBYEFL7DxXHIoI1iXT0RMidDMWONKCnBMBIGA1Ud' +
               'EwEB/wQIMAYBAf8CAQAwDgYDVR0PAQH/BAQDAgEGMDoGA1UdHwQzMDEwL6AtoCuG' +
               'KWh0dHA6Ly9jcmwuZ2VvdHJ1c3QuY29tL2NybHMvZ3RnbG9iYWwuY3JsMA0GCSqG' +
               'SIb3DQEBBQUAA4IBAQA+PQPSNwgCyo3k7QnSAoZo2FrxAw5wZy2G7BFaby72m7rm' +
               'gX9QbA7RSwpL8zMv8oSoHSsMZKDcCskxAoRVa7wisjTpsgBmaVRjS5w+jDjizQG5' +
               'Sl5c7cdt+3vB6uegE4bIekPXu4nr7iSqmXIIq7x5qHKwS5F8MGMaiZtaidn66j9y' +
               '2VrM7XyAjt5hEJkXAeiMjRZXJ67SQO2K7CXK8BCakEFrznkorMEsJJaF2KagyeP5' +
               '6It8mIE+TDAcmUVYFCiRXXbLAhr1h30mGaog6P3qMZLWh1K8F/30ltoN10igQ35y' +
               'Bx4GG+Ub/zMhkrtTClipcItkEwu7fHEdZN6/wQKh' +
               '-----END CERTIFICATE-----';  
        
        Account accountSo = New Account(name='testAccount');
        insert accountSo;
        
        // create a standard controller instance 
         ApexPages.StandardController standardcontroller = new ApexPages.StandardController(accountSo);
         
         CreateIntermediateCertController createInterCertController= new CreateIntermediateCertController(standardController);
        
         PageReference pageRef = Page.CreateIntermediateCert;
         pageRef.getParameters().put('id', String.valueOf(accountSo.Id));
         Test.setCurrentPage(pageRef);
         //createInterCertController.pemInfoStr  = 'testPEM';
         createInterCertController.pemInfoStr  = PEMInfo;
         createInterCertController.submit();
         createInterCertController.parentAccountId = accountSo.id;
         createInterCertController.skip();
         createInterCertController.createIntermediateCert();
         Account parentAccount2 = getParentAccount();
         insert parentAccount2;
         createInterCertController.parentAccountId=   parentAccount2.id; 
         createInterCertController.updateIntermediateCert();
         createInterCertController.cancel(); 
         createInterCertController.cloneIntermediateCert();    
    }
    
    static testMethod void testInterMediateCert1() {
    
    User loggedInUser = [SELECT Id from User WHERE Id = :UserInfo.getUserId()];
      
      System.runAs(loggedInUser){
          
          Account acc = new Account(Name='Test Account Name223223##');
          insert acc;
         
          Contact con = new Contact(LastName = 'Contact Last Name', AccountId = acc.id);
          insert con;
      
          UserRole urole = [Select PortalType, PortalAccountId From UserRole where PortalType = 'CustomerPortal' limit 1];
          
          User user = new User();
          //user.UserRoleId = urole.Id;
          //user.ProfileID = [Select Id From Profile Where UserType = 'PowerCustomerSuccess' LIMIT 1].id;
          user.EmailEncodingKey = 'ISO-8859-1';
          user.LanguageLocaleKey = 'en_US';
          user.TimeZoneSidKey = 'America/New_York';
          user.LocaleSidKey = 'en_US';
          user.FirstName = 'first';
          user.LastName = 'last';
          user.Username = 'test@test1234098.com';   
          user.CommunityNickname = 'testUser09887123';
          user.Alias = 't1';
          user.Email = 'no@email.com';
          user.IsActive = true;
          user.ContactId = con.Id;
          
          user.ProfileID = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus Login User For CCADB' AND UserType = 'PowerCustomerSuccess' LIMIT 1].id;
          user.PortalRole = 'Manager';
          insert user;
            
        AccountShare aShare = new AccountShare();
        aShare.AccountAccessLevel = 'Edit';
        aShare.ContactAccessLevel = 'Edit';
        aShare.OpportunityAccessLevel = 'Edit';
        aShare.RowCause = 'Manual';
        aShare.AccountId = acc.Id;
        aShare.UserOrGroupId = user.Id;
        insert aShare;
        
          System.RunAs(user) {
              
                // do all of my tests
                Account acc1 = new Account(Name='Test Account123$$ CA Owner', recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CA Owner').getRecordTypeId());
                insert acc1;
              
                // create a ROOT CA
                Account rootCA = New Account();
                rootCA.recordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Root Certificate').getRecordTypeId(); 
                rootCa.name = 'testRoot';
                rootCa.parentId = acc.id;
                rootCa.X_509_Certificate_PEM__c = PEMInfo;
                rootCa.SHA_1_fingerprint__c= '12:34:56:78:90:12:34:56:78:90:12:34:56:78:90:12:34:56:78:90';
                insert rootCa;
         
                 // create intermediate CA
                 Account testAccount = New Account();
                 testAccount.name = 'New Company';
                 testAccount.recordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Intermediate Certificate').getRecordTypeId();
                 testAccount.Status__c='Removed';
                 testAccount.parentId = rootca.id;
                 testAccount.X_509_Certificate_PEM__c = PEMInfo;
                
                 insert testAccount;
             
             test.startTest();
             
                 ApexPages.StandardController standardcontroller = new ApexPages.StandardController(testAccount);
                 
                 CreateIntermediateCertController createInterCertController= new CreateIntermediateCertController(standardController);
                
                 PageReference pageRef = Page.CreateIntermediateCert;
                 pageRef.getParameters().put('id', String.valueOf(testAccount.Id));
                 Test.setCurrentPage(pageRef);
                 createInterCertController.pemInfoStr  = PEMInfo;
                 createInterCertController.submit();
                 createInterCertController.parentAccountId = testAccount.id;
                 createInterCertController.skip();
                 createInterCertController.createIntermediateCert();
                 Account parentAccount2 = getParentAccount();
                 insert parentAccount2;
                 createInterCertController.parentAccountId=   parentAccount2.id; 
                 createInterCertController.updateIntermediateCert();
                 createInterCertController.cancel(); 
                 createInterCertController.cloneIntermediateCert(); 
                 
                 Test.stoptest();
          }
      }
    
    
    }
    /*
    static testMethod void validateCreateInterCert() {
    test.startTest(); 
    
     Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
        // create owner account
        Account acc1 = new Account (
        Name = 'newAcc1',  X_509_Certificate_PEM__c = 'abc',
        recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CA Owner').getRecordTypeId()
        );  
        insert acc1;
        
        //create dummy contact
        Contact conCase = new Contact (
        AccountId = acc1.id,
        LastName = 'portalTestUserv1'
        );
        insert conCase;

        // get profile 
        Profile prfile = [select Id,name from Profile where UserType in :customerUserTypes limit 1];
        
        // create portal user, note that it has a contact which is associated with an owner account
        User newUser1 = new User(
        profileId = prfile.id,
        username = 'newUser@mozilla.com',
        email = 'pb@f.com',
        emailencodingkey = 'UTF-8',
        localesidkey = 'en_US',
        languagelocalekey = 'en_US',
        timezonesidkey = 'America/Los_Angeles',
        alias='nuser',
        lastname='lastname',
        contactId = conCase.id
        );
        insert newUser1;
        
      // execute the scenario as a portal user
       System.runAs(newUser1) {
        
        // create a ROOT CA
        Account rootCA = New Account();
        rootCA.recordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Root Certificate').getRecordTypeId(); 
        rootCa.name = 'testRoot';
        rootCa.parentId = acc1.id;
        rootCa.X_509_Certificate_PEM__c = 'abc';
        rootCa.SHA_1_fingerprint__c= '12:34:56:78:90:12:34:56:78:90:12:34:56:78:90:12:34:56:78:91';
        insert rootCa;
     
     // create intermediate CA
     Account testAccount = New Account();
     testAccount.name = 'Hello';
     testAccount.recordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Intermediate Certificate').getRecordTypeId();
     testAccount.Status__c='Removed';
     testAccount.parentId = rootca.id;
     testAccount.X_509_Certificate_PEM__c = 'abc';
    
     insert testAccount;
     
          ApexPages.StandardController standardcontroller = new ApexPages.StandardController(testAccount);
    
        

     CreateIntermediateCertController createInterCertController= new CreateIntermediateCertController(standardController);
    
     PageReference pageRef = Page.CreateIntermediateCert;
     pageRef.getParameters().put('id', String.valueOf(testAccount.Id));
     Test.setCurrentPage(pageRef);
     createInterCertController.pemInfoStr  = 'testPEM';
     createInterCertController.submit();
     createInterCertController.parentAccountId = testAccount.id;
     createInterCertController.skip();
     createInterCertController.createIntermediateCert();
     Account parentAccount2 = getParentAccount();
     insert parentAccount2;
     createInterCertController.parentAccountId=   parentAccount2.id; 
     createInterCertController.updateIntermediateCert();
     createInterCertController.cancel(); 
     createInterCertController.cloneIntermediateCert();

     
     }
 test.stoptest();

     Account accountSo = New Account(name='testAccount' );
     insert accountSo;
    
     // create the parent account  - record type = Owner
//     Account parentAccount = getParentAccount();
 //    insert parentAccount;
    
    // create a standard controller instance 
     ApexPages.StandardController standardcontroller = new ApexPages.StandardController(accountSo);
    
        

     CreateIntermediateCertController createInterCertController= new CreateIntermediateCertController(standardController);
    
     PageReference pageRef = Page.CreateIntermediateCert;
     pageRef.getParameters().put('id', String.valueOf(accountSo.Id));
     Test.setCurrentPage(pageRef);
     createInterCertController.pemInfoStr  = 'testPEM';
     createInterCertController.submit();
     createInterCertController.parentAccountId = accountSo.id;
     createInterCertController.skip();
     createInterCertController.createIntermediateCert();
     Account parentAccount2 = getParentAccount();
     insert parentAccount2;
     createInterCertController.parentAccountId=   parentAccount2.id; 
     createInterCertController.updateIntermediateCert();
     createInterCertController.cancel(); 
     createInterCertController.cloneIntermediateCert();
    
    }*/
    
      // additional test method to handle the scenario
      // when pem info is not provided by the user
      static testMethod void validateCreateInterCert2() {
    
     // create the parent account  - record type = Owner
     Account parentAccount = getParentAccount();
     insert parentAccount;
    
    // create a standard controller instance 
     ApexPages.StandardController standardcontroller = new ApexPages.StandardController(parentAccount);
    
        

     CreateIntermediateCertController createInterCertController= new CreateIntermediateCertController(standardController);
    
     PageReference pageRef = Page.CreateIntermediateCert;
     pageRef.getParameters().put('id', String.valueOf(parentAccount.Id));
     Test.setCurrentPage(pageRef);
     createInterCertController.pemInfoStr  = null;
     createInterCertController.submit();
     createInterCertController.copyParentAuditData();
     
     Id profile = [select id from profile Where Name ='Customer Community Plus Login User For CCADB' Limit 1].id;
       
       
     Contact con = new Contact(LastName ='testCon',AccountId = parentAccount.Id);
     insert con;  
              
     User user = new User(alias = 'test123', email='test123@noemail.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = profile, country='United States',IsActive =true,
            ContactId = con.Id,
            timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
    
     system.runAs(user) { 
         Account childAccount = getChildAccount();
         childAccount.parentId = parentAccount.id;
         childAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Root Certificate').getRecordTypeID();
         insert childAccount;
        
         Account childAccount1 = getChildAccount();
         childAccount1.parentId = childAccount.id;
         insert childAccount1;
         
         standardcontroller = new ApexPages.StandardController(childAccount);
    

         createInterCertController= new CreateIntermediateCertController(standardController);
        
         pageRef = Page.CreateIntermediateCert;
         pageRef.getParameters().put('id', String.valueOf(childAccount.Id));
         Test.setCurrentPage(pageRef);
         createInterCertController.copyParentAuditData();
         createInterCertController.showUpdateButton();
     }
    }
    
     public static Account getParentAccount()
    {
        Account parentAccount = new Account();
        parentAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CA Owner').getRecordTypeID();
        parentAccount.name = 'ParentAccount';
        parentAccount.type = 'Owner';
        parentAccount.phone='2128425500';
        parentAccount.website  = 'https//www.test.com';
        parentAccount.valid_From_GMT__c= date.today()+1;
        parentAccount.valid_to_GMT__c= date.today()+10;
        parentAccount.company_website__c=  'https//www.test.com';
        parentAccount.organizational_type__c=  'Organizational Type';
        parentAccount.geographic_focus__c=  'Geographic focus';
        parentAccount.primary_market_customer_base__c = 'Primary Market';
        
        return parentAccount;
    }
    
     public static Account getChildAccount()
    {
        Account parentAccount = new Account();
        parentAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Intermediate Certificate').getRecordTypeID();
        parentAccount.name = 'ChildAccount';
        parentAccount.type = 'Owner';
        parentAccount.phone='2128425500';
        parentAccount.website  = 'https//www.test.com';
        parentAccount.valid_From_GMT__c= date.today()+1;
        parentAccount.valid_to_GMT__c= date.today()+10;
        parentAccount.company_website__c=  'https//www.test.com';
        parentAccount.organizational_type__c=  'Organizational Type';
        parentAccount.geographic_focus__c=  'Geographic focus';
        parentAccount.primary_market_customer_base__c = 'Primary Market';
        
        return parentAccount;
    }
    
    
}