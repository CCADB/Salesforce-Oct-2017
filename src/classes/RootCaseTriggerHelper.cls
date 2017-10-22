// ========================================================================================================
// RootCaseTriggerHelper: Trigger for the RootCase object which handles all the events and
// based on the event delegates the task to the corresponding trigger handler method in 
// the RootCaseTriggerHelper class.
// ========================================================================================================
// SetAccountStatusField :  (Record Type: CA Owner/Root Inclusion Request)
// *** NO LONGER NEEDED *** This method is invoked whenever a new RootCase is created
// the requirement is to set the status on the related account as "Change Requested" when 
// Root Certificate Name and SHA1 Fingerprint matches the record in Account object where the Account Type is 'Root'
// ========================================================================================================
// SetAllFieldsVerifiedField: (Record Type: CA Owner/Root Inclusion Request)
// Following updates and checks are performed in this trigger when 
// a Root Case record is inserted or updated. Set 'All Fields Verified?' field to 'Yes' if all 
// 'Verified' fields RootCase object are 'Verified' or 'Not Applicable' 
// ========================================================================================================
// SetDefaultForCAOwnerRootInclusionRequest: (Record Type: CA Owner/Root Inclusion Request)
// Set audit fields to NONE!
// If trust bits includes 'Websites' and BR Audit is blank, set BR Audit to 'NONE!'
// If trust bits includes 'Websites'  and EV Policy OID(s) not blank and EV Policy OID(s) not 'Not EV' and
// EV Audit blank then set EV Audit to 'NONE!' 
// ========================================================================================================
// EnforceRequestStatusRulesForInserts : (Record Type: CA Owner/Root Inclusion Request)
// New Root Cases must be saved with Request Status "Initial Request Received"
// ========================================================================================================
// EnforceRequestStatusRulesForUpdates : (Record Type: CA Owner/Root Inclusion Request)
// Displays error messages when following conditions are not met.
// 1) "Ready for Public Discussion" can only be selected after all of the Verified fields either
//    "Verified" or "Not Applicable" 
// 2) "In Public Discussion" can only be selected after "Ready for Public Discussion" or "Discussion on Hold"
// 3) "Discussion on Hold" can only be selected after "In Public Discussion"
// 4) "Pending Approval" can only be selected after "In Public Discussion" or "CA Action Items
//    from Discussion"
// 5) "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV" can only be selected 
//    after "Pending Approval"
// 6) "Included, Pending EV" can only be selected after either "Pending Approval" or 
//    "Approved, Pending Inclusion and EV"
// 7) "On Hold" and "Denied" requires a short explanation in the public comments section
// 8) "Complete" can only be selected after "Approved, Pending Inclusion" or 
//    "Approved, Pending Inclusion and EV" or "Included, Pending EV"
// 9) Request Status cannot be "Complete" or Included, Pending EV” if 'NSS Release When First Included'
//    and 'Firefox Release When First Included' fields are blank.
// ========================================================================================================
// DefaultFieldsOnRootCertificateChange : (Record Type : CA Audit Update Request')
// Set default values to root case fields
// ========================================================================================================

public class RootCaseTriggerHelper { 
    
   // *** NO LONGER NEEDED ***
   // This method is invoked whenever a new RootCase is created
   // the requirement is to set the status on the related account as "Change Requested" when 
   // Root Certificate Name and SHA1 Fingerprint matches
/******    
   public static void SetAccountStatusField(List<Root_Case__c> rootCaseSoLst) {
   
     // process root case with record type = 'CA Owner/Root Inclusion Request'
     String caOwnerRootInclusionRequestRecordTypeId = Schema.SObjectType.Root_Case__c.getRecordTypeInfosByName().get('CA Owner/Root Inclusion Request').getRecordTypeID();


      // list to hold the accountIds
      List<Id> accountIdLst = New List<Id>();

      for (Root_Case__c rootCaseSo :rootCaseSoLst) 
      { 
      
         if(rootCaseSo.RecordTypeId == caOwnerRootInclusionRequestRecordTypeId) {

            // add the account id to the list 
            // we will use this list to fetch all the accounts
         
            // for later enhancements use accountIdLst.add(rootCaseSo.Root_Certificate_Name_Existing__c) 
            // when this 'Existing fields are populated by user
         
            accountIdLst.add(rootCaseSo.Root_Certificate_Name_Existing__c);
         }
      }

     // fetch all the accounts into a map where the key is the "parent" accountId and the value is accountSo
     Map<Id,Account> accountSoMap = New Map<Id,Account>([select SHA_1_Fingerprint__c, status__c 
                                                         from Account where id in :accountIdLst]);

     // if there are more than one records
     if(accountSoMap!=null && accountSoMap.size() > 0)
     {
         Account tempAccountSo;
         List<Account> toBeUpdatedAccountsLst = New List<Account>();
  
         // loop over each root case
         for (Root_Case__c rootCaseSo :rootCaseSoLst) 
         {
             // fetch the corresponding account from the map that we prepared earlier.
             // Send in the accountId that we have on the rootCase as the key and get the 
             // corresponding accountSo
             tempAccountSo =  accountSoMap.get(rootCaseSo.Root_Certificate_Name_Existing__c);
       
             // if an accountSo is returned from the Map and if the SHA of the current 
             // rootCase matches the SHA of that account then update the account status
             if(tempAccountSo!=null && tempAccountSo.SHA_1_Fingerprint__c == rootCaseSo.SHA_1_Fingerprint__c)
             {
                 tempAccountSo.Status__c = 'Change Requested';
         
                 // this account will need to be updated and hence we add it to another list
                 // which would hold all the accountSos that we would be updating
                 toBeUpdatedAccountsLst.add(tempAccountSo);
             }
       
             // system.debug('account.id'+owneraccountSo.id);
             // system.debug('account.name'+owneraccountSo.name);
             // system.debug('account.SHA_1_Fingerprint__c'+owneraccountSo.SHA_1_Fingerprint__c);
   
          }
   
        // if there are more than 1 records in this list then execute the DML
       if(toBeUpdatedAccountsLst.size() > 0)
       {
           update toBeUpdatedAccountsLst;
       }
   }
 
 }    ****/
    
   public static void SetAllFieldsVerifiedField (List<Root_Case__c> RootCaseSoLst) {
   
     // process root case with record type = 'CA Owner/Root Inclusion Request'
     String caOwnerRootInclusionRequestRecordTypeId = Schema.SObjectType.Root_Case__c.getRecordTypeInfosByName().get('CA Owner/Root Inclusion Request').getRecordTypeID();

        
    // loop over all the RootCases which were updated
    for(Root_Case__c RootCaseSo : RootCaseSoLst)
    {
    
       if(rootCaseSo.RecordTypeId == caOwnerRootInclusionRequestRecordTypeId) {

            
         // Set 'All Fields Verified?' field to 'Yes' if all 'Verified' fields
         // in Root RootCase object are 'Verified' or 'Not Applicable'  
         
          RootCaseSO.All_Fields_Verified__c = 'Yes'; // initialize

               
          /* if (RootCaseSO.O_From_Issuer_Field_Verified__c != 'Verified' && 
              RootCaseSO.O_From_Issuer_Field_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';} */
          /* if (RootCaseSO.OU_From_Issuer_Field_Verified__c != 'Verified' && 
              RootCaseSO.OU_From_Issuer_Field_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';} */
         if (RootCaseSO.Certificate_Summary_Verified__c != 'Verified' && 
             RootCaseSO.Certificate_Summary_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Root_Certificate_Download_URL_Verified__c != 'Verified' && 
             RootCaseSO.Root_Certificate_Download_URL_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         /* if (RootCaseSO.SHA_1_Fingerprint_Verified__c != 'Verified' && 
             RootCaseSO.SHA_1_Fingerprint_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';} */
         /* if (RootCaseSO.SHA_256_Fingerprint_Verified__c != 'Verified' && 
             RootCaseSO.SHA_256_Fingerprint_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';} */
         /* if (RootCaseSO.Valid_From_Verified__c != 'Verified' && 
              RootCaseSO.Valid_From_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';} */
         /* if (RootCaseSO.Valid_To_Verified__c != 'Verified' && 
             RootCaseSO.Valid_To_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';} */
         /* if (RootCaseSO.Certificate_Version_Verified__c != 'Verified' && 
             RootCaseSO.Certificate_Version_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';} */
         /* if (RootCaseSO.Cert_Signature_Algorithm_Verified__c != 'Verified' && 
             RootCaseSO.Cert_Signature_Algorithm_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';} */
         /* if (RootCaseSO.Signing_Key_Parameters_Verified__c != 'Verified' && 
             RootCaseSO.Signing_Key_Parameters_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';} */                
         /* if (RootCaseSO.Test_Website_Verified__c != 'Verified' && 
             RootCaseSO.Test_Website_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}   */                                                    
         if (RootCaseSO.TestWebsiteURLSSLorExCert_Verified__c != 'Verified' && 
             RootCaseSO.TestWebsiteURLSSLorExCert_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}        
         if (RootCaseSO.CRL_URL_Verified__c != 'Verified' && 
             RootCaseSO.CRL_URL_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';} 
         if (RootCaseSO.OCSP_URL_Verified__c != 'Verified' && 
             RootCaseSO.OCSP_URL_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';} 
         if (RootCaseSO.Revocation_Tested_Verified__c != 'Verified' && 
             RootCaseSO.Revocation_Tested_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}                      
         if (RootCaseSO.Trust_Bits_Verified__c != 'Verified' && 
             RootCaseSO.Trust_Bits_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.SSL_Validation_Type_Verified__c != 'Verified' && 
             RootCaseSO.SSL_Validation_Type_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.EV_Policy_OID_s_Verified__c != 'Verified' && 
             RootCaseSO.EV_Policy_OID_s_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.EV_Tested_Verified__c != 'Verified' && 
             RootCaseSO.EV_Tested_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}                 
         if (RootCaseSO.CA_Browser_Forum_Lint_Test_Verified__c != 'Verified' && 
             RootCaseSO.CA_Browser_Forum_Lint_Test_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}                           
         if (RootCaseSO.Test_Website_Lint_Test_Verified__c != 'Verified' && 
             RootCaseSO.Test_Website_Lint_Test_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}                                           
         if (RootCaseSO.Root_Stores_Included_In_Verified__c != 'Verified' && 
             RootCaseSO.Root_Stores_Included_In_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Mozilla_Applied_Constraints_Verified__c != 'Verified' && 
             RootCaseSO.Mozilla_Applied_Constraints_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.CA_Hierarchy_Verified__c != 'Verified' && 
             RootCaseSO.CA_Hierarchy_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Externally_Operated_SubCAs_Verified__c != 'Verified' && 
             RootCaseSO.Externally_Operated_SubCAs_Verified__c!= 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Cross_Signing_Verified__c != 'Verified' && 
             RootCaseSO.Cross_Signing_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Tech_Cons_on_3rd_party_Iss_Verified__c != 'Verified' && 
             RootCaseSO.Tech_Cons_on_3rd_party_Iss_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Policy_Documentation_Verified__c != 'Verified' && 
             RootCaseSO.Policy_Documentation_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.CA_Document_Repository_Verified__c != 'Verified' && 
             RootCaseSO.CA_Document_Repository_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.CP_Verified__c != 'Verified' && 
             RootCaseSO.CP_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.CPS_Verified__c != 'Verified' && 
              RootCaseSO.CPS_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Other_Relevant_Documents_Verified__c != 'Verified' && 
             RootCaseSO.Other_Relevant_Documents_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Auditor_New_Verified__c != 'Verified' && 
             RootCaseSO.Auditor_New_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Auditor_Location_New_Verified__c != 'Verified' && 
             RootCaseSO.Auditor_Location_New_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}                  
         /* if (RootCaseSO.Auditor_Name_Verified__c != 'Verified' && 
             RootCaseSO.Auditor_Name_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';} */
         /* if (RootCaseSO.Auditor_Website_Verified__c != 'Verified' && 
             RootCaseSO.Auditor_Website_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';} */
         /* if (RootCaseSO.Auditor_Qualifications_Verified__c != 'Verified' && 
             RootCaseSO.Auditor_Qualifications_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';} */
         if (RootCaseSO.Management_Assertions_By_Verified__c != 'Verified' && 
             RootCaseSO.Management_Assertions_By_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}                                   
         if (RootCaseSO.Standard_Audit_Verified__c != 'Verified' && 
             RootCaseSO.Standard_Audit_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Standard_Audit_Type_Verified__c != 'Verified' && 
             RootCaseSO.Standard_Audit_Type_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Standard_Audit_Statement_Dt_Verified__c != 'Verified' && 
             RootCaseSO.Standard_Audit_Statement_Dt_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Standard_Audit_Period_Dates_Verified__c != 'Verified' && 
             RootCaseSO.Standard_Audit_Period_Dates_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}                                                             
         if (RootCaseSO.BR_Audit_Verified__c != 'Verified' && 
             RootCaseSO.BR_Audit_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.BR_Audit_Type_Verified__c != 'Verified' && 
             RootCaseSO.BR_Audit_Type_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.BR_Audit_Statement_Date_Verified__c != 'Verified' && 
             RootCaseSO.BR_Audit_Statement_Date_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';} 
         if (RootCaseSO.BR_Audit_Period_Dates_Verified__c != 'Verified' && 
             RootCaseSO.BR_Audit_Period_Dates_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}      
         if (RootCaseSO.EV_Audit_Verified__c != 'Verified' && 
             RootCaseSO.EV_Audit_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.EV_Audit_Type_Verified__c != 'Verified' && 
             RootCaseSO.EV_Audit_Type_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.EV_Audit_Statement_Date_Verified__c != 'Verified' && 
             RootCaseSO.EV_Audit_Statement_Date_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.EV_SSL_Audit_Period_Dates_Verified__c != 'Verified' && 
             RootCaseSO.EV_SSL_Audit_Period_Dates_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.BR_Commitment_to_Comply_Verified__c != 'Verified' && 
             RootCaseSO.BR_Commitment_to_Comply_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}                 
         if (RootCaseSO.BR_Self_Assessment_Verified__c != 'Verified' && 
             RootCaseSO.BR_Self_Assessment_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}                 
         if (RootCaseSO.SSL_Verification_Procedures_Verified__c != 'Verified' && 
             RootCaseSO.SSL_Verification_Procedures_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.EV_SSL_Verification_Proc_Verified__c != 'Verified' && 
             RootCaseSO.EV_SSL_Verification_Proc_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Org_Verification_Procedure_Verified__c != 'Verified' && 
             RootCaseSO.Org_Verification_Procedure_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Email_Addr_Verification_Proc_Verified__c != 'Verified' && 
             RootCaseSO.Email_Addr_Verification_Proc_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Code_Signing_Subs_Verif_Proc_Verified__c != 'Verified' && 
             RootCaseSO.Code_Signing_Subs_Verif_Proc_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Multi_Factor_Authentication_Verified__c != 'Verified' && 
             RootCaseSO.Multi_Factor_Authentication_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Network_Security_Verified__c != 'Verified' && 
             RootCaseSO.Network_Security_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         /* if (RootCaseSO.Publ_Discl_Audited_subCAs_Verified__c != 'Verified' && 
             RootCaseSO.Publ_Discl_Audited_subCAs_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';} */
                  
         } // process root case of type 'CA Owner/Root Inclusion Request'
            
       }  // for loop    
    }
    
    public static void SetDefaultForCAOwnerRootInclusionRequest (List<Root_Case__c> RootCaseSoLst){             
      
        // process root case with record type = 'CA Owner/Root Inclusion Request'
        String caOwnerRootInclusionRequestRecordTypeId = Schema.SObjectType.Root_Case__c.getRecordTypeInfosByName().get('CA Owner/Root Inclusion Request').getRecordTypeID();
        
        //set of case id related root case
        set<Id> setCaseIds = new set<Id>();
        for(Root_Case__c RootCaseSo : RootCaseSoLst){
            if(RootCaseSo.Case_No__c != null) {
                setCaseIds.add(RootCaseSo.Case_No__c);
            }
        }
        map<Id,Case> mapRelatedCase = new map<Id,Case>();  
        //if set of account size is fill
        if(setCaseIds.size() > 0) {
            mapRelatedCase = new map<Id,Case>([select Id,Account.Name,Account.Management_Assertions_By__c from Case Where Id in: setCaseIds]);
        }
        // loop over all the RootCases which were inserted
        for(Root_Case__c RootCaseSo : RootCaseSoLst)
        {       
            if(rootCaseSo.RecordTypeId == caOwnerRootInclusionRequestRecordTypeId) {
                    
                  // If trust bits includes 'Websites' and BR Audit is blank, set BR Audit to 'NONE!'
                  if (RootCaseSO.trust_bits__c != null && RootCaseSO.trust_bits__c.contains('Websites') && RootCaseSO.BR_Audit__c == null) {           
                     RootCaseSO.BR_Audit__c = 'NONE!';
                  } 
                 // If trust bits includes 'Websites' and EV Policy OID(s) not blank and EV Policy OID(s) not 'Not EV' and
                 // EV Audit blank then set EV Audit to 'NONE!'
                 if (RootCaseSO.trust_bits__c != null && RootCaseSO.trust_bits__c.contains('Websites') 
                    && RootCaseSO.EV_Policy_OID_s__c != null && RootCaseSO.EV_Policy_OID_s__c != 'Not EV' 
                    && RootCaseSO.EV_Audit__c == null) {           
                     RootCaseSO.EV_Audit__c = 'NONE!';
                 } 
                 if (RootCaseSO.Management_Assertions_By__c == null || RootCaseSO.Management_Assertions_By__c == '') {
                     if(mapRelatedCase.size() > 0 && mapRelatedCase.containskey(RootCaseSO.Case_No__c)) {
                         RootCaseSO.Management_Assertions_By__c = mapRelatedCase.get(RootCaseSO.Case_No__c).Account.Name; 
                     }
                 }           
             }
        } 
    }
    
    
    public static void EnforceRequestStatusRulesForInserts (List<Root_Case__c> RootCaseSoLst)
    {
        // loop over all the RootCases which were inserted
        String caOwnerRootInclusionRequestRecordTypeId = Schema.SObjectType.Root_Case__c.getRecordTypeInfosByName().get('CA Owner/Root Inclusion Request').getRecordTypeID();
        for(Root_Case__c RootCaseSo : RootCaseSoLst)
        {
            if (RootCaseSO.RecordTypeId == caOwnerRootInclusionRequestRecordTypeId && !RootCaseSO.Request_Status__c.equals('Initial Request Received')) {           
                  RootCaseSO.addError('New Root Case must be saved with Request Status "Initial Request Received"');
            }          
        } 
    }

     public static void EnforceRequestStatusRulesForUpdates (List<Root_Case__c> RootCaseSoLst, Map<Id, Root_Case__c> oldRootCaseSoLst) {
                                                             
     // process root case with record type = 'CA Owner/Root Inclusion Request'
     String caOwnerRootInclusionRequestRecordTypeId = Schema.SObjectType.Root_Case__c.getRecordTypeInfosByName().get('CA Owner/Root Inclusion Request').getRecordTypeID();
                                                            
 
        // loop over all the RootCases which were updated
       for(Root_Case__c RootCaseSo : RootCaseSoLst)
       {
       
         if(rootCaseSo.RecordTypeId == caOwnerRootInclusionRequestRecordTypeId) {
 
         // Set oldRootCaseSo to triggeRootCaseSO.old value
         
         Root_Case__c oldRootCaseSo = oldRootCaseSOLst.get(RootCaseSo.Id); 
           
        // check for request_status field only if this field was modified
           
         if (!RootCaseSO.Request_Status__c.equals(oldRootCaseSO.Request_Status__c)) {
         
         // "Ready for Public Discussion" can only be selected after all of the Verified fields either 
         // "Verified" or "Not Applicable", and all corresponding Root RootCases have Request status 
         // of one of "Ready For Public Discussion", "On Hold", "Denied" 
          
         if (RootCaseSO.Request_Status__c.equals('Ready for Public Discussion')) {
             if (RootCaseSO.All_Fields_Verified__c.equals('No')) {
                  RootCaseSO.addError('Request Status "Ready for Public Discussion" can only be selected after all of the Verified fields either "Verified" or "Not Applicable" ');
             }
         }
         
          // "In Public Discussion" can only be selected after "Ready for Public Discussion"

         if (RootCaseSO.Request_Status__c.equals('In Public Discussion')) {
             if (!oldRootCaseSO.Request_Status__c.equals('Ready for Public Discussion') && !oldRootCaseSO.Request_Status__c.equals('Discussion on Hold')) {
                  RootCaseSO.addError('Request Status "In Public Discussion" can only be selected after "Ready for Public Discussion" or "Discussion on Hold"');
             }
         }
         
         // "Discussion on Hold" can only be selected after "In Public Discussion"

         if (RootCaseSO.Request_Status__c.equals('Discussion on Hold')) {
             if (!oldRootCaseSO.Request_Status__c.equals('In Public Discussion')) {
                  RootCaseSO.addError('Request Status "Discussion on Hold" can only be selected after "In Public Discussion"');
             }
         }         
         
         // "Pending Approval" can only be selected after "In Public Discussion" or "CA Action Items from Discussion"

         if (RootCaseSO.Request_Status__c.equals('Pending Approval')) {
             if (!oldRootCaseSO.Request_Status__c.equals('In Public Discussion') && !oldRootCaseSO.Request_Status__c.equals('CA Action Items from Discussion')) {
                  RootCaseSO.addError('Request Status "Pending Approval" can only be selected after "In Public Discussion" or "CA Action Items from Discussion"');
             }
         }
         
         // "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV" can only be selected after "Pending Approval"

        if (RootCaseSO.Request_Status__c.equals('Approved, Pending Inclusion') || RootCaseSO.Request_Status__c.equals('Approved, Pending Inclusion and EV')) {
             if (!oldRootCaseSO.Request_Status__c.equals('Pending Approval')) {
                  RootCaseSO.addError('Request Status "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV" can only be selected after "Pending Approval"');
             }
         }
         
         // "Included, Pending EV" can only be selected after either "Pending Approval" or "Approved, Pending Inclusion and EV"

        if (RootCaseSO.Request_Status__c.equals('Included, Pending EV')) {
             if (!oldRootCaseSO.Request_Status__c.equals('Pending Approval') && !oldRootCaseSO.Request_Status__c.equals('Approved, Pending Inclusion and EV')) {
                  RootCaseSO.addError('Request Status "Included, Pending EV" can only be selected after either "Pending Approval" or "Approved, Pending Inclusion and EV"');
             }
         }
         
 
         // "On Hold" and "Denied" requires a short explanation in the public comments section
         
         if (RootCaseSO.Request_Status__c.equals('On Hold') || RootCaseSO.Request_Status__c.equals('Denied')) {
             if ((RootCaseSO.Comments__c == NULL) && (RootCaseSO.Comments_by_Mozilla_on_Root_Case__c == NULL)) {
                  RootCaseSO.addError('Request Status "On Hold" and "Denied" requires a short explanation in the Internal/Public comments section');
             }
         }
           
         // "Complete" can only be selected after "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV" or "Included, Pending EV"

         if (RootCaseSO.Request_Status__c.equals('Complete')) {
             if (!oldRootCaseSO.Request_Status__c.equals('Approved, Pending Inclusion') && !oldRootCaseSO.Request_Status__c.equals('Approved, Pending Inclusion and EV') && !oldRootCaseSO.Request_Status__c.equals('Included, Pending EV')) {
                  RootCaseSO.addError('Request Status "Complete" can only be selected after "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV" or "Included, Pending EV"');
             }
          }
        }     
                                                                 
       // Request Status cannot be "Complete" or Included, Pending EV” if 'NSS Release When First Included'
       // and 'Firefox Release When First Included' fields are blank.
       if (RootCaseSO.Request_Status__c.equals('Complete') || RootCaseSO.Request_Status__c.equals('Included, Pending EV')) {
         if (RootCaseSO.NSS_Release_When_First_Included__c == Null) {
              RootCaseSO.addError('Request Status "Complete" or "Included, Pending EV" can only be selected after filling in "NSS Release When First Included"');
         }
         if (RootCaseSO.Firefox_Release_When_First_Included__c == Null) {
              RootCaseSO.addError('Request Status "Complete" or "Included, Pending EV" can only be selected after filling in "Firefox Release When First Included"');
         }
       }
       
       }
     } // for loop
   }
   
    public static void defaultFieldsOnRootCertificateChange(List<Root_Case__c> lstNewRootCases, Map<Id, Root_Case__c> mapOldRootCases){
       
       Set<Id> setRootCertificates = new Set<Id>();
       Set<Id> setCAOwnerExisting = new Set<Id>();
       
       String caAuditUpdateRequestRecordTypeId = Schema.SObjectType.Root_Case__c.getRecordTypeInfosByName().get('CA Audit Update Request').getRecordTypeID();
       
       Map<Id, Account> mapCAOwnerNameExisting = new Map<Id, Account>();
       Map<Id, Account> mapIdToRootCerts = new Map<Id, Account>();
       
       for(Root_Case__c rootCase : lstNewRootCases){
           
           if(rootCase.RecordTypeId == caAuditUpdateRequestRecordTypeId){
               
               Root_Case__c oldRootCase = mapOldRootCases.get(rootCase.Id);
               //iterate on old
               setCAOwnerExisting.add(oldRootCase.CA_Owner_Name_Existing__c);
               
               //iterate on new
               setRootCertificates.add(rootCase.Root_Certificate_Name_Existing__c);
           }
       }
       
       if(setCAOwnerExisting.size() > 0){
           mapCAOwnerNameExisting = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE Id IN :setCAOwnerExisting]);
       }
        
       if(setRootCertificates.size() > 0){
           mapIdToRootCerts = new Map<Id, Account>([SELECT Id, Name, Microsoft_Status__c, Status__c, 
                                                    Certificate_Issuer_Organization__c,
                                                    Test_Website_Valid__c, Test_Website_Revoked__c, Test_Website_Expired__c,
                                                    Valid_To_GMT__c, Valid_From_GMT__c,
                                                    Microsoft_Trust_Bits__c, Trust_Bits__c, Removal_Bug_No_or_Date__c,
                                                    SHA_1_Fingerprint__c, SHA_256_Fingerprint__c, 
                                                    EV_Policy_OID_s__c, Microsoft_EV_Policy_OID_s__c, Microsoft_EV_Enabled__c
                                                    FROM Account WHERE Id IN :setRootCertificates]);
       }
       for(Root_Case__c rootCase : lstNewRootCases){
            
            if(rootCase.RecordTypeId == caAuditUpdateRequestRecordTypeId){
                
                // Set oldRootCaseSo to triggeRootCaseSO.old value        
                 Root_Case__c oldRootCaseSo = mapOldRootCases.get(rootCase.Id);
                
                if(mapCAOwnerNameExisting.containsKey(oldRootCaseSo.CA_Owner_Name_Existing__c)){
                    String caOwnerNameExisting = mapCAOwnerNameExisting.get(oldRootCaseSo.CA_Owner_Name_Existing__c).Name;
                    // Included CA Owner Name" must be same as "CA Owner/Certificate Name"; Do not allow user to change
                    if (rootCase.CA_Owner_Name_Existing__c != oldRootCaseSo.CA_Owner_Name_Existing__c) {
                        rootCase.addError('"Included CA Owner Name" must be same as "CA Owner/Certificate Name" from Case page: '+caOwnerNameExisting);      
                    }   
                }               
                
                
                // do not allow user to modify Test Website block 
                if(rootCase.Test_Website_Verified__c == 'Data Verified' & (rootCase.Test_Website_Valid__c != oldRootCaseSO.Test_Website_Valid__c ||
                     rootCase.Test_Website_Revoked__c != oldRootCaseSO.Test_Website_Revoked__c || rootCase.Test_Website_Expired__c != oldRootCaseSO.Test_Website_Expired__c)) {
              
                    rootCase.addError('Data has been verified. You cannot modify Test Website fields');                      
                }
                
                // set Request Status to 'Data Verified' when Verified field is either 'Data Verified' or 'Not Applicable'
                if (rootCase.Request_Status__c != 'Complete' && rootCase.Test_Website_Verified__c != oldRootCaseSO.Test_Website_Verified__c) {             
                    if(rootCase.Test_Website_Verified__c != null && (rootCase.Test_Website_Verified__c == 'Data Verified' || rootCase.Test_Website_Verified__c == 'Not Applicable')) {
                        rootCase.Request_Status__c = 'Data Verified';
                    } else {
                        rootCase.Request_Status__c = 'Initial Request Received';
                    }
                }
                
                // if Request Status is 'Complete' then do not allow any changes to the root case record
                if (rootCase.Request_Status__c == 'Complete' &&
                
                    (rootCase.CA_Owner_Name_Existing__c  != oldRootCaseSo.CA_Owner_Name_Existing__c  ||
                     rootCase.Root_Certificate_Name_Existing__c != oldRootCaseSo.Root_Certificate_Name_Existing__c ||                    
                     rootCase.Test_Website_Valid__c != oldRootCaseSo.Test_Website_Valid__c ||
                     rootCase.Test_Website_Revoked__c != oldRootCaseSo.Test_Website_Revoked__c ||
                     rootCase.Test_Website_Expired__c != oldRootCaseSo.Test_Website_Expired__c ||
                     rootCase.Apply_Standard_Audit__c != oldRootCaseSo.Apply_Standard_Audit__c ||
                     rootCase.Apply_BR_Audit__c != oldRootCaseSo.Apply_BR_Audit__c ||
                     rootCase.Apply_EV_Audit__c != oldRootCaseSo.Apply_EV_Audit__c ||
                     rootCase.Apply_EV_Code_Signing_Audit__c != oldRootCaseSo.Apply_EV_Code_Signing_Audit__c ||
                     rootCase.Comments_by_Mozilla_on_Root_Case__c != oldRootCaseSo.Comments_by_Mozilla_on_Root_Case__c ||
                     rootCase.Comments__c != oldRootCaseSo.Comments__c)) {               
                    
                        rootCase.addError('Request Status is \'Complete\'. You cannot modify this Root Case');            
                }
                  
                // pre populate fields from Root Cert record                   
                if(mapIdToRootCerts.containsKey(rootCase.Root_Certificate_Name_Existing__c) && rootCase.Root_Certificate_Name_Existing__c != null && rootCase.CA_Owner_Name_Existing__c != oldRootCaseSo.Root_Certificate_Name_Existing__c){
 
                   // pre populate Test Website fields from Root Certs only if blank    
                   if (oldRootCaseSo.Root_Certificate_Name_Existing__c <> rootCase.Root_Certificate_Name_Existing__c) {
                      if (rootCase.Test_Website_Valid__c == null && mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Test_Website_Valid__c != null) {
                         rootCase.Test_Website_Valid__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Test_Website_Valid__c;
                       }
                       if (rootCase.Test_Website_Revoked__c == null && mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Test_Website_Revoked__c != null) {
                          rootCase.Test_Website_Revoked__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Test_Website_Revoked__c;
                       }
                       if (rootCase.Test_Website_Expired__c == null && mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Test_Website_Expired__c != null) {
                          rootCase.Test_Website_Expired__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Test_Website_Expired__c;
                       }
                   }
                   
                   rootCase.Microsoft_Status__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Microsoft_Status__c;
                   rootCase.Mozilla_Status__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Status__c;
                   rootCase.Trust_Bits__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Trust_Bits__c;
                   rootCase.Microsoft_Trust_Bits__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Microsoft_Trust_Bits__c;
                   rootCase.Mozilla_Removal_Bug_No_or_Date__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Removal_Bug_No_or_Date__c;
                   rootCase.SHA_1_Fingerprint__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).SHA_1_Fingerprint__c;
                   rootCase.SHA_256_Fingerprint__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).SHA_256_Fingerprint__c;                  
                   rootCase.EV_Policy_OID_s__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).EV_Policy_OID_s__c; 
                   rootCase.Microsoft_EV_Policy_OID_s__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Microsoft_EV_Policy_OID_s__c;  
                   rootCase.Microsoft_EV_Enabled__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Microsoft_EV_Enabled__c;               
                   rootCase.Case_CAOwner_RootCert__c = 'CaseID:' + String.valueOf(rootCase.Case_No__c) + '+CAOwnerID:' + String.valueOf(rootCase.CA_Owner_Name_Existing__c) + '+RootCertID:' + String.valueOf(rootCase.Root_Certificate_Name_Existing__c);
                   
                   // fill in root certificate name; fields not used on page layout but visible on list views
                   rootCase.Root_Certificate_Name__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Name;
                   rootCase.Valid_From__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Valid_From_GMT__c;
                   rootCase.Valid_To__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Valid_To_GMT__c;
                   rootCase.O_From_Issuer_Field__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Certificate_Issuer_Organization__c;

               }
            }
       }
   } 
     
   /*
   *If the Request Status on Case is "Data Verified" and all corresponding Root Cases have Request status = 'Complete' 
   then change the Case.Request Status to "Complete" and Case.Status to "Closed".
   */
   public static void rollupRootCaseStatusToCase(List<Root_Case__c> lstNewRootCases, Map<Id, Root_Case__c> mapOldRootCases){
       
       Set<Id> setCompletedRootCase = new Set<Id>();
       List<Case> lstCasesToUpdate = new List<Case>();
       Set<Id> setCurrentRootCases = new Set<Id>();
       String caAuditUpdateRequestRecordTypeId = Schema.SObjectType.Root_Case__c.getRecordTypeInfosByName().get('CA Audit Update Request').getRecordTypeID();
       
       for(Root_Case__c rootCase : lstNewRootCases){
           
           if(caAuditUpdateRequestRecordTypeId == rootCase.RecordTypeId && rootCase.Request_Status__c == 'Complete'){
               setCompletedRootCase.add(rootCase.Case_No__c);
               setCurrentRootCases.add(rootCase.Id);
           }
       }
       
       if(setCompletedRootCase.Size() > 0){
           
           for(Case caseSO : [SELECT Id, Status, (SELECT Id, Request_Status__c FROM Root_Cases__r) FROM Case WHERE Id IN :setCompletedRootCase]){
               
               Boolean isCaseClosed = true;
               
               for(Root_Case__c rootCase : caseSO.Root_Cases__r){
                   
                   if(!setCurrentRootCases.contains(rootCase.Id) && rootCase.Request_Status__c != 'Complete'){
                       isCaseClosed = false;
                       break;
                   }
               }
               
               if(isCaseClosed){
                   caseSO.Status = 'Closed';
                   caseSO.Request_Status__c = 'Complete';
                   lstCasesToUpdate.add(caseSO);
               }
           }
       }
       
       try {
           if(lstCasesToUpdate.size() > 0){
               update lstCasesToUpdate;
           }    
       } catch (Exception ex){
           for(Root_Case__c objRootCase: lstNewRootCases){
               objRootCase.addError(ex.getMessage());
           }
       }
   }
   
   /*
       set default values to Root case on insertion
   */
   public static void defaultFieldsRootCaseInsert(List<Root_Case__c> lstNewRootCases){
       
       Set<Id> setRootCertificates = new Set<Id>();
       String caAuditUpdateRequestRecordTypeId = Schema.SObjectType.Root_Case__c.getRecordTypeInfosByName().get('CA Audit Update Request').getRecordTypeID();
      
       for(Root_Case__c rootCase : lstNewRootCases){
            
            if(rootCase.RecordTypeId == caAuditUpdateRequestRecordTypeId) {
               setRootCertificates.add(rootCase.Root_Certificate_Name_Existing__c);
           }
       }
       
       if(setRootCertificates.size() > 0){
           
           Map<Id, Account> mapIdToRootCerts = new Map<Id, Account>([SELECT Id, Name, Status__c, Microsoft_Status__c, 
                                               Certificate_Issuer_Organization__c, Valid_To_GMT__c, Valid_From_GMT__c,
                                               Test_Website_Valid__c, Test_Website_Revoked__c, Test_Website_Expired__c,
                                               Microsoft_Trust_Bits__c, Trust_Bits__c, Removal_Bug_No_or_Date__c,
                                               SHA_1_Fingerprint__c, SHA_256_Fingerprint__c,
                                               EV_Policy_OID_s__c, Microsoft_EV_Policy_OID_s__c, Microsoft_EV_Enabled__c
                                               FROM Account WHERE Id IN :setRootCertificates]);
                                               
           for(Root_Case__c rootCase : lstNewRootCases){
               
               if(rootCase.RecordTypeId == caAuditUpdateRequestRecordTypeId && rootCase.Root_Certificate_Name_Existing__c != null){

                   // pre populate Test Website fields from Root Certs only if blank
                   if (rootCase.Test_Website_Valid__c == null && mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Test_Website_Valid__c != null) {
                      rootCase.Test_Website_Valid__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Test_Website_Valid__c;
                   }
                   if (rootCase.Test_Website_Revoked__c == null && mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Test_Website_Revoked__c != null) {
                      rootCase.Test_Website_Revoked__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Test_Website_Revoked__c;
                   }
                   if (rootCase.Test_Website_Expired__c == null && mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Test_Website_Expired__c != null) {
                      rootCase.Test_Website_Expired__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Test_Website_Expired__c;
                   }
                   
                   rootCase.Mozilla_Status__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Status__c;
                   rootCase.Microsoft_Status__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Microsoft_Status__c;
                   rootCase.Trust_Bits__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Trust_Bits__c;
                   rootCase.Microsoft_Trust_Bits__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Microsoft_Trust_Bits__c;
                   rootCase.Mozilla_Removal_Bug_No_or_Date__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Removal_Bug_No_or_Date__c;                         
                   rootCase.SHA_1_Fingerprint__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).SHA_1_Fingerprint__c;
                   rootCase.SHA_256_Fingerprint__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).SHA_256_Fingerprint__c; 
                   rootCase.EV_Policy_OID_s__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).EV_Policy_OID_s__c; 
                   rootCase.Microsoft_EV_Policy_OID_s__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Microsoft_EV_Policy_OID_s__c;  
                   rootCase.Microsoft_EV_Enabled__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Microsoft_EV_Enabled__c;               
                   rootCase.Case_CAOwner_RootCert__c = 'CaseID:' + String.valueOf(rootCase.Case_No__c) + '+CAOwnerID:' + String.valueOf(rootCase.CA_Owner_Name_Existing__c) + '+RootCertID:' + String.valueOf(rootCase.Root_Certificate_Name_Existing__c);
                   
                   // fill in root certificate name; fields not used on page layout but visible on list views
                   rootCase.Root_Certificate_Name__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Name;
                   rootCase.Valid_From__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Valid_From_GMT__c;
                   rootCase.Valid_To__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Valid_To_GMT__c;
                   rootCase.O_From_Issuer_Field__c = mapIdToRootCerts.get(rootCase.Root_Certificate_Name_Existing__c).Certificate_Issuer_Organization__c;
                 
               }
            }
        }
    }
    
    //New method for sharing by Sunil
    /*public static void ManualRootCaseSharing(List<Root_Case__c> lstModifiedRootCases) {
        set<Id> setRootCaseIds = new set<Id>();
        set<Id> setAccountIds = new set<Id>();
        for(Root_Case__c objRCase: lstModifiedRootCases){
            setRootCaseIds.add(objRCase.Id);
            setAccountIds.add(objRCase.CA_Owner_Name_Existing__c);
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
        map<Id,List<Root_Case__Share>> mapExistingRootCaseSharing = new map<Id,List<Root_Case__Share>>();
        map<Id,set<Id>> mapExistingRootCaseSharingGroup = new map<Id,set<Id>>();
        for(Root_Case__Share objRCS : [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause 
                FROM Root_Case__Share Where ParentId in: setRootCaseIds]){
            if(mapExistingRootCaseSharing.containskey(objRCS.ParentId)) {
                mapExistingRootCaseSharing.get(objRCS.ParentId).add(objRCS);
            } else {
                mapExistingRootCaseSharing.put(objRCS.ParentId, new List<Root_Case__Share>{objRCS});
            }
            if(mapExistingRootCaseSharingGroup.containskey(objRCS.ParentId)){
                mapExistingRootCaseSharingGroup.get(objRCS.ParentId).add(objRCS.UserOrGroupId);
            } else {
                mapExistingRootCaseSharingGroup.put(objRCS.ParentId, new set<Id>{objRCS.UserOrGroupId});
            }
        } 
        String caseAuditUpdateRecordTypeId = Schema.SObjectType.Root_Case__c.getRecordTypeInfosByName().get('CA Audit Update Request').getRecordTypeID();
        List<Root_Case__Share> lstRootCaseSharetoUpsert = new List<Root_Case__Share>();
        for(Root_Case__c objRCase: lstModifiedRootCases){
            if(objRCase.RecordTypeId == caseAuditUpdateRecordTypeId){
                if(mapExistingRootCaseSharing.containskey(objRCase.Id)) {
                    if(mapAccountWiseGroup.containskey(objRCase.CA_Owner_Name_Existing__c)) {
                        for(Id groupId: mapAccountWiseGroup.get(objRCase.CA_Owner_Name_Existing__c)){
                            system.debug('Group Id ::: '+groupId);
                            if(mapExistingRootCaseSharingGroup.containskey(objRCase.Id) &&
                                !mapExistingRootCaseSharingGroup.get(objRCase.Id).contains(groupId)) {
                                Root_Case__Share objRootCaseShare = new Root_Case__Share();
                                objRootCaseShare.AccessLevel = 'Edit';
                                objRootCaseShare.ParentId = objRCase.Id;
                                objRootCaseShare.UserOrGroupId = groupId;
                                lstRootCaseSharetoUpsert.add(objRootCaseShare);
                            }
                        }
                    }
                } else {
                    if(mapAccountWiseGroup.containskey(objRCase.CA_Owner_Name_Existing__c)) {
                        for(Id groupId: mapAccountWiseGroup.get(objRCase.CA_Owner_Name_Existing__c)){
                            Root_Case__Share objRootCaseShare = new Root_Case__Share();
                            objRootCaseShare.AccessLevel = 'Edit';
                            objRootCaseShare.ParentId = objRCase.Id;
                            objRootCaseShare.UserOrGroupId = groupId;
                            lstRootCaseSharetoUpsert.add(objRootCaseShare);
                        }
                    }
                }
            } else {
                if(mapExistingRootCaseSharing.containskey(objRCase.Id)) {
                    for(Root_Case__Share objRCS: mapExistingRootCaseSharing.get(objRCase.Id)) {
                        if(objRCS.RowCause == 'RelatedPortalUser' && objRCS.AccessLevel == 'Edit'){
                            objRCS.AccessLevel = 'Read';
                            lstRootCaseSharetoUpsert.add(objRCS);
                        }
                    }
                }
            }
        }
        
        if(lstRootCaseSharetoUpsert.size() > 0) {
            upsert lstRootCaseSharetoUpsert;
        }
    }*/
}