/**************************************************************************************

Test Case for the following Controller Extensions:

** AuditReminderBatchHelperForMSFT - Executes the logic for sending the reminder emails to 
   the CA Owners based on Standard/BR/EV audit dates.
** AuditReminderBatchControllerForMSFT - controller class for the RunAuditReminderBatchForMSFT VF page
   which displays status of batch jobs.
** AuditReminderBatchForMSFT - implements Database.Batchable for each record selected for 
   processing.

**/

@isTest 

public class AuditReminderBatchControllerTestForMSFT {
    
    static testMethod void myTestForAuditReminder() {
   
        
     // create the parent account  - record type = Owner
     Account parentAccount = getParentAccount();
     insert parentAccount;
     parentAccount.microsoft_status__c = 'Included';
     update parentAccount;
        
     // create the contact associated with the parent account
     Contact parentContact = getParentContact(parentAccount.id);
     parentContact.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CA Contact').getRecordTypeId();
     insert parentContact;
             
     // create the child accounts - record type = Root
     Account childAccount1 = getChildAccount1(parentAccount.id);
     insert childAccount1;
     childAccount1.microsoft_status__c = 'Included';
     update childAccount1;
     Account childAccount2 = getChildAccount2(parentAccount.id);
     insert childAccount2;
     childAccount2.microsoft_status__c = 'Included';
     update childAccount2;
     Account childAccount3 = getChildAccount3(parentAccount.id);
     insert childAccount3;
     childAccount3.microsoft_status__c = 'Included';
     update childAccount3;
     
     // create a CA Program user
     User CAUser = getUser();
        
     // system.debug('accountLst='+accountLst);
                
     // *************************** START PROCESS ***********************************      
        
        // Start the test
        Test.startTest();
           
        AuditReminderBatchControllerForMSFT batchController = new AuditReminderBatchControllerForMSFT();
        batchController.startBatch();        
        batchJobs batchJobsController = new BatchJObs();
        batchJobsController.getBatchJobs();
        AuditReminderBatchSchedulerClass.scheduleMe('Audit Reminder Batch ' + System.now());
        
     // ***************************** END PROCESS ***********************************
        
     // End the test
     Test.stopTest();
        
        
    }
    
    public static Account getParentAccount()
    {
        Account parentAccount = new Account();
        parentAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CA Owner').getRecordTypeID();
        parentAccount.name = 'ParentAccount';
        parentAccount.type = 'Owner';
        parentAccount.CA_Email_Alias_1__c='EmailAlias1@Company.junk';
        parentAccount.CA_Email_Alias_2__c='EmailAlias2@Company.junk';
        parentAccount.website  = 'https//www.test.com';
        parentAccount.valid_From_GMT__c= date.today()+1;
        parentAccount.valid_to_GMT__c= date.today()+10;
        parentAccount.company_website__c=  'https//www.test.com';
        parentAccount.organizational_type__c=  'Organizational Type';
        parentAccount.geographic_focus__c=  'Geographic focus';
        parentAccount.microsoft_status__c = 'Included';
        return parentAccount;
    }

    public static Contact getParentContact(ID accountid)
    {
        Contact parentContact = new Contact();
        parentcontact.firstname = 'FirstName';
        parentcontact.accountid = accountId;
        parentcontact.lastname = 'LastName';
        parentcontact.email= 'LastName@firstname.com';
        parentcontact.phone= '456786588';
        parentcontact.type__c= 'Primary POC';
        
        return parentContact;
    }

   public static Account getChildAccount1(ID parentAccountId)
    {
        Account childAccount = new Account();
        childAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Root Certificate').getRecordTypeID();
        childAccount.name = 'ChildAccount1';
        childAccount.parentid = parentAccountId;
        childAccount.type = 'Root';
        childAccount.valid_From_GMT__c= date.today()+1;
        childAccount.valid_to_GMT__c= date.today()+10;
        childAccount.SHA_1_fingerprint__c= '12:34:56:78:90:12:34:56:78:90:12:34:56:78:90:12:34:56:78:90';
        childAccount.Microsoft_Trust_Bits__c = 'Server Authentication';
        childAccount.Standard_Audit__c = '';  // missing info
        childAccount.Standard_Audit_Statement_Date__c = date.today()-396; // past date
        childAccount.Standard_Audit_Type__c = 'WebTrust';
        childAccount.BR_Audit__c = 'http://www.google.com/BRAudit.pdf';
        childAccount.BR_Audit_Statement_Date__c = date.today();
        childAccount.BR_Audit_Type__c = '';
        childAccount.EV_Audit__c = 'http://www.google.com/EVAudit.pdf';
        childAccount.EV_Audit_Statement_Date__c = date.today();
        childAccount.EV_Audit_Type__c = '';
        childAccount.ev_policy_oid_s__c = '';
        childAccount.microsoft_status__c = 'Included';
        return childAccount;
    }
    
    public static Account getChildAccount2(ID parentAccountId)
    {
        Account childAccount = new Account();
        childAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Root Certificate').getRecordTypeID();
        childAccount.name = 'ChildAccount2';
        childAccount.parentid = parentAccountId;
        childAccount.type = 'Root';
        childAccount.valid_From_GMT__c= date.today()+1;
        childAccount.valid_to_GMT__c= date.today()+10;
        childAccount.SHA_1_fingerprint__c= '12:34:56:78:90:12:34:56:78:90:12:34:56:78:90:12:34:56:78:90';
        childAccount.Microsoft_Trust_Bits__c = 'Server Authentication';
        childAccount.Standard_Audit__c = 'http://www.google.com/StandardAudit.pdf';
        childAccount.Standard_Audit_Statement_Date__c = date.today();
        childAccount.Standard_Audit_Type__c = 'WebTrust';
        childAccount.BR_Audit__c = 'http://www.google.com/BRAudit.pdf';
        childAccount.BR_Audit_Statement_Date__c = date.today()-490; // br past due
        childAccount.BR_Audit_Type__c = 'WebTrust';
        childAccount.EV_Audit__c = 'http://www.google.com/EVAudit.pdf';
        childAccount.EV_Audit_Statement_Date__c = date.today();
        childAccount.EV_Audit_Type__c = '';
        childAccount.ev_policy_oid_s__c = '';
        childAccount.microsoft_status__c = 'Included';
        return childAccount;
    }
    
    public static Account getChildAccount3(ID parentAccountId)
    {
        Account childAccount = new Account();
        childAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Root Certificate').getRecordTypeID();
        childAccount.name = 'ChildAccount3';
        childAccount.parentid = parentAccountId;
        childAccount.type = 'Root';
        childAccount.valid_From_GMT__c= date.today()+1;
        childAccount.valid_to_GMT__c= date.today()+10;
        childAccount.SHA_1_fingerprint__c= '12:34:56:78:90:12:34:56:78:90:12:34:56:78:90:12:34:56:78:90';
        childAccount.Trust_Bits__c = 'Email;Websites';
        childAccount.Standard_Audit__c = 'http://www.google.com/StandardAudit.pdf';
        childAccount.Standard_Audit_Statement_Date__c = date.today();
        childAccount.Standard_Audit_Type__c = 'WebTrust';
        childAccount.BR_Audit__c = 'http://www.google.com/BRAudit.pdf';
        childAccount.BR_Audit_Statement_Date__c = date.today();
        childAccount.BR_Audit_Type__c = 'WebTrust';
        childAccount.Microsoft_EV_Enabled__c = True;    // EV enabled
        childAccount.EV_Audit__c = '';                  // info missing
        childAccount.EV_Audit_Statement_Date__c = date.today()-610; // Danger of Removal reminder for 1yr + 240+ days old
        childAccount.EV_Audit_Type__c = 'Webtrust';
        childAccount.ev_policy_oid_s__c = 'Some data';
        childAccount.microsoft_status__c = 'Included';
        return childAccount;
    }
    
    public static User getUser()
    {
        Profile CAProfile = [SELECT Id FROM Profile WHERE Name='Standard User - Mozilla']; 
        
        User CAUser = new User(Alias = 'CAUser', 
                               Email='CAUser@mozilla.com', 
                               UserName='CAUser@mozilla.com',
                               CA_Program_Manager__c = True,
                               ProfileId = CAProfile.Id
                              );       
        return CAUser;
    }
 
}