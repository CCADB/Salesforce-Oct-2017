/**************************************************************************************

Test Case for the following Controller Extensions:

MigrateCertBatchController
MigrateCertBatchUpdateCert
MigrateCertsBatch
MigrateCertBatchVF

**/

@isTest(SeeAllData = false) 
public class MigrateCertBatchControllerTest {
    
    static testmethod void myTestControllerMethods(){
        MigrateCertBatchController batchController = new MigrateCertBatchController();
        batchController.setprocessSelection('Root Certificates');
        System.assertEquals('Root Certificates', batchController.getprocessSelection()); 
        batchController.getItems();
    }
    
    static testMethod void myTestForMigrateCertBatchParentDoesNotExist() { 
           
     createTestData();
     createMigrateCerts(1); 
                
     // *************************** START PROCESS ***********************************      
        
        // Start the test
        
        
        
        MigrateCertBatchController batchController = new MigrateCertBatchController();    
        batchController.setprocessSelection('Intermediate Certificates');
        batchController.prepareCerts();
        Test.startTest();
        
        try{
            batchController.startBatch();
        }catch(Exception e){}
        
        
         // End the test
         Test.stopTest();
     
       // ***************************** END PROCESS ***********************************
               
    }
    
    static testMethod void myTestForMigrateCertBatchParentDoesNotExist2() { 
           
     createTestData();
     createMigrateCerts(1); 
                
     // *************************** START PROCESS ***********************************      
        
        
        
        
        MigrateCertBatchController batchController = new MigrateCertBatchController();    
        
        batchController.setprocessSelection('Root Certificates');
        batchController.prepareCerts();
        // Start the test
        Test.startTest();
        try{
        batchController.startBatch();
         }catch(Exception e){}
         // End the test
         Test.stopTest();
     
       // ***************************** END PROCESS ***********************************
               
    }
 
  static testMethod void myTestForMigrateCertBatchParentExist() { 
        
           createTestData();
           createMigrateCerts(2);
           
    // *************************** START PROCESS ***********************************      
        
        
        
        
        MigrateCertBatchController batchController = new MigrateCertBatchController();      
        batchController.setprocessSelection('Intermediate Certificates');
        batchController.prepareCerts();
        // Start the test
        Test.startTest();
        try{
        batchController.startBatch();
        }catch(Exception e){}
         // End the test
         Test.stopTest();
     
       // ***************************** END PROCESS ***********************************
               
    }
    
    static testMethod void myTestForMigrateCertBatchParentExist2() { 
        
           createTestData();
           createMigrateCerts(2);
           
    // *************************** START PROCESS ***********************************      
        
        
        
        
        MigrateCertBatchController batchController = new MigrateCertBatchController();      
        batchController.setprocessSelection('Root Certificates');
        batchController.prepareCerts();
        // Start the test
        Test.startTest();
        try{
        
        batchController.startBatch();
        }catch(Exception e){}
         // End the test
         Test.stopTest();
     
       // ***************************** END PROCESS ***********************************
               
    }
 
 
  static testMethod void myTestForMigrateCertBatchPreparecerts() { 
   
             createTestData();
             createMigrateCerts(3);
 
     // system.debug('accountLst='+accountLst);
                
     // *************************** START PROCESS ***********************************      
        
        
        
        
        MigrateCertBatchController batchController = new MigrateCertBatchController();      
        batchController.setprocessSelection('Intermediate Certificates');
        batchController.prepareCerts();
        // Start the test
        Test.startTest();
        try{
        
        batchController.startBatch();
        }catch(Exception e){}
         // End the test
         Test.stopTest();
     
       // ***************************** END PROCESS ***********************************
               
    }
    
   static testMethod void myTestForMigrateCertBatchPreparecerts2() { 
   
             createTestData();
             createMigrateCerts(3);
 
     // system.debug('accountLst='+accountLst);
                
     // *************************** START PROCESS ***********************************      
        
        
        
        
        MigrateCertBatchController batchController = new MigrateCertBatchController();      
        batchController.setprocessSelection('Root Certificates');
        batchController.prepareCerts();
        // Start the test
        Test.startTest();
        try{
        batchController.startBatch();
        }catch(Exception e){}
         // End the test
         Test.stopTest();
     
       // ***************************** END PROCESS ***********************************
               
    }
    
    //testmethod for "populateInterCertAccount" method of "MigrateCertBatchHelper" apex class
    static testmethod void testMigrateCertBatchHelper1(){
        // create the owner account  - record type = Owner
         Account ownerAccount = getownerAccount();
         insert ownerAccount;
         ownerAccount.status__c = 'Included';
         update ownerAccount;
        Migrate_Certs__c migrateCert2 = getMigrateCert2();
         insert migrateCert2;
         migrateCert2.processing_status__c = 'Migration Successful';
         migrateCert2.X_509_Certificate_PEM__c = PEMinfo;
         update migrateCert2;
          
         String recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Root Certificate').getRecordTypeID();
        MigrateCertBatchHelper.populateInterCertAccount(ownerAccount, 'certName', 'pemInfo', ownerAccount.Id, recordTypeId, migrateCert2);
        MigrateCertBatchHelper.populateInterCertAccount(new Account(), 'certName', 'pemInfo', ownerAccount.Id, recordTypeId, migrateCert2);
        
        MigrateCertBatchHelper.populateRootCertAccount(ownerAccount.Id, new Account(), 'pemInfo');
        
        Account existingAcc = new Account(Name = 'test', Certificate_Subject_Common_Name__c = 'test', 
        Certificate_Subject_Organization__c = 'test', Certificate_Subject_Organization_Unit__c = 'test',
        Certificate_Issuer_Organization__c = 'test', Certificate_Issuer_Organizational_Unit__c = 'test',
        Subject__c = 'test', SHA_1_Fingerprint__c = 'test', SHA_256_Fingerprint__c = 'test', Certificate_ID__c = 'test',
        Valid_To_GMT__c = Date.today(), Certificate_Serial_Number__c = '123', Signature_Hash_Algorithm__c = 'unknown',
        Basic_Constraints__c = 'test', OCSP_URL_s__c = 'bit.ly/abc',
        CRL_URL_s__c = 'bit.ly/pqr');
        
        Account migrateAcc = new Account(name = null, Certificate_Subject_Common_Name__c = null, 
        Certificate_Subject_Organization__c = null, Certificate_Subject_Organization_Unit__c = null,
        Certificate_Issuer_Organization__c = null, Certificate_Issuer_Organizational_Unit__c = null,
        Subject__c = null, SHA_1_Fingerprint__c = null, SHA_256_Fingerprint__c = null, Certificate_ID__c = null,
        Valid_To_GMT__c = null, Certificate_Serial_Number__c = null, Signature_Hash_Algorithm__c = null);
        
        MigrateCertBatchHelper.CheckForNullFields(existingAcc , migrateAcc);
        
    }
 
 static String PEMinfo;
 
 public static void createTestData(){
 
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
                      
                      
                      
                                                                 
  /*****************************************************************************************************
  
  Axay, you can use following data for PEM info. This data is wrongly constructed and will cause the program to go into error conditions.
  
     PEMinfo = '-----BEGIN CERTIFICATE-----' +
               'MIIDg6P3qMZLWh1K8F/30ltoN10igQ35y' +
               'Bx4GG+Ub/zMhkrtTClipcItkEwu7fHEdZN6/wQKh' +
               '-----END CERTIFICATE-----'; 
               
               
     PEMinfo = '-----BEGIN ' +
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
               
     PEMinfo = '-----BEGIN CERTIFICATE BEGIN CERTIFICATE-----' +
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
  
  
  ******************************************************************************************************/   
  
     // create the owner account  - record type = Owner
     Account ownerAccount = getownerAccount();
     insert ownerAccount;
     ownerAccount.status__c = 'Included';
     update ownerAccount;
        
     // create the child accounts - record type = Root
     Account rootAccount1 = getrootAccount1(ownerAccount.id);
     insert rootAccount1;
     rootAccount1.status__c = 'Included';
     update rootAccount1;
     Account rootAccount2 = getrootAccount2(ownerAccount.id);
     insert rootAccount2;
     rootAccount2.status__c = 'Included';
     update rootAccount2;
     Account rootAccount3 = getrootAccount3(ownerAccount.id);
     insert rootAccount3;
     rootAccount3.status__c = 'Included';
     update rootAccount3;
    /* 
     // create the intermediate certs to migrate
     Migrate_Certs__c migrateCert2 = getMigrateCert2();
     insert migrateCert2;
     migrateCert2.processing_status__c = 'Migration Successful';
     migrateCert2.X_509_Certificate_PEM__c = PEMinfo;
     update migrateCert2;
     
     Migrate_Certs__c migrateCert3 = getMigrateCert3();
     insert migrateCert3;
     migrateCert3.processing_status__c = 'Migration Failure';
     migrateCert3.X_509_Certificate_PEM__c = PEMinfo;
     update migrateCert3;
*/
 
 }


 public static Migrate_Certs__c  createMigrateCerts(Integer testScenario) {
     Migrate_Certs__c migrateCert1 = getMigrateCert1();
     insert migrateCert1;
     migrateCert1.processing_status__c = 'Not Processed';
     migrateCert1.X_509_Certificate_PEM__c = PEMinfo;
     
     if(testScenario ==2)
     {
           migratecert1.Parent_CA_Owner_Certificate__c ='';
     }
     
     if(testScenario ==3)
     {
     migrateCert1.Certificate_Processed__c = True;
     }
     update migrateCert1;
     return migrateCert1;
 }

    
    public static Account getownerAccount()
    {
        Account ownerAccount2 = new Account();
        ownerAccount2.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CA Owner').getRecordTypeID();
        ownerAccount2.name = 'ABC Inc';
        ownerAccount2.type = 'Owner';
        ownerAccount2.CA_Email_Alias_1__c='EmailAlias1@Company.junk';
        ownerAccount2.CA_Email_Alias_2__c='EmailAlias2@Company.junk';
        ownerAccount2.website  = 'https//www.test.com';
        ownerAccount2.valid_From_GMT__c= date.today()+1;
        ownerAccount2.valid_to_GMT__c= date.today()+10;
        ownerAccount2.company_website__c=  'https//www.test.com';
        ownerAccount2.organizational_type__c=  'Organizational Type';
        ownerAccount2.geographic_focus__c=  'Geographic focus';
        ownerAccount2.status__c = 'Included';
        return ownerAccount2;
    }

    public static Account getrootAccount1(ID ownerAccountId)
    {
        Account rootAccount = new Account();
        rootAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Root Certificate').getRecordTypeID();
        rootAccount.name = 'ABC Inc Root 1';
        rootAccount.parentid = ownerAccountId;
        rootAccount.type = 'Root';
        rootAccount.valid_From_GMT__c= date.today()+1;
        rootAccount.valid_to_GMT__c= date.today()+10;
        rootAccount.SHA_1_fingerprint__c= '12:34:56:78:90:12:34:56:78:90:12:34:56:78:90:12:34:56:78:90';
        rootAccount.Trust_Bits__c = 'Email';
        rootAccount.Standard_Audit__c = 'http://www.google.com/StandardAudit.pdf';
        rootAccount.Standard_Audit_Statement_Date__c = date.today(); 
        rootAccount.Standard_Audit_Type__c = 'WebTrust';
        rootAccount.BR_Audit__c = 'http://www.google.com/BRAudit.pdf';
        rootAccount.BR_Audit_Statement_Date__c = date.today();
        rootAccount.BR_Audit_Type__c = '';
        rootAccount.EV_Audit__c = 'http://www.google.com/EVAudit.pdf';
        rootAccount.EV_Audit_Statement_Date__c = date.today();
        rootAccount.EV_Audit_Type__c = '';
        rootAccount.ev_policy_oid_s__c = '';
        rootAccount.status__c = 'Included';
        return rootAccount;
    }
    
    public static Account getrootAccount2(ID ownerAccountId)
    {
        Account rootAccount = new Account();
        rootAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Root Certificate').getRecordTypeID();
        rootAccount.name = 'ABC Inc Root 2';
        rootAccount.parentid = ownerAccountId;
        rootAccount.type = 'Root';
        rootAccount.valid_From_GMT__c= date.today()+1;
        rootAccount.valid_to_GMT__c= date.today()+10;
        rootAccount.SHA_1_fingerprint__c= '12:34:56:78:90:12:34:56:78:90:12:34:56:78:90:12:34:56:78:90';
        rootAccount.Trust_Bits__c = 'Email;Websites';
        rootAccount.Standard_Audit__c = 'http://www.google.com/StandardAudit.pdf';
        rootAccount.Standard_Audit_Statement_Date__c = date.today();
        rootAccount.Standard_Audit_Type__c = 'WebTrust';
        rootAccount.BR_Audit__c = 'http://www.google.com/BRAudit.pdf';
        rootAccount.BR_Audit_Statement_Date__c = date.today(); 
        rootAccount.BR_Audit_Type__c = 'WebTrust';
        rootAccount.EV_Audit__c = 'http://www.google.com/EVAudit.pdf';
        rootAccount.EV_Audit_Statement_Date__c = date.today();
        rootAccount.EV_Audit_Type__c = '';
        rootAccount.ev_policy_oid_s__c = '';
        rootAccount.status__c = 'Included';
        return rootAccount;
    }
    
    public static Account getrootAccount3(ID ownerAccountId)
    {
        Account rootAccount = new Account();
        rootAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Root Certificate').getRecordTypeID();
        rootAccount.name = 'ABC Inc Root 3';
        rootAccount.parentid = ownerAccountId;
        rootAccount.type = 'Root';
        rootAccount.valid_From_GMT__c= date.today()+1;
        rootAccount.valid_to_GMT__c= date.today()+10;
        rootAccount.SHA_1_fingerprint__c= '12:34:56:78:90:12:34:56:78:90:12:34:56:78:90:12:34:56:78:90';
        rootAccount.Trust_Bits__c = 'Email;Websites';
        rootAccount.Standard_Audit__c = 'http://www.google.com/StandardAudit.pdf';
        rootAccount.Standard_Audit_Statement_Date__c = date.today();
        rootAccount.Standard_Audit_Type__c = 'WebTrust';
        rootAccount.BR_Audit__c = 'http://www.google.com/BRAudit.pdf';
        rootAccount.BR_Audit_Statement_Date__c = date.today();
        rootAccount.BR_Audit_Type__c = 'WebTrust';
        rootAccount.EV_Audit__c = 'http://www.google.com/EVAudit.pdf';
        rootAccount.EV_Audit_Statement_Date__c = date.today(); 
        rootAccount.EV_Audit_Type__c = 'Webtrust';
        rootAccount.ev_policy_oid_s__c = 'Some data';
        rootAccount.status__c = 'Included';
        return rootAccount;
    }
    
    public static Migrate_Certs__c getMigrateCert1()
    {   
        Migrate_Certs__c migrateCert = new Migrate_Certs__c(); 
        migrateCert.name = 'Intermediate Cert for Root 1';
        migrateCert.Parent_CA_Owner_Certificate__c = 'ABC Inc Root 1';
        migrateCert.Revocation_Status__c = 'Not Revoked';
        migrateCert.Standard_Audit__c = 'http://www.google.com/StandardAudit.pdf';
        migrateCert.Standard_Audit_Statement_Date__c = date.today();
        migrateCert.Standard_Audit_Type__c = 'WebTrust';
        migrateCert.BR_Audit__c = 'http://www.google.com/BRAudit.pdf';
        migrateCert.BR_Audit_Statement_Date__c = date.today();
        migrateCert.BR_Audit_Type__c = 'WebTrust';
        migrateCert.EV_Audit__c = 'http://www.google.com/EVAudit.pdf';
        migrateCert.EV_Audit_Statement_Date__c = date.today(); 
        migrateCert.EV_Audit_Type__c = 'Webtrust';
        migrateCert.Certificate_Policy_CP__c = 'cp.pdf';
        migrateCert.Certification_Practice_Statement_CPS__c = 'cps.pdf';
        return migrateCert; 
    }
    
    public static Migrate_Certs__c getMigrateCert2()
    {   
        Migrate_Certs__c migrateCert = new Migrate_Certs__c();
        migrateCert.name = 'Intermediate Cert for Root 2';
        migrateCert.Parent_CA_Owner_Certificate__c = 'ABC Inc Root 2';
        migrateCert.Revocation_Status__c = 'Not Revoked';
        migrateCert.Standard_Audit__c = 'http://www.google.com/StandardAudit.pdf';
        migrateCert.Standard_Audit_Statement_Date__c = date.today();
        migrateCert.Standard_Audit_Type__c = 'WebTrust';
        migrateCert.BR_Audit__c = 'http://www.google.com/BRAudit.pdf';
        migrateCert.BR_Audit_Statement_Date__c = date.today();
        migrateCert.BR_Audit_Type__c = 'WebTrust';
        migrateCert.EV_Audit__c = 'http://www.google.com/EVAudit.pdf';
        migrateCert.EV_Audit_Statement_Date__c = date.today(); 
        migrateCert.EV_Audit_Type__c = 'Webtrust';
        migrateCert.Certificate_Policy_CP__c = 'cp.pdf';
        migrateCert.Certification_Practice_Statement_CPS__c = 'cps.pdf';
 
        return migrateCert; 
    }
    
    public static Migrate_Certs__c getMigrateCert3()
    {   
        Migrate_Certs__c migrateCert = new Migrate_Certs__c();
        migrateCert.name = 'Intermediate Cert for Root 3';
        migrateCert.Parent_CA_Owner_Certificate__c = 'ABC Inc Root 3';
        migrateCert.Revocation_Status__c = 'Not Revoked';
        migrateCert.Standard_Audit__c = 'http://www.google.com/StandardAudit.pdf';
        migrateCert.Standard_Audit_Statement_Date__c = date.today();
        migrateCert.Standard_Audit_Type__c = 'WebTrust';
        migrateCert.BR_Audit__c = 'http://www.google.com/BRAudit.pdf';
        migrateCert.BR_Audit_Statement_Date__c = date.today();
        migrateCert.BR_Audit_Type__c = 'WebTrust';
        migrateCert.EV_Audit__c = 'http://www.google.com/EVAudit.pdf';
        migrateCert.EV_Audit_Statement_Date__c = date.today(); 
        migrateCert.EV_Audit_Type__c = 'Webtrust';
        migrateCert.Certificate_Policy_CP__c = 'cp.pdf';
        migrateCert.Certification_Practice_Statement_CPS__c = 'cps.pdf';
        return migrateCert; 
    }
    
        
 
}