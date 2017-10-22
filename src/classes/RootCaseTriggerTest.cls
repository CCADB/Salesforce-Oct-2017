@isTest
public class RootCaseTriggerTest{
    /*
     * test class for method "defaultFieldsRootCaseInsert" in before insert rootcase trigger 
     */
    static testmethod void defaultFieldsRootCaseInsertTest(){    
        
        // create the parent account  - record type = Owner
         Account parentAccount = SyncParentAccountFromCaseControllerTest.getParentAccount();
         parentAccount.Name = 'parent root account 1';
         insert parentAccount;
         
         // create the contact associated with the parent account
         Contact parentContact = SyncParentAccountFromCaseControllerTest.getParentContact(parentAccount.id);
         parentContact.firstName = 'parent_firstname';
         parentContact.lastName = 'parent_lastname';
         insert parentContact;
         
         // create the child account - record type = Root
         Account childAccount = SyncParentAccountFromCaseControllerTest.getChildAccount(parentAccount.id);
         childAccount.Name = 'child root account 1';
         insert childAccount;
         
         // create a case
         Case accountCaseA = SyncParentAccountFromCaseControllerTest.getCase(parentAccount.id, parentContact.id);
         accountCaseA.request_status__c  = 'Initial Request Received';         
         insert accountCaseA;
         accountCaseA.Request_Status__c = 'Data Verified';
         update accountCaseA;
         
         // create the root case and associate it with the case
         Root_Case__c rootCaseA1 = SyncParentAccountFromCaseControllerTest.getRootCase(accountCaseA.id,parentAccount.Id,childAccount.Id);
         rootCaseA1.request_status__c   = 'Initial Request Received';         
         rootCaseA1.Apply_Standard_Audit__c = true;
         rootCaseA1.Apply_BR_Audit__c = true;
         rootCaseA1.Apply_EV_Audit__c = true;         
         rootCaseA1.Case_No__c = accountCaseA.Id;
         rootCaseA1.CA_Owner_Name_Existing__c = parentAccount.Id;
         rootCaseA1.Root_Certificate_Name_Existing__c = childAccount.Id;
         rootCaseA1.RecordTypeId = Schema.SObjectType.Root_Case__c.getRecordTypeInfosByName().get('CA Audit Update Request').getRecordTypeID();
         insert rootCaseA1;
    }
    
    /*
     * test class for method "rollupRootCaseStatusToCase" in after update rootcase trigger 
     */
    static testmethod void rollupRootCaseStatusToCaseTest(){    
        
        // create the parent account  - record type = Owner
         Account parentAccount = SyncParentAccountFromCaseControllerTest.getParentAccount();
         parentAccount.Name = 'parent root account 1';
         insert parentAccount;
         
         // create the contact associated with the parent account
         Contact parentContact = SyncParentAccountFromCaseControllerTest.getParentContact(parentAccount.id);
         parentContact.firstName = 'parent_firstname';
         parentContact.lastName = 'parent_lastname';
         insert parentContact;
         
         // create the child account - record type = Root
         Account childAccount = SyncParentAccountFromCaseControllerTest.getChildAccount(parentAccount.id);
         childAccount.Name = 'child root account 1';
         insert childAccount;
         
         // create a case
         Case accountCaseA = SyncParentAccountFromCaseControllerTest.getCase(parentAccount.id, parentContact.id);
         accountCaseA.request_status__c  = 'Initial Request Received';         
         accountCaseA.Status = 'Open';
         accountCaseA.Request_Status__c = 'Data Verified';
         insert accountCaseA;
        
         accountCaseA.Request_Status__c = 'Ready for Public Discussion';
         update accountCaseA; 
            accountCaseA.Request_Status__c = 'In Public Discussion';
         update accountCaseA; 
         
        accountCaseA.Request_Status__c = 'Pending Approval';
         update accountCaseA;
         
         accountCaseA.Request_Status__c = 'Approved, Pending Inclusion';
         update accountCaseA;
        
         // create the root case and associate it with the case
         Root_Case__c rootCaseA1 = SyncParentAccountFromCaseControllerTest.getRootCase(accountCaseA.id,parentAccount.Id,childAccount.Id);
         rootCaseA1.request_status__c   = 'Initial Request Received';         
         rootCaseA1.Apply_Standard_Audit__c = true;
         rootCaseA1.Apply_BR_Audit__c = true;
         rootCaseA1.Apply_EV_Audit__c = true;         
         rootCaseA1.Case_No__c = accountCaseA.Id;
         rootCaseA1.CA_Owner_Name_Existing__c = parentAccount.Id;
         rootCaseA1.Root_Certificate_Name_Existing__c = childAccount.Id;
         rootCaseA1.RecordTypeId = Schema.SObjectType.Root_Case__c.getRecordTypeInfosByName().get('CA Audit Update Request').getRecordTypeID();
         insert rootCaseA1;
        
        rootCaseA1.Request_Status__c = 'Approved, Pending Inclusion';
        update rootCaseA1;
        
        Test.startTest();
            rootCaseA1.Request_Status__c = 'Complete';
            update rootCaseA1;
        test.stopTest();
    }
    
    static testmethod void EnforceRequestStatusRulesForUpdatesTest(){
        // create the parent account  - record type = Owner
         Account parentAccount = SyncParentAccountFromCaseControllerTest.getParentAccount();
         parentAccount.Name = 'parent root account 1';
         insert parentAccount;
         
         // create the contact associated with the parent account
         Contact parentContact = SyncParentAccountFromCaseControllerTest.getParentContact(parentAccount.id);
         parentContact.firstName = 'parent_firstname';
         parentContact.lastName = 'parent_lastname';
         insert parentContact;
         
         // create the child account - record type = Root
         Account childAccount = SyncParentAccountFromCaseControllerTest.getChildAccount(parentAccount.id);
         childAccount.Name = 'child root account 1';
         insert childAccount;
         
         // create a case
         Case accountCaseA = SyncParentAccountFromCaseControllerTest.getCase(parentAccount.id, parentContact.id);
         accountCaseA.request_status__c  = 'Initial Request Received';         
         accountCaseA.Status = 'Open';
         accountCaseA.Request_Status__c = 'Data Verified';
         accountCaseA.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CA Owner/Root Inclusion Request').getRecordTypeID();
         insert accountCaseA;
        
         // create the root case and associate it with the case
         Root_Case__c rootCaseA1 = SyncParentAccountFromCaseControllerTest.getRootCase(accountCaseA.id,parentAccount.Id,childAccount.Id);
         rootCaseA1.RecordTypeId = Schema.SObjectType.Root_Case__c.getRecordTypeInfosByName().get('CA Owner/Root Inclusion Request').getRecordTypeID(); 
         rootCaseA1.Request_status__c   = 'Initial Request Received';         
         rootCaseA1.Apply_Standard_Audit__c = true;
         rootCaseA1.Apply_BR_Audit__c = true;
         rootCaseA1.Apply_EV_Audit__c = true;         
         rootCaseA1.Case_No__c = accountCaseA.Id;
         rootCaseA1.CA_Owner_Name_Existing__c = parentAccount.Id;
         rootCaseA1.Root_Certificate_Name_Existing__c = childAccount.Id;
         //rootCaseA1.RecordTypeId = Schema.SObjectType.Root_Case__c.getRecordTypeInfosByName().get('CA Audit Update Request').getRecordTypeID();
         insert rootCaseA1;
        
        rootCaseA1.Request_Status__c = 'Ready for Public Discussion';
        rootCaseA1.All_Fields_Verified__c = 'No';
        
        try{
            update rootCaseA1;
        }catch(Exception exp){}
    }
    
    static testmethod void EnforceRequestStatusRulesForInsertsTest(){
        
        // create the parent account  - record type = Owner
         Account parentAccount = SyncParentAccountFromCaseControllerTest.getParentAccount();
         parentAccount.Name = 'parent root account 1';
         insert parentAccount;
         
         // create the contact associated with the parent account
         Contact parentContact = SyncParentAccountFromCaseControllerTest.getParentContact(parentAccount.id);
         parentContact.firstName = 'parent_firstname';
         parentContact.lastName = 'parent_lastname';
         insert parentContact;
         
         // create the child account - record type = Root
         Account childAccount = SyncParentAccountFromCaseControllerTest.getChildAccount(parentAccount.id);
         childAccount.Name = 'child root account 1';
         insert childAccount;
         
         // create a case
         Case accountCaseA = SyncParentAccountFromCaseControllerTest.getCase(parentAccount.id, parentContact.id);
         accountCaseA.request_status__c  = 'Initial Request Received';         
         accountCaseA.Status = 'Open';
         accountCaseA.Request_Status__c = 'Data Verified';
         accountCaseA.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CA Owner/Root Inclusion Request').getRecordTypeID();
         insert accountCaseA;
        
        Root_Case__c rootCaseA1 = SyncParentAccountFromCaseControllerTest.getRootCase(accountCaseA.id,parentAccount.Id,childAccount.Id);
         rootCaseA1.RecordTypeId = Schema.SObjectType.Root_Case__c.getRecordTypeInfosByName().get('CA Owner/Root Inclusion Request').getRecordTypeID(); 
         rootCaseA1.Request_status__c   = 'Ready for Public Discussion';         
         rootCaseA1.Apply_Standard_Audit__c = true;
         rootCaseA1.Apply_BR_Audit__c = true;
         rootCaseA1.Apply_EV_Audit__c = true;         
         rootCaseA1.Case_No__c = accountCaseA.Id;
         rootCaseA1.CA_Owner_Name_Existing__c = parentAccount.Id;
         rootCaseA1.Root_Certificate_Name_Existing__c = childAccount.Id;
        try{
            insert rootCaseA1;
        } catch(Exception exp){}
        
    }
    
    static testmethod void SetAllFieldsVerifiedFieldTest(){
        Root_Case__c rootCaseA1 = new Root_Case__c();
         rootCaseA1.RecordTypeId = Schema.SObjectType.Root_Case__c.getRecordTypeInfosByName().get('CA Owner/Root Inclusion Request').getRecordTypeID(); 
         rootCaseA1.Request_status__c   = 'Ready for Public Discussion';         
         rootCaseA1.Apply_Standard_Audit__c = true;
         rootCaseA1.Apply_BR_Audit__c = true;
         rootCaseA1.Apply_EV_Audit__c = true; 
        rootCaseA1.O_From_Issuer_Field_Verified__c = 'Need Response From CA';
        rootCaseA1.OU_From_Issuer_Field_Verified__c = 'Need Response From CA';
        rootCaseA1.Certificate_Summary_Verified__c = 'Need Response From CA';
        rootCaseA1.Root_Certificate_Download_URL_Verified__c = 'Need Response From CA';
        rootCaseA1.SHA_1_Fingerprint_Verified__c = 'Need Response From CA';
        rootCaseA1.SHA_256_Fingerprint_Verified__c = 'Need Response From CA';
        rootCaseA1.Valid_From_Verified__c = 'Need Response From CA';
        rootCaseA1.Valid_To_Verified__c = 'Need Response From CA';
        rootCaseA1.Certificate_Version_Verified__c = 'Need Response From CA';
        rootCaseA1.Cert_Signature_Algorithm_Verified__c = 'Need Response From CA';
        rootCaseA1.Signing_Key_Parameters_Verified__c = 'Need Response From CA';
        rootCaseA1.TestWebsiteURLSSLorExCert_Verified__c = 'Need Response From CA';
        rootCaseA1.CRL_URL_Verified__c = 'Need Response From CA';
        rootCaseA1.OCSP_URL_Verified__c = 'Need Response From CA';
        rootCaseA1.Revocation_Tested_Verified__c = 'Need Response From CA';
        rootCaseA1.Trust_Bits_Verified__c = 'Need Response From CA';
        rootCaseA1.SSL_Validation_Type_Verified__c = 'Need Response From CA';
        rootCaseA1.EV_Policy_OID_s_Verified__c = 'Need Response From CA';
        rootCaseA1.EV_Tested_Verified__c = 'Need Response From CA';
        rootCaseA1.CA_Browser_Forum_Lint_Test_Verified__c = 'Need Response From CA';
        rootCaseA1.Test_Website_Lint_Test_Verified__c = 'Need Response From CA';
        rootCaseA1.Root_Stores_Included_In_Verified__c = 'Need Response From CA';
        rootCaseA1.Mozilla_Applied_Constraints_Verified__c = 'Need Response From CA';
        rootCaseA1.CA_Hierarchy_Verified__c = 'Need Response From CA';
        rootCaseA1.Externally_Operated_SubCAs_Verified__c = 'Need Response From CA';
        rootCaseA1.Cross_Signing_Verified__c = 'Need Response From CA';
        rootCaseA1.Tech_Cons_on_3rd_party_Iss_Verified__c = 'Need Response From CA';
        rootCaseA1.Policy_Documentation_Verified__c = 'Need Response From CA';
        rootCaseA1.CA_Document_Repository_Verified__c = 'Need Response From CA';
        rootCaseA1.CP_Verified__c = 'Need Response From CA';
        rootCaseA1.CPS_Verified__c = 'Need Response From CA';
        rootCaseA1.Other_Relevant_Documents_Verified__c = 'Need Response From CA';
        rootCaseA1.Auditor_Name_Verified__c = 'Need Response From CA';
        rootCaseA1.Auditor_Website_Verified__c = 'Need Response From CA';
        rootCaseA1.Auditor_Qualifications_Verified__c = 'Need Response From CA';
        rootCaseA1.Standard_Audit_Verified__c = 'Need Response From CA';
        rootCaseA1.Standard_Audit_Type_Verified__c = 'Need Response From CA';
        rootCaseA1.Standard_Audit_Statement_Dt_Verified__c = 'Need Response From CA';
        rootCaseA1.BR_Audit_Verified__c = 'Need Response From CA';
        rootCaseA1.BR_Audit_Type_Verified__c = 'Need Response From CA';
        rootCaseA1.BR_Audit_Statement_Date_Verified__c = 'Need Response From CA';
        rootCaseA1.EV_Audit_Verified__c = 'Need Response From CA';
        rootCaseA1.EV_Audit_Type_Verified__c = 'Need Response From CA';
        rootCaseA1.EV_Audit_Statement_Date_Verified__c = 'Need Response From CA';
        rootCaseA1.BR_Commitment_to_Comply_Verified__c = 'Need Response From CA';
        rootCaseA1.BR_Self_Assessment_Verified__c = 'Not Applicable';  
        rootCaseA1.SSL_Verification_Procedures_Verified__c = 'Need Response From CA';
        rootCaseA1.EV_SSL_Verification_Proc_Verified__c = 'Need Response From CA';
        rootCaseA1.Org_Verification_Procedure_Verified__c = 'Need Response From CA';
        rootCaseA1.Email_Addr_Verification_Proc_Verified__c = 'Need Response From CA';
        rootCaseA1.Code_Signing_Subs_Verif_Proc_Verified__c = 'Need Response From CA';
        rootCaseA1.Multi_Factor_Authentication_Verified__c = 'Need Response From CA';
        rootCaseA1.Network_Security_Verified__c = 'Need Response From CA';
        rootCaseA1.Publ_Discl_Audited_subCAs_Verified__c = 'Need Response From CA';
        List<Root_Case__c> lstRootCases = new List<Root_Case__c>();
        lstRootCases.add(rootCaseA1);
        
        RootCaseTriggerHelper.SetAllFieldsVerifiedField(lstRootCases);
    }
}