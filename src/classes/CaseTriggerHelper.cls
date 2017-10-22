// ========================================================================================================
// CaseTriggerHelper: Trigger for the Case object which handles all the events and based on the event delegates the task 
// to the corresponding trigger handler method in the CaseTriggerHelper class.
// ========================================================================================================
// SetAccountStatusField : (Record Type: CA Owner/Root Inclusion Request) 
// *** NO LONGER NEEDED *** Update related Account Status whenever a new Case is created. 
// ========================================================================================================
// EnforceCAOwnerRule : (Record Type: All)
// Allow cases to be created for 'CA Owner' records only 
// ========================================================================================================
// EnforeAccountRules : (Record Type: CA Owner/Root Inclusion Request) 
// In edit mode - do not allow user to modify Account Name/Owner 
// ========================================================================================================
// SetAllFieldsVerifiedField: (Record Type: CA Owner/Root Inclusion Request)
// Following updates and checks are performed in this trigger when 
// a Root Case record is inserted or updated. Set 'All Fields Verified?' field to 'Yes' if all 
// 'Verified' fields Case object are 'Verified' or 'Not Applicable' 
// ========================================================================================================
// EnforceRequestStatusRulesForInserts : (Record Type: CA Owner/Root Inclusion Request & CA Audit Update Request)
// New Cases must be saved with Request Status "Initial Request Received"
// ========================================================================================================
// EnforceRequestStatusRulesForUpdates : (Record Type: CA Owner/Root Inclusion Request)
// Displays error messages when following conditions are not met.
// 1) "Ready for Public Discussion" can only be selected after all of the Verified fields either
//    "Verified" or "Not Applicable" and all corresponding Root Cases have Request status 
//    of one of "Ready For Public Discussion", "On Hold", "Denied" 
// 2) "In Public Discussion" can only be selected after "Ready for Public Discussion" or "Discussion on Hold"
//     and all corresponding Root Cases have Request status are "In Public Discussion"
// 3) "Discussion on Hold" can only be selected after "In Public Discussion"
//     and all corresponding Root Cases have Request status of "Discussion on Hold" or "In Public Discussion"
// 4) "Pending Approval" can only be selected after "In Public Discussion" or "CA Action Items
//    from Discussion" and all corresponding Root Cases have Request status 
//    of one of "Pending Approval", "On Hold", "Denied" 
// 5) "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV" can only be selected 
//    after "Pending Approval"
// 6) "Included, Pending EV" can only be selected after either "Pending Approval" or 
//    "Approved, Pending Inclusion and EV"
// 7) "On Hold" and "Denied" requires a short explanation in the public comments section
// 8) "Complete" can only be selected after "Approved, Pending Inclusion" or 
//    "Approved, Pending Inclusion and EV" or "Included, Pending EV"
// 9) A Case can have Request Status as 'Included, Pending EV' or 'Complete' 
//    only when all related root cases are 'On Hold' or 'Denied' or 
//   'Included, Pending EV' or 'Complete'
// 10) When Case.Request_Status is 'Complete' change Case.Status to 'Closed' when all related 
//     Root Cases have  Root_Cases.Request_Status = 'Included, Pending EV' or 
//     'Denied' or 'Complete'
// 11) When Case.Request Status is 'Request Withdrawn by CA' set Case.Status to 'Closed' when all related 
//      Root Cases have  Root_Cases.Request_Status = 'Request Withdrawn by CA'
// 12) When Request Status is 'On Hold' set the Case.Status to 'On Hold'
//     Keep the Case 'Open' when Request Status is other than 'Complete' or 'Denied' or 'Request Withdrawn by CA'
// ========================================================================================================
// SetAuditFileArchive : (Record Type: CA Audit Update Request) *** NOT IN USE ***
// This method will be executed on case audit info is verified. A record is added/updated in File Archive object 
// to create an association between external audit document link and internal audit document link.
// if the internal audit link is not existing on file archive object then create new entry
// if the internal audit link is exist on the file archive object then update the entry
// ========================================================================================================


public class CaseTriggerHelper {

 // *** NO LONGER NEEDED ***
 // this method is invoked whenever a new case is created
 // the requirement is to set the status on the related account as "Change Requested"
 
 /******
 public static void SetAccountStatusField(List<Case> caseSoLst) {

      
   // process cases with record type = 'CA Owner/Root Inclusion Request'
   String caseAuditUpdateRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CA Owner/Root Inclusion Request').getRecordTypeId();

   // set which holds the IDs of the account whose status needs to be set as "Change Requested" 
   Set<Id> accountIdLst = New Set<Id>();
   
   // loop over all the cases which were inserted
   for(Case caseSo : caseSoLst)
    {
        if(caseSO.RecordTypeId == caseAuditUpdateRecordTypeId){   // 'CA Owner/Root Inclusion Request' record type only
                  
            // add the account Id to the list so that they could be queried in the next step (bulkified!)
            accountIdLst.add(caseSo.accountId);
        }
    }
   
   // if there is atleast one account
   if(accountIdLst.size() > 0)
   {
    
     // list which holds all the accountSo
     List<Account> accountSoToBeUpdatedLst = New List<Account>();
    
     // query the accounts and iterate over the each accountSo
     for(Account accountSo : [select status__c from account where id in :accountIdLst])
     {
        // set the status and add the Sobject to the list
         if (accountSo.status__c != 'Not Yet Included') {
             accountSo.status__c = 'Change Requested';
         }
         accountSoToBeUpdatedLst.add(accountSo);
     }
     
     // if there is at least one account that need to be updated then execute the DML
     if(accountSoToBeUpdatedLst.size() > 0)
       {
         update accountSoToBeUpdatedLst;
       }
    
     }
     
    } *****/
    
   // fetch data from CA Owner record when Case is first created
    public static void DefaultCAOwnerFields(List<Case> lstCases){
        String csAuditUpdateRTId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CA Audit Update Request').getRecordTypeId();
        set<Id> setCAOwnerId = new set<Id>();
        for(Case cs: lstCases){
            if(cs.RecordTypeId == csAuditUpdateRTId){
                setCAOwnerId.add(cs.AccountId);
            }
        }
        if(setCAOwnerId.size() > 0){
            map<Id,Account> mapAccounts = new map<Id,Account>([select Id,Name,Recognized_CAA_Domains__c,Problem_Reporting_Mechanism__c,Status__c,Microsoft_Status__c,Microsoft_Contract_Type__c from Account Where Id in: setCAOwnerId]);
            for(Case objCS: lstCases){
                if(objCS.RecordTypeId == csAuditUpdateRTId && mapAccounts.containskey(objCS.AccountId)) {
                    if(mapAccounts.get(objCS.AccountId).Recognized_CAA_Domains__c != null){
                        objCS.Recognized_CAA_Domains__c = mapAccounts.get(objCS.AccountId).Recognized_CAA_Domains__c;
                    }
                    if(mapAccounts.get(objCS.AccountId).Problem_Reporting_Mechanism__c != null){
                        objCS.Problem_Reporting_Mechanism__c = mapAccounts.get(objCS.AccountId).Problem_Reporting_Mechanism__c;
                    }                 
                    if(mapAccounts.get(objCS.AccountId).Status__c != null){
                        objCS.Mozilla_Status__c = mapAccounts.get(objCS.AccountId).Status__c;
                    }
                    if(mapAccounts.get(objCS.AccountId).Microsoft_Status__c != null){
                        objCS.Microsoft_Status__c = mapAccounts.get(objCS.AccountId).Microsoft_Status__c;
                    } 
                    if(mapAccounts.get(objCS.AccountId).Microsoft_Contract_Type__c != null){
                        objCS.Microsoft_Contract_Type__c = mapAccounts.get(objCS.AccountId).Microsoft_Contract_Type__c;
                    } 
                    if(objCS.Management_Assertions_By__c == null){
                        objCS.Management_Assertions_By__c = mapAccounts.get(objCS.AccountId).Name;
                    }                  
                }
            }
        }
    }
   
    // re-fetch data from CA Owner record whenever Case is updated
    public static void DefaultCAOwnerFieldsOnChange (List<Case> caseSoLst, Map<Id, Case> oldcaseSoLst){
   
        // loop over all the cases which were updated
        String csAuditUpdateRTId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CA Audit Update Request').getRecordTypeId();
        set<Id> setCAOwnerId = new set<Id>();
        for(Case cs: caseSoLst){
            if(cs.RecordTypeId == csAuditUpdateRTId){
                setCAOwnerId.add(cs.AccountId);
            }
        }
        if(setCAOwnerId.size() > 0){
            map<Id,Account> mapAccounts = new map<Id,Account>([select Id,Name,Recognized_CAA_Domains__c,Problem_Reporting_Mechanism__c,Status__c,Microsoft_Status__c,Microsoft_Contract_Type__c from Account Where Id in: setCAOwnerId]);
            for(Case objCS: caseSoLst){
                if(objCS.RecordTypeId == csAuditUpdateRTId && mapAccounts.containskey(objCS.AccountId)) {
                    if(mapAccounts.get(objCS.AccountId).Status__c != null){
                        objCS.Mozilla_Status__c = mapAccounts.get(objCS.AccountId).Status__c;
                    }
                    if(mapAccounts.get(objCS.AccountId).Microsoft_Status__c != null){
                        objCS.Microsoft_Status__c = mapAccounts.get(objCS.AccountId).Microsoft_Status__c;
                    } 
                    if(mapAccounts.get(objCS.AccountId).Microsoft_Contract_Type__c != null){
                        objCS.Microsoft_Contract_Type__c = mapAccounts.get(objCS.AccountId).Microsoft_Contract_Type__c;  
                    } 
                    if(objCS.Management_Assertions_By__c == null){
                        objCS.Management_Assertions_By__c = mapAccounts.get(objCS.AccountId).Name;
                    }                
                }
            }
        }
    }
   
   
    // Allow cases to be created for 'CA Owner' records only 
    public static void EnforceCAOwnerRule (List<Case> caseSoLst) {
        
        // loop over all the cases which were updated
        for(Case caseSO : [select Id,Account.RecordType.Name from Case Where Id in: caseSoLst])
        {            
            System.debug('Tr RecordType ::: '+caseSO.Account.RecordType.Name);  
            if (caseSO.Account.RecordType.Name != 'CA Owner') {
                caseSO.addError('A case can only be created for a CA Owner. Please correct the data in \'CA Owner/Certificate Name\'');
            } 
        }
    }   
    
    
    //Method create to check for community User
    public static void EnforceCommunityUser(List<Case> caseSoLst){
        // query the user details and check if it is a portal user and get the Owner account ID for that user
        List<User> userSoLst = [select IsPortalEnabled,contact.account.id,contact.account.name from user where id = :UserInfo.getUserId()];
        
        // get the record type ID of the root certificate records 
        Id ownerCARecTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('CA Owner').getRecordTypeId();
        if(userSoLst!=null && userSoLst.size() > 0 && userSoLst[0].isPortalEnabled){
            //if the logged user account is Symantec
            if(userSoLst[0].contact.account.name.startsWith('Symantec')){
                // get all the symantec owner accounts
                Map<Id,Account> symantecAccountMap = New Map<Id,Account>([select id from account where name like 'Symantec%' and recordTypeId=:ownerCARecTypeId]);
                for(Case caseSO: caseSoLst){
                    if(!symantecAccountMap.containskey(caseSO.AccountId)) {
                        caseSO.addError('Invalid selection made for CA Owner/Certificate. Please select CA Owner/Certificate Name as '+ userSoLst[0].contact.account.name + ' or other Symantec brands');
                    }
                }
                
            } else {
                for(Case caseSO: caseSoLst){
                    if(caseSO.AccountId != userSoLst[0].contact.account.Id) {
                        caseSO.addError('Invalid selection made for CA Owner/Certificate. Please select CA Owner/Certificate Name as '+ userSoLst[0].contact.account.name);
                    }
                }
            }
        }
    }
    
    
    public static void EnforceAccountRules (List<Case> caseSoLst,  Map<Id, Case> oldcaseSoLst) {
        
        // loop over all the cases which were updated
        for(Case caseSO : caseSoLst)
        {
           
         // Set oldcaseSo to trigger.old value        
         Case oldcaseSO = oldcaseSOLst.get(caseSo.Id); 
        
         // EnforeAccountRules : In edit mode - do not allow user to modify Account Name/Owner     
          if (oldcaseSO.AccountID != null && caseSO.AccountID != oldcaseSO.AccountID) {
                caseSO.addError('Do not make changes to the CA Owner Name');
             } 
        }
    }   

    public static void SetAllFieldsVerifiedField (List<Case> caseSoLst) {
    
    // process cases with record type = 'CA Owner/Root Inclusion Request'
    String caseAuditUpdateRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CA Owner/Root Inclusion Request').getRecordTypeId();

        
    // loop over all the cases which were updated
    for(Case caseSo : caseSoLst)
    {
        System.debug('caseSo ::: '+caseSo );
        System.debug('caseSo Account ::: '+caseSo.AccountId );
        if(caseSO.RecordTypeId == caseAuditUpdateRecordTypeId){  // process cases with record type 'CA Owner/Root Inclusion Request'
   
              // Set 'All Fields Verified?' field to 'Yes' if all 'Verified' fields
              // in Root Case object are 'Verified' or 'Not Applicable'  
         
              caseSO.All_Fields_Verified__c = 'Yes'; // initialize
       
              if (caseSO.Company_Website_Verified__c != 'Verified' && 
                  caseSO.Company_Website_Verified__c != 'Not Applicable' ) {
                   caseSO.All_Fields_Verified__c = 'No';}

              if (caseSO.Organizational_Type_Verified__c != 'Verified' && 
                  caseSO.Organizational_Type_Verified__c != 'Not Applicable' ) {
                    caseSO.All_Fields_Verified__c = 'No';}

              if (caseSO.Organizational_Type_Others_Verified__c != 'Verified' && 
                   caseSO.Organizational_Type_Others_Verified__c != 'Not Applicable' ) {
                     caseSO.All_Fields_Verified__c = 'No';}
  
              if (caseSO.Geographic_Focus_Verified__c != 'Verified' && 
                  caseSO.Geographic_Focus_Verified__c != 'Not Applicable' ) {
                     caseSO.All_Fields_Verified__c = 'No';}

             if (caseSO.Primary_Market_Customer_Base_Verified__c != 'Verified' && 
                 caseSO.Primary_Market_Customer_Base_Verified__c != 'Not Applicable' ) {
                    caseSO.All_Fields_Verified__c = 'No';}

             if (caseSO.Impact_to_Mozilla_Users_Verified__c != 'Verified' && 
                caseSO.Impact_to_Mozilla_Users_Verified__c != 'Not Applicable' ) {
                   caseSO.All_Fields_Verified__c = 'No';}

             if (caseSO.CA_s_Reponse_to_Recom_Prac_Verified__c != 'Verified' && 
                 caseSO.CA_s_Reponse_to_Recom_Prac_Verified__c != 'Not Applicable' ) {
                    caseSO.All_Fields_Verified__c = 'No';}

             if (caseSO.CA_s_Response_to_Prob_Prac_Verified__c != 'Verified' && 
                 caseSO.CA_s_Response_to_Prob_Prac_Verified__c != 'Not Applicable' ) {
                    caseSO.All_Fields_Verified__c = 'No';}           
            
            } 
        
        }     
    }
    
    public static void EnforceRequestStatusRulesForInserts (List<Case> caseSoLst)
    {
        String caOwnerRootInclusionRequestRecordTypeId = Schema.SObjectType.Root_Case__c.getRecordTypeInfosByName().get('CA Owner/Root Inclusion Request').getRecordTypeID();
        // loop over all the cases which were inserted
        for(Case caseSo : caseSoLst)
        {
            if (caseSO.RecordTypeId == caOwnerRootInclusionRequestRecordTypeId && !caseSO.Request_Status__c.equals('Initial Request Received')) {           
                  caseSO.addError('New Case must be saved with Request Status "Initial Request Received"');
            }  
 
            // A workflow/field update has replaced these commented lines           
            // get case record type id for 'CA Audit Update Request' & set subject field only if record type 'CA Audit Update Request' 
            // String caOwnerRootInclusionRequestRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CA Audit Update Request').getRecordTypeId();
            /* if(caseSO.RecordTypeId == caOwnerRootInclusionRequestRecordTypeId){  process 'CA Owner/Root Inclusion Request' record types only     
                  DateTime Dt = System.now();
                  String CurrentYear = Dt.format('yyyy');                 
                  caseSO.Subject = CurrentYear + ' Audit ' + caseSO.Account.Name;                                  
            }*/
                
        } 
    }

     public static void EnforceRequestStatusRulesForUpdates (List<Case> caseSoLst,  Map<Id, Case> oldcaseSoLst) {
 
        // process cases with record type = 'CA Owner/Root Inclusion Request'
        String caseAuditUpdateRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CA Owner/Root Inclusion Request').getRecordTypeId();
        
        //code is added by Sunil
        //add case id in to set to get all root cases
        set<Id> setCaseIds = new set<Id>();
        for(Case caseSo : caseSoLst){
            setCaseIds.add(caseSo.Id);
        }
        //map to store key as Id and value as List of all Root case for that Case
        map<Id, List<Root_Case__c>> mapCaseWiseRootCases = new map<Id, List<Root_Case__c>>();
        for(Root_Case__c RootCase: [select Id,case_no__c, Request_status__c from 
                Root_Case__c where case_no__c in: setCaseIds]){
            if(mapCaseWiseRootCases.containskey(RootCase.case_no__c)){
                mapCaseWiseRootCases.get(RootCase.case_no__c).add(RootCase);
            } else {
                mapCaseWiseRootCases.put(RootCase.case_no__c, new List<Root_Case__c>{RootCase});
            }        
        }
         
        // loop over all the cases which were updated
        for(Case caseSo : caseSoLst)
        {
           
          if(caseSO.RecordTypeId == caseAuditUpdateRecordTypeId){  // process record type 'CA Owner/Root Inclusion Request' only
       
           
         // Set oldcaseSo to trigger.old value        
         Case oldcaseSo = oldcaseSOLst.get(caseSo.Id); 
         
             
         // Get Root Case info in a list        
         //Avoid SOQL query create map 
         //List<Root_Case__c> RootCaseLst = [select request_status__c from Root_Case__c where case_no__c = :caseSo.ID];
         List<Root_Case__c> RootCaseLst = new List<Root_Case__c>();
         if(mapCaseWiseRootCases.containskey(caseSo.Id)){
             RootCaseLst = mapCaseWiseRootCases.get(caseSo.Id);
         } 
            
         // check for request_status field only if this field was modified
         if (!caseSO.Request_Status__c.equals(oldcaseSO.Request_Status__c))
         {
             
         // "Ready for Public Discussion" can only be selected after all of the Verified fields either 
         // "Verified" or "Not Applicable", and all corresponding Root Cases have Request status 
         // of one of "Ready For Public Discussion", "On Hold", "Denied" 
          
         if (caseSO.Request_Status__c.equals('Ready for Public Discussion')) 
         {
             if (caseSO.All_Fields_Verified__c.equals('No')) {
                  caseSO.addError('Request Status "Ready for Public Discussion" can only be selected after all of the Verified fields either "Verified" or "Not Applicable" ');
             }
             else {
                 
                // list which holds all the selected RootCaseSo
                List<Root_Case__c> RootCaseSoToBeCheckedLst = New List<Root_Case__c>();
      
                for(Root_Case__c RootCaseSo : RootCaseLst)
                {
                    if (RootCaseSo.request_status__c != 'On Hold' && RootCaseSo.request_status__c != 'Denied' && RootCaseSo.request_status__c != 'Ready For Public Discussion' ) {
                    
                         RootcaseSoToBeCheckedLst.add(RootCaseSo);
                    }
                }
    
                // if there is at least one Root Case in the list then flag error
                if(RootCaseSoToBeCheckedLst.size() > 0)
                {       
                     caseSO.addError('Request Status "Ready for Public Discussion" can only be selected when all related Root Cases are "On Hold" or "Denied" or "Ready for Public Discussion"');
                }                
                 
             }
         }
         
 
          // "In Public Discussion" can only be selected after "Ready for Public Discussion" or "Discussion on Hold"
          // and all corresponding Root Cases have Request status 
          // of one of "In Public Discussion", "Discussion on Hold", "On Hold", "Denied" 

         if (caseSO.Request_Status__c.equals('In Public Discussion')) {
             if (!oldcaseSO.Request_Status__c.equals('Ready for Public Discussion') && !oldcaseSO.Request_Status__c.equals('Discussion on Hold')) {
                  caseSO.addError('Request Status "In Public Discussion" can only be selected after "Ready for Public Discussion" or "Discussion on Hold"');
             }
             else {
                 
                // list which holds all the selected RootCaseSo
                List<Root_Case__c> RootCaseSoToBeCheckedLst = New List<Root_Case__c>();
      
                for(Root_Case__c RootCaseSo : RootCaseLst)
                {
                    if (RootCaseSo.request_status__c != 'In Public Discussion') {
                    
                         RootcaseSoToBeCheckedLst.add(RootCaseSo);
                    }
                }
    
                // if there is at least one Root Case in the list then flag error
                if(RootCaseSoToBeCheckedLst.size() > 0)
                {       
                     caseSO.addError('Request Status "In Public Discussion" can only be selected when all related Root Cases are "In Public Discussion"');
                }                
                 
             }
         }
         
         
         // "Discussion on Hold" can only be selected after "In Public Discussion"
         //  and all corresponding Root Cases have Request status of "Discussion on Hold"
         
         if (caseSO.Request_Status__c.equals('Discussion on Hold')) {
             if (!oldcaseSO.Request_Status__c.equals('In Public Discussion')) {
                  caseSO.addError('Request Status "Discussion on Hold" can only be selected after "In Public Discussion"');
             }
             else {
                 
                // list which holds all the selected RootCaseSo
                List<Root_Case__c> RootCaseSoToBeCheckedLst = New List<Root_Case__c>();
      
                for(Root_Case__c RootCaseSo : RootCaseLst)
                {
                    if (RootCaseSo.request_status__c != 'Discussion on Hold' && RootCaseSo.request_status__c != 'In Public Discussion') {
                    
                         RootcaseSoToBeCheckedLst.add(RootCaseSo);
                    }
                }
    
                // if there is at least one Root Case in the list then flag error
                if(RootCaseSoToBeCheckedLst.size() > 0)
                {       
                     caseSO.addError('"Discussion on Hold" can only be selected when all related Root Cases are "In Public Discussion" or "Discussion on Hold"');
                }                
                 
             }
         }
         
         
         // "Pending Approval" can only be selected after "In Public Discussion" or "CA Action Items from Discussion" 
         // and all corresponding Root Cases have Request status of one of "Pending Approval", "On Hold", "Denied" 

         if (caseSO.Request_Status__c.equals('Pending Approval')) {
             if (!oldcaseSO.Request_Status__c.equals('In Public Discussion') && !oldcaseSO.Request_Status__c.equals('CA Action Items from Discussion')) {
                  caseSO.addError('Request Status "Pending Approval" can only be selected after "In Public Discussion" or "CA Action Items from Discussion"');
             }
             else {
                 
                // list which holds all the selected RootCaseSo
                List<Root_Case__c> RootCaseSoToBeCheckedLst = New List<Root_Case__c>();
      
                for(Root_Case__c RootCaseSo : RootCaseLst)
                {
                    if (RootCaseSo.request_status__c != 'On Hold' && RootCaseSo.request_status__c != 'Denied' && RootCaseSo.request_status__c != 'Pending Approval' ) {
                    
                         RootcaseSoToBeCheckedLst.add(RootCaseSo);
                    }
                }
    
                // if there is at least one Root Case in the list then flag error
                if(RootCaseSoToBeCheckedLst.size() > 0)
                {       
                     caseSO.addError('Request Status "Pending Approval" can only be selected when all related Root Cases are "On Hold" or "Denied" or "Pending Approval"');
                }                
                 
             }
         }
         
         // "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV" can only be selected after "Pending Approval"

        if (caseSO.Request_Status__c.equals('Approved, Pending Inclusion') || caseSO.Request_Status__c.equals('Approved, Pending Inclusion and EV')) {
             if (!oldcaseSO.Request_Status__c.equals('Pending Approval')) {
                  caseSO.addError('Request Status "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV" can only be selected after "Pending Approval"');
             }
             else {
                 
                // list which holds all the selected RootCaseSo
                List<Root_Case__c> RootCaseSoToBeCheckedLst = New List<Root_Case__c>();
      
                for(Root_Case__c RootCaseSo : RootCaseLst)
                {
                    if (RootCaseSo.request_status__c != 'On Hold' && RootCaseSo.request_status__c != 'Denied' 
                        && RootCaseSo.request_status__c != 'Approved, Pending Inclusion' && RootCaseSo.request_status__c != 'Approved, Pending Inclusion and EV') {
                    
                         RootcaseSoToBeCheckedLst.add(RootCaseSo);
                    }
                }
    
                // if there is at least one Root Case in the list then flag error
                if(RootCaseSoToBeCheckedLst.size() > 0)
                {       
                     caseSO.addError('Request Status "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV" can only be selected when all related Root Cases are "On Hold" or "Denied" or "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV"');
                }                
                 
             }
         }
         
         // "Included, Pending EV" can only be selected after either "Pending Approval" or "Approved, Pending Inclusion and EV"

        if (caseSO.Request_Status__c.equals('Included, Pending EV')) {
             if (!oldcaseSO.Request_Status__c.equals('Pending Approval') && !oldcaseSO.Request_Status__c.equals('Approved, Pending Inclusion and EV')) {
                  caseSO.addError('Request Status "Included, Pending EV" can only be selected after either "Pending Approval" or "Approved, Pending Inclusion and EV"');
             }
         }
         
 
         // "On Hold" and "Denied" requires a short explanation in the public comments section
         
         if (caseSO.Request_Status__c.equals('On Hold') || caseSO.Request_Status__c.equals('Denied')) {
             if ((caseSO.Comments__c == NULL) && (caseSO.Internal_Comments_on_Case__c == NULL)) {
                  caseSO.addError('Request Status "On Hold" and "Denied" requires a short explanation in the Internal/Public comments section');
             }
         }
           
         // "Complete" can only be selected after "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV" or "Included, Pending EV"

         if (caseSO.Request_Status__c.equals('Complete')) {
             if (!oldcaseSO.Request_Status__c.equals('Approved, Pending Inclusion') && !oldcaseSO.Request_Status__c.equals('Approved, Pending Inclusion and EV') && !oldcaseSO.Request_Status__c.equals('Included, Pending EV')) {
                  caseSO.addError('Request Status "Complete" can only be selected after "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV" or "Included, Pending EV"');
             }
         }
        
          //  A Case can have Request Status as 'Included, Pending EV' or 'Complete' 
          //  only when all related root cases are 'On Hold' or 'Denied' or 
          //  'Included, Pending EV' or 'Complete'
            
         if (caseSO.Request_Status__c.equals('Included, Pending EV') || caseSO.Request_Status__c.equals('Complete')) {  
      
            // list which holds all the related RootCaseSo
            List<Root_Case__c> RootCaseSoToBeCheckedLst = New List<Root_Case__c>();
      
            // query the Root Case and iterate over the each RootCaseSo
            for(Root_Case__c RootCaseSo : RootCaseLst) 
            {
                if (RootCaseSo.request_status__c != 'On Hold' && RootCaseSo.request_status__c != 'Denied' 
                    && RootCaseSo.request_status__c != 'Included, Pending EV' && RootCaseSo.request_status__c != 'Complete' ) {
                    
                     RootcaseSoToBeCheckedLst.add(RootCaseSo);
               }
            }
    
            // if there is at least one Root Case in the list then flag error
            
            if(RootCaseSoToBeCheckedLst.size() > 0)
            {       
                caseSO.addError('Request Status "Included, Pending EV" or "Complete" can only be selected when all related Root Cases are "On Hold" or "Denied" or "Included, Pending EV" or "Complete"');
            }
          }
         }
            
          // When Case.Request_Status is 'Complete', change Case.Status to 'Closed' when all related 
          // Root Cases have  Root_Cases.Request_Status = 'Denied' or 'Complete' or 'Request Withdrawn by CA' or 'Included, Pending EV' 
           
            if (caseSO.Request_Status__c.equals('Complete')) {  
      
            // list which holds all the related RootCaseSo
            List<Root_Case__c> RootCaseSoToBeCheckedLst = New List<Root_Case__c>();
      
            // query the Root Case and iterate over the each RootCaseSo
            for(Root_Case__c RootCaseSo : RootCaseLst) 
            {
                if (RootCaseSo.request_status__c != 'Denied' 
                    && RootCaseSo.request_status__c != 'Included, Pending EV' 
                    && RootCaseSo.request_status__c != 'Complete' ) 
                {
                    RootcaseSoToBeCheckedLst.add(RootCaseSo);
                }
            }
   
            if(RootCaseSoToBeCheckedLst.size() > 0) {
                
                caseSO.addError('Request Status "Complete" can only be selected when all related Root Cases are "Included, Pending EV" or "Denied" or "Complete"');
            }
            else {
                caseSO.Status = 'Closed';
            }
         }

         // When Request Status is 'Request Withdrawn by CA' set Status to 'Closed' when all related 
         // Root Cases have  Root_Cases.Request_Status = 'Request Withdrawn by CA'

            if (caseSO.Request_Status__c.equals('Request Withdrawn by CA')) {  
      
            // list which holds all the related RootCaseSo
            List<Root_Case__c> RootCaseSoToBeCheckedLst = New List<Root_Case__c>();
      
            // query the Root Case and iterate over the each RootCaseSo
            for(Root_Case__c RootCaseSo : RootCaseLst) 
            {
                if (RootCaseSo.request_status__c != 'Request Withdrawn by CA') 
                {
                    RootcaseSoToBeCheckedLst.add(RootCaseSo);
                }
            }
   
            if(RootCaseSoToBeCheckedLst.size() > 0) {
                
                caseSO.addError('Request Status "Request Withdrawn by CA" can only be selected when all related Root Cases are "Request Withdrawn by CA"');
            }
            else {
                caseSO.Status = 'Closed';
            }
         }
          
          // When Request Status is 'On Hold' set the Case.Status to 'On Hold'
          // Keep the Case 'Open' when Request Status is other than 'Complete' or 'Request Withdrawn by CA'
          
          if (caseSO.Request_Status__c.equals('On Hold')) {
                 caseSO.Status = 'On Hold';              
            }
            else if (!caseSO.Request_Status__c.equals('Complete') && !caseSO.Request_Status__c.equals('Denied') && !caseSO.Request_Status__c.equals('Request Withdrawn by CA')) {
                caseSO.Status = 'Open';
            } 
            
          }  // process cases for recod type = 'CA Owner/Root Inclusion Request'
       }
    }
    
    /*        **** NOT IN USE ****
    * this method will be executed on case standard audit link verified, this method will do entry to file archive object
    * if the internal audit link is not existing on file archive object then create new entry
    * if the internal audit link is exist on the file archive object then update the entry
    * Whole method commented by Sunil on 21st March 2017
    */
    //public static void setAuditFileArchive(List<Case> newCaseRecords, Map<Id, Case> mapOldCases){
    
        //Set<String> setExistingAuditLink = new Set<String>();//set of existing audit links for the given case
        
        //map of existing file archive for the existing external links; 
        //this will be used to update the existing archive records based on internal link
        
        //Map<String, File_Archive__c> mapFileArchive = new Map<String, File_Archive__c>();
        
        //List<File_Archive__c> lstFileArchive = new List<File_Archive__c>();//list of records to be upserted
        
        //case record type
        //String caseAuditUpdateRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CA Audit Update Request').getRecordTypeId();
       
        /***
        for(Case caseSO : newCaseRecords){
    
            //perform action only for certain record types
            if(caseSO.RecordTypeId == caseAuditUpdateRecordTypeId){
                
                // get external link for the audit document on case being updated and prepare a set - 
                //fetch the file archive for those links to upsert the existing archive records
       
                if(caseSO.Standard_Audit_Statement_Link__c != null){
                    setExistingAuditLink.add(caseSO.Standard_Audit_Statement_Link__c);
                }
                
                if(caseSO.BR_Audit_Statement_Link__c != null){
                    setExistingAuditLink.add(caseSO.BR_Audit_Statement_Link__c);
                }
                
                if(caseSO.EV_Audit_Statement_Link__c != null){
                    setExistingAuditLink.add(caseSO.EV_Audit_Statement_Link__c);
                }
                
                // if(caseSO.Certificate_Policy_Link__c != null){
                //     setExistingAuditLink.add(caseSO.Certificate_Policy_Link__c);
                // }
                
                // if(caseSO.Certification_Practice_Statement_Link__c != null){
                //    setExistingAuditLink.add(caseSO.Certification_Practice_St_Link__c);
                // }
            }  
        } ***/
        
        /***
        if(setExistingAuditLink.size() > 0){
            System.debug('setExistingAuditLink: '+setExistingAuditLink);
            for(File_Archive__c archived : [SELECT Id, External_Link__c FROM File_Archive__c 
                                            WHERE External_Link__c IN :setExistingAuditLink]){
                mapFileArchive.put(archived.External_Link__c, archived);
            }
            System.debug('mapFileArchive: '+mapFileArchive);
        } ***/
       
        //for(Case caseSO : newCaseRecords){
            
            //if(caseSO.RecordTypeId == caseAuditUpdateRecordTypeId){
               /***
                //If  standard Audit verified - perform below action
                if(caseSO.Standard_Audit_Verified__c == 'Verified' && mapOldCases.get(caseSO.Id).Standard_Audit_Verified__c != 'Verified'){
                
                    if(caseSO.Standard_Audit_Statement_Link__c != null && caseSO.Standard_Audit_Statement_Internal_Link__c != null){
                        
                        //create entry on file archived object
                        File_Archive__c fileArchived = new File_Archive__c(Document_Type__c = 'Standard Audit', 
                                                                           External_Link__c = caseSO.Standard_Audit_Statement_Link__c, 
                                                                           Internal_Link__c = caseSO.Standard_Audit_Statement_Internal_Link__c,
                                                                           Audit_Statement_Date__c = caseSO.Standard_Audit_Statement_Date__c,
                                                                           Period_Start_Date__c = caseSO.Standard_Audit_Period_Start_Date__c,
                                                                           Period_End_Date__c = caseSO.Standard_Audit_Period_End_Date__c,
                                                                           CA_Owner__c = caseSO.AccountId);
                        
                        //set id of file archive record. if the id is null then the new record will be created else existing record will get updated
                        fileArchived.Id = mapFileArchive.containsKey(caseSO.Standard_Audit_Statement_Link__c) ? mapFileArchive.get(caseSO.Standard_Audit_Statement_Link__c).Id : null;
                        system.debug('Upserting Standard Audit file: '+fileArchived.Id);
                        lstFileArchive.add(fileArchived);   
                    }
                } ***/
                
               /***
                //If  BR Audit verified - perform below action
                if(caseSO.BR_Audit_Statement_Link_Verified__c == 'Verified' && mapOldCases.get(caseSO.Id).BR_Audit_Statement_Link_Verified__c != 'Verified'){
                    
                    if(caseSO.BR_Audit_Statement_Link__c != null && caseSO.BR_Audit_Statement_Internal_Link__c != null){
                        
                        //create entry on file archived object
                        File_Archive__c fileArchived = new File_Archive__c(Document_Type__c = 'BR Audit', 
                                                                           External_Link__c = caseSO.BR_Audit_Statement_Link__c, 
                                                                           Internal_Link__c = caseSO.BR_Audit_Statement_Internal_Link__c,
                                                                           Audit_Statement_Date__c = caseSO.BR_Audit_Statement_Date__c,
                                                                           Period_Start_Date__c = caseSO.BR_Audit_Period_Start_Date__c,
                                                                           Period_End_Date__c = caseSO.BR_Audit_Period_End_Date__c,
                                                                           CA_Owner__c = caseSO.AccountId);
                        
                        //set id of file archive record. if the id is null then the new record will be created else existing record will get updated
                        fileArchived.Id = mapFileArchive.containsKey(caseSO.BR_Audit_Statement_Internal_Link__c) ? mapFileArchive.get(caseSO.BR_Audit_Statement_Internal_Link__c).Id : null;
                        system.debug('Upserting BR Audit file: '+fileArchived.Id);
                        lstFileArchive.add(fileArchived);   
                    }
                } ***/
                
                /***
                //If EV Audit verified - perform below action
                if(caseSO.EV_Audit_Statement_Link_Verified__c == 'Verified' && mapOldCases.get(caseSO.Id).EV_Audit_Statement_Link_Verified__c != 'Verified'){
                    
                    if(caseSO.EV_Audit_Statement_Link__c != null && caseSO.EV_Audit_Statement_Internal_Link__c != null){
                        
                        //create entry on file archived object
                        File_Archive__c fileArchived = new File_Archive__c(Document_Type__c = 'EV Audit', 
                                                                           External_Link__c = caseSO.EV_Audit_Statement_Link__c, 
                                                                           Internal_Link__c = caseSO.EV_Audit_Statement_Internal_Link__c,
                                                                           Audit_Statement_Date__c = caseSO.EV_Audit_Statement_Date__c,
                                                                           Period_Start_Date__c = caseSO.EV_Audit_Period_Start_Date__c,
                                                                           Period_End_Date__c = caseSO.EV_Audit_Period_End_Date__c,
                                                                           CA_Owner__c = caseSO.AccountId);
                        
                        //set id of file archive record. if the id is null then the new record will be created else existing record will get updated
                        fileArchived.Id = mapFileArchive.containsKey(caseSO.EV_Audit_Statement_Internal_Link__c) ? mapFileArchive.get(caseSO.EV_Audit_Statement_Internal_Link__c).Id : null;
                        system.debug('Upserting EV Audit file: '+fileArchived.Id);
                        lstFileArchive.add(fileArchived);   
                    }
                } ***/
             
                /*** CP and CPS files are typically very big, hence these files will not be stored/archived in Salesforce
                //If CP/CPS Audit verified - perform below action
                if(caseSO.CP_CPS_Links_Verified__c == 'Verified' && mapOldCases.get(caseSO.Id).CP_CPS_Links_Verified__c != 'Verified'){
                    
                    if(caseSO.Certificate_Policy_Link__c != null && caseSO.Certificate_Policy_Internal_Link__c != null){
                        
                        //create entry on file archived object
                        File_Archive__c fileArchived = new File_Archive__c(Document_Type__c = 'CP', 
                                                                           External_Link__c = caseSO.Certificate_Policy_Link__c, 
                                                                           Internal_Link__c = caseSO.Certificate_Policy_Internal_Link__c,
                                                                           //Period_Start_Date__c = caseSO.EV_Audit_Period_Start_Date__c,
                                                                           //Period_End_Date__c = caseSO.EV_Audit_Period_End_Date__c,
                                                                           CA_Owner__c = caseSO.AccountId);
                        
                        //set id of file archive record. if the id is null then the new record will be created else existing record will get updated
                        fileArchived.Id = mapFileArchive.containsKey(caseSO.Certificate_Policy_Internal_Link__c) ? mapFileArchive.get(caseSO.Certificate_Policy_Internal_Link__c).Id : null;
                        system.debug('Upserting CP file: '+fileArchived.Id);
                        lstFileArchive.add(fileArchived);
                    }
        
                    if(caseSO.Certification_Practice_Statement_Link__c != null && caseSO.Certification_Practice_St_InternalLink__c != null){
                        
                        //create entry on file archived object
                        File_Archive__c fileArchived = new File_Archive__c(Document_Type__c = 'CPS', 
                                                                           External_Link__c = caseSO.Certification_Practice_Statement_Link__c, 
                                                                           Internal_Link__c = caseSO.Certification_Practice_St_InternalLink__c,
                                                                           //Period_Start_Date__c = caseSO.EV_Audit_Period_Start_Date__c,
                                                                           //Period_End_Date__c = caseSO.EV_Audit_Period_End_Date__c,
                                                                           CA_Owner__c = caseSO.AccountId);
                        
                        //set id of file archive record. if the id is null then the new record will be created else existing record will get updated
                        fileArchived.Id = mapFileArchive.containsKey(caseSO.Certification_Practice_St_InternalLink__c) ? mapFileArchive.get(caseSO.Certification_Practice_St_InternalLink__c).Id : null;
                        system.debug('Upserting CPC file: '+fileArchived.Id);
                        lstFileArchive.add(fileArchived);   
                    }
                }  CP and CPS file archive logic commented ***/
            //} 
        //}
        
        //If there are any records to upsert. insert/update those records
        /*if(!lstFileArchive.isEmpty()){
            try{
                upsert lstFileArchive;
            }catch(DMLException exp){
                System.debug('An Error occurred while upserting archived records.');
            }
        } */
    //} //end of audit file archive program
    
    /*
    Public Static void PortalUserValidation(List<Case> lstNewCases){
        
        
        User loggedInUser = [SELECT Id, AccountId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        for(Case newCase : lstNewCases){
            
            CreateIntermediateCertController objToCheckUserValidation = new CreateIntermediateCertController(new ApexPages.standardController(this.sourceAccountSo));
            if(!objToCheckUserValidation.isValidPortalUser() && newCase.AccountId != loggedInUser.AccountId){
                newCase.addError('Please select a Root Cert or Intermediate Cert owned by ' + objToCheckUserValidation.userAccountName);
            }
        }
    }*/


    public static void EnforceRequestStatusRulesForAuditUpdates (List<Case> caseSoLst, Map<Id, Case> oldcaseSoLst){
 
        // process cases with record type = 'CA Audit Update Request'
        String caseAuditUpdateRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CA Audit Update Request').getRecordTypeId();
 
        // loop over all the cases which were updated
        for(Case caseSo : caseSoLst)
        {
           
          if(caseSO.RecordTypeId == caseAuditUpdateRecordTypeId){  // process record type 'CA Audit Update Request' only      
         
         // Set oldcaseSo to trigger.old value        
         Case oldcaseSO = oldcaseSOLst.get(caseSo.Id); 
          
          // Get Root Case info in a list        
          // List<Root_Case__c> RootCaseLst = [select request_status__c from Root_Case__c where case_no__c = :caseSo.ID];
          
          // system.debug('caseSO.Request_Status__c: '+caseSO.Request_Status__c);
          // system.debug('oldcaseSO.Request_Status__c: '+oldcaseSO.Request_Status__c);
          // system.debug('Standard_Audit_Type__c: '+Standard_Audit_Type__c);
          if ((caseSO.Request_Status__c == 'Complete' && oldcaseSO.Request_Status__c == 'Complete') || 
              (caseSO.Status == 'Closed' && oldcaseSO.Status == 'Closed')) {
          
             if (caseSO.Subject != oldcaseSO.Subject ||
                caseSO.RecordTypeId != caseSO.RecordTypeId ||
                caseSO.Request_Status__c != oldcaseSO.Request_Status__c ||
                caseSO.Recognized_CAA_Domains__c != oldcaseSO.Recognized_CAA_Domains__c ||
                caseSO.Problem_Reporting_Mechanism__c != oldcaseSO.Problem_Reporting_Mechanism__c ||
                caseSO.Standard_Audit_Verified__c != oldcaseSO.Standard_Audit_Verified__c ||
                caseSO.Standard_Audit_Statement_Link__c != oldcaseSO.Standard_Audit_Statement_Link__c ||
                caseSO.Standard_Audit_Type__c !=oldcaseSO.Standard_Audit_Type__c ||
                caseSO.Standard_Audit_Statement_Date__c != oldcaseSO.Standard_Audit_Statement_Date__c ||
                caseSO.Standard_Audit_Period_Start_Date__c != oldcaseSO.Standard_Audit_Period_Start_Date__c ||
                caseSO.Standard_Audit_Period_End_Date__c != oldcaseSO.Standard_Audit_Period_End_Date__c ||
                caseSO.Standard_Audit_Authenticity_Confirmed__c != oldcaseSO.Standard_Audit_Authenticity_Confirmed__c ||
                caseSO.Standard_Audit_ALV_Comments__c != oldcaseSO.Standard_Audit_ALV_Comments__c || 
                caseSO.Auditor_New__c != oldcaseSO.Auditor_New__c ||
                caseSO.Auditor_Location_New__c != oldcaseSO.Auditor_Location_New__c ||
                caseSO.Management_Assertions_By__c !=oldcaseSO.Management_Assertions_By__c ||
                caseSO.Standard_Audit_Verified__c !=oldcaseSO.Standard_Audit_Verified__c ||
                caseSO.BR_Audit_Statement_Link_Verified__c != oldcaseSO.BR_Audit_Statement_Link_Verified__c ||
                caseSO.BR_Audit_Statement_Link__c != oldcaseSO.BR_Audit_Statement_Link__c ||
                caseSO.BR_Audit_Type__c != oldcaseSO.BR_Audit_Type__c ||
                caseSO.BR_Audit_Statement_Date__c != oldcaseSO.BR_Audit_Statement_Date__c ||
                caseSO.BR_Audit_Period_Start_Date__c != oldcaseSO.BR_Audit_Period_Start_Date__c ||
                caseSO.BR_Audit_Period_End_Date__c != oldcaseSO.BR_Audit_Period_End_Date__c ||
                caseSO.BR_Audit_Statement_Link_Verified__c != oldcaseSO.BR_Audit_Statement_Link_Verified__c || 
                caseSO.BR_Audit_Authenticity_Confirmed__c != oldcaseSO.BR_Audit_Authenticity_Confirmed__c ||
                caseSO.BR_Audit_ALV_Comments__c != oldcaseSO.BR_Audit_ALV_Comments__c ||                
                caseSO.EV_Audit_Statement_Link_Verified__c !=oldcaseSO.EV_Audit_Statement_Link_Verified__c ||
                caseSO.EV_Audit_Statement_Link__c !=oldcaseSO.EV_Audit_Statement_Link__c ||
                caseSO.EV_Audit_Type__c !=oldcaseSO.EV_Audit_Type__c ||
                caseSO.EV_Audit_Statement_Date__c !=oldcaseSO.EV_Audit_Statement_Date__c ||
                caseSO.EV_Audit_Period_Start_Date__c !=oldcaseSO.EV_Audit_Period_Start_Date__c ||
                caseSO.EV_Audit_Period_End_Date__c !=oldcaseSO.EV_Audit_Period_End_Date__c ||
                caseSO.EV_Audit_Statement_Link_Verified__c !=oldcaseSO.EV_Audit_Statement_Link_Verified__c ||  
                caseSO.EV_SSL_Audit_Authenticity_Confirmed__c != oldcaseSO.EV_SSL_Audit_Authenticity_Confirmed__c ||
                caseSO.EV_SSL_Audit_ALV_Comments__c != oldcaseSO.EV_SSL_Audit_ALV_Comments__c ||                                            
                caseSO.EV_Code_Signing_Audit_Statement_Link__c !=oldcaseSO.EV_Code_Signing_Audit_Statement_Link__c ||
                caseSO.EV_Code_Signing_Audit_Type__c !=oldcaseSO.EV_Code_Signing_Audit_Type__c ||
                caseSO.EV_Code_Signing_Audit_Statement_Date__c !=oldcaseSO.EV_Code_Signing_Audit_Statement_Date__c ||
                caseSO.EV_Code_Signing_Audit_Period_Start_Date__c !=oldcaseSO.EV_Code_Signing_Audit_Period_Start_Date__c ||
                caseSO.EV_Code_Signing_Audit_Period_End_Date__c !=oldcaseSO.EV_Code_Signing_Audit_Period_End_Date__c ||
                caseSO.EV_Code_Signing_Audit_Auth_Confirmed__c != oldcaseSO.EV_Code_Signing_Audit_Auth_Confirmed__c ||
                caseSO.EV_Code_Signing_Audit_ALV_Comments__c != oldcaseSO.EV_Code_Signing_Audit_ALV_Comments__c ||                                          
                caseSO.CP_CPS_Links_Verified__c != oldcaseSO.CP_CPS_Links_Verified__c ||
                caseSO.CA_Document_Repository__c != oldcaseSO.CA_Document_Repository__c ||
                caseSO.Certificate_Policy_Link__c != oldcaseSO.Certificate_Policy_Link__c ||
                caseSO.Certification_Practice_Statement_Link__c != oldcaseSO.Certification_Practice_Statement_Link__c ||
                caseSO.CP_CPS_Last_Updated_Date__c != oldcaseSO.CP_CPS_Last_Updated_Date__c ||
                caseSO.Policy_Documentation__c != oldcaseSO.Policy_Documentation__c ||
                caseSO.CP_CPS_Links_Verified__c != oldcaseSO.CP_CPS_Links_Verified__c ||
                caseSO.Description != oldcaseSO.Description ||
                caseSO.Internal_Comments_on_Case__c != oldcaseSO.Internal_Comments_on_Case__c ||
                caseSO.Comments__c != oldcaseSO.Comments__c ||
                caseSO.Status != oldcaseSO.Status ||
                caseSO.Priority != oldcaseSO.Priority){
                    
                    caseSO.addError('Completed & Closed Case cannot be modified.');
                }
          
          }
          
          
          // do not allow user to modify standard audit block 
          if (caseSO.Standard_Audit_Verified__c == 'Data Verified' && 
              (caseSo.Standard_Audit_Statement_Link__c != oldcaseSO.Standard_Audit_Statement_Link__c ||  
               caseSo.Standard_Audit_Type__c != oldcaseSO.Standard_Audit_Type__c || 
               caseSo.Standard_Audit_Statement_Date__c != oldcaseSO.Standard_Audit_Statement_Date__c || 
               caseSo.Standard_Audit_Period_Start_Date__c != oldcaseSO.Standard_Audit_Period_Start_Date__c ||
               caseSo.Standard_Audit_Period_End_Date__c != oldcaseSO.Standard_Audit_Period_End_Date__c ||             
               caseSo.Auditor_New__c != oldcaseSO.Auditor_New__c ||
               caseSo.Auditor_Location_New__c != oldcaseSO.Auditor_Location_New__c ||
               caseSo.Management_Assertions_By__c != oldcaseSO.Management_Assertions_By__c ||
               caseSo.Standard_Audit_Authenticity_Confirmed__c != oldcaseSO.Standard_Audit_Authenticity_Confirmed__c ||
               caseSo.Standard_Audit_ALV_Comments__c != oldcaseSO.Standard_Audit_ALV_Comments__c)) {
              
                 caseSO.addError('Data has been verified. You cannot modify Auditor and Standard Audit fields');                      
          }
                      
          // do not allow user to modify BR audit block 
          if (caseSO.BR_Audit_Statement_Link_Verified__c == 'Data Verified' && 
              (caseSo.BR_Audit_Statement_Link__c != oldcaseSO.BR_Audit_Statement_Link__c ||  
              caseSo.BR_Audit_Type__c != oldcaseSO.BR_Audit_Type__c || 
              caseSo.BR_Audit_Statement_Date__c != oldcaseSO.BR_Audit_Statement_Date__c || 
              caseSo.BR_Audit_Period_Start_Date__c != oldcaseSO.BR_Audit_Period_Start_Date__c ||
              caseSo.BR_Audit_Period_End_Date__c != oldcaseSO.BR_Audit_Period_End_Date__c ||
              caseSo.BR_Audit_Authenticity_Confirmed__c != oldcaseSO.BR_Audit_Authenticity_Confirmed__c ||
              caseSo.BR_Audit_ALV_Comments__c != oldcaseSO.BR_Audit_ALV_Comments__c)) {
              
                 caseSO.addError('Data has been verified. You cannot modify BR audit fields');                      
          }
          
          // do not allow user to modify EV audit block 
          if (caseSO.EV_Audit_Statement_Link_Verified__c == 'Data Verified' && 
              (caseSo.EV_Audit_Statement_Link__c != oldcaseSO.EV_Audit_Statement_Link__c ||  
              caseSo.EV_Audit_Type__c != oldcaseSO.EV_Audit_Type__c || 
              caseSo.EV_Audit_Statement_Date__c != oldcaseSO.EV_Audit_Statement_Date__c || 
              caseSo.EV_Audit_Period_Start_Date__c != oldcaseSO.EV_Audit_Period_Start_Date__c ||
              caseSo.EV_Audit_Period_End_Date__c != oldcaseSO.EV_Audit_Period_End_Date__c ||
              caseSo.EV_SSL_Audit_Authenticity_Confirmed__c != oldcaseSO.EV_SSL_Audit_Authenticity_Confirmed__c ||
              caseSo.EV_SSL_Audit_ALV_Comments__c != oldcaseSO.EV_SSL_Audit_ALV_Comments__c ||              
              caseSo.EV_Code_Signing_Audit_Statement_Link__c != oldcaseSO.EV_Code_Signing_Audit_Statement_Link__c ||  
              caseSo.EV_Code_Signing_Audit_Type__c != oldcaseSO.EV_Code_Signing_Audit_Type__c || 
              caseSo.EV_Code_Signing_Audit_Statement_Date__c != oldcaseSO.EV_Code_Signing_Audit_Statement_Date__c || 
              caseSo.EV_Code_Signing_Audit_Period_Start_Date__c != oldcaseSO.EV_Code_Signing_Audit_Period_Start_Date__c ||
              caseSo.EV_Code_Signing_Audit_Period_End_Date__c != oldcaseSO.EV_Code_Signing_Audit_Period_End_Date__c ||
              caseSo.EV_Code_Signing_Audit_Auth_Confirmed__c != oldcaseSO.EV_Code_Signing_Audit_Auth_Confirmed__c ||
              caseSo.EV_Code_Signing_Audit_ALV_Comments__c != oldcaseSO.EV_Code_Signing_Audit_ALV_Comments__c)) {
              
                 caseSO.addError('Data has been verified. You cannot modify EV audit fields');                      
          }
          
          // do not allow user to modify CP/CPS audit block 
          if (caseSO.CP_CPS_Links_Verified__c == 'Data Verified' && 
              (caseSo.CA_Document_Repository__c != oldcaseSO.CA_Document_Repository__c ||  
               caseSo.Policy_Documentation__c != oldcaseSO.Policy_Documentation__c || 
               caseSo.Certificate_Policy_Link__c != oldcaseSO.Certificate_Policy_Link__c || 
               caseSo.Certification_Practice_Statement_Link__c != oldcaseSO.Certification_Practice_Statement_Link__c ||
               caseSo.CP_CPS_Last_Updated_Date__c != oldcaseSO.CP_CPS_Last_Updated_Date__c)) {
              
                 caseSO.addError('Data has been verified. You cannot modify CP/CPS information');                      
          }
                     
          // if all fields verified, change the Request Status to 'Data Verified'
          if (caseSO.Request_Status__c != 'Complete') {
              if (caseSO.Standard_Audit_Verified__c != oldcaseSO.Standard_Audit_Verified__c ||
              caseSO.BR_Audit_Statement_Link_Verified__c != oldcaseSO.BR_Audit_Statement_Link_Verified__c ||
              caseSO.EV_Audit_Statement_Link_Verified__c != oldcaseSO.EV_Audit_Statement_Link_Verified__c ||
              caseSO.CP_CPS_Links_Verified__c != oldcaseSO.CP_CPS_Links_Verified__c) {
                  if ((caseSO.Standard_Audit_Verified__c != null && caseSO.Standard_Audit_Verified__c.equals('Data Verified')) && 
                     ((caseSO.BR_Audit_Statement_Link_Verified__c != null && (caseSO.BR_Audit_Statement_Link_Verified__c.equals('Data Verified') || caseSO.BR_Audit_Statement_Link_Verified__c.equals('Not Applicable')))) &&
                     ((caseSO.EV_Audit_Statement_Link_Verified__c != null && (caseSO.EV_Audit_Statement_Link_Verified__c.equals('Data Verified') || caseSO.EV_Audit_Statement_Link_Verified__c.equals('Not Applicable')))) &&
                     (caseSO.CP_CPS_Links_Verified__c != null && caseSO.CP_CPS_Links_Verified__c.equals('Data Verified'))){
                      
                      caseSO.Request_Status__c = 'Data Verified';
                  } else {
                      caseSO.Request_Status__c = 'Initial Request Received';
                  }
              } 
            }
            // do not allow root store manager to approve a case if the data is not verified
            if (caseSO.Request_Status__c != 'Complete' && caseSO.Request_Status__c != 'Data Verified' && caseSO.Approval_Status__c == 'Approved') {
                caseSO.addError('Root Store Manager must verify audit fields and set verified fields to ‘Data Verified’ before approving the case.');
            }
          } 
       } // for loop all cases of type 'CA Audit Update Request'
    }
    
    //New method for sharing by Sunil
    public static void ManualCaseSharing(List<Case> lstModifiedCases) {
        set<Id> setCaseIds = new set<Id>();
        set<Id> setAccountIds = new set<Id>();
        for(Case objCase: lstModifiedCases){
            setCaseIds.add(objCase.Id);
            setAccountIds.add(objCase.AccountId);
        }
        map<Id,set<Id>> mapAccountWiseGroup = new map<Id,set<Id>>();
        map<Id,Id> mapAccountwiseUR = new map<Id,Id>();
        for(UserRole objUR: [Select Id, Name, PortalAccountId From UserRole Where PortalAccountId in: setAccountIds]){
            mapAccountwiseUR.put(objUR.Id,objUR.PortalAccountId);
        }
        for(Group objG : [SELECT Id, Name, DeveloperName, RelatedId, Type, Email FROM 
                    Group Where RelatedId in: mapAccountwiseUR.keyset()]){
            if(mapAccountwiseUR.containskey(objG.RelatedId)) {
                if(mapAccountWiseGroup.containskey(mapAccountwiseUR.get(objG.RelatedId))){
                    mapAccountWiseGroup.get(mapAccountwiseUR.get(objG.RelatedId)).add(objG.Id);
                } else {
                    mapAccountWiseGroup.put(mapAccountwiseUR.get(objG.RelatedId), new set<Id>{objG.Id});
                }
            }
        }
        map<Id,List<CaseShare>> mapExistingCaseSharing = new map<Id,List<CaseShare>>();
        map<Id,set<Id>> mapExistingCaseSharingGroup = new map<Id,set<Id>>();
        for(CaseShare objCS : [SELECT Id, CaseId, UserOrGroupId, CaseAccessLevel, RowCause, LastModifiedDate, 
                LastModifiedById, IsDeleted FROM CaseShare Where CaseId in :setCaseIds]){
            if(mapExistingCaseSharing.containskey(objCS.CaseId)) {
                mapExistingCaseSharing.get(objCS.CaseId).add(objCS);
            } else {
                mapExistingCaseSharing.put(objCS.CaseId, new List<CaseShare>{objCS});
            }
            if(mapExistingCaseSharingGroup.containskey(objCS.CaseId)){
                mapExistingCaseSharingGroup.get(objCS.CaseId).add(objCS.UserOrGroupId);
            } else {
                mapExistingCaseSharingGroup.put(objCS.CaseId, new set<Id>{objCS.UserOrGroupId});
            }
        } 
        String caseAuditUpdateRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CA Audit Update Request').getRecordTypeId();
        List<CaseShare> lstCaseSharetoUpsert = new List<CaseShare>();
        for(Case objCase: lstModifiedCases){
            if(objCase.RecordTypeId == caseAuditUpdateRecordTypeId){
                if(mapExistingCaseSharing.containskey(objCase.Id)) {
                    if(mapAccountWiseGroup.containskey(objCase.AccountId)) {
                        for(Id groupId: mapAccountWiseGroup.get(objCase.AccountId)){
                            system.debug('Group Id ::: '+groupId);
                            if(mapExistingCaseSharingGroup.containskey(objCase.Id) &&
                                !mapExistingCaseSharingGroup.get(objCase.Id).contains(groupId)) {
                                CaseShare objCaseShare = new CaseShare();
                                objCaseShare.CaseAccessLevel = 'Edit';
                                objCaseShare.CaseId = objCase.Id;
                                objCaseShare.UserOrGroupId = groupId;
                                lstCaseSharetoUpsert.add(objCaseShare);
                            }
                        }
                    }
                } else {
                    if(mapAccountWiseGroup.containskey(objCase.AccountId)) {
                        for(Id groupId: mapAccountWiseGroup.get(objCase.AccountId)){
                            CaseShare objCaseShare = new CaseShare();
                            objCaseShare.CaseAccessLevel = 'Edit';
                            objCaseShare.CaseId = objCase.Id;
                            objCaseShare.UserOrGroupId = groupId;
                            lstCaseSharetoUpsert.add(objCaseShare);
                        }
                    }
                }
            } else {
                if(mapExistingCaseSharing.containskey(objCase.Id)) {
                    for(CaseShare objCS: mapExistingCaseSharing.get(objCase.Id)) {
                        if(objCS.RowCause == 'RelatedPortalUser' && objCS.CaseAccessLevel == 'Edit'){
                            objCS.CaseAccessLevel = 'Read';
                            lstCaseSharetoUpsert.add(objCS);
                        }
                    }
                }
            }
        }
        
        if(lstCaseSharetoUpsert.size() > 0) {
            upsert lstCaseSharetoUpsert;
        }
    }
}