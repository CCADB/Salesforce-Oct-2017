global class MassEmailBatch implements Database.Batchable<sObject>, Database.stateful
{

 global String massEmailRecordId = '';
 
 global Mass_Email__c massEmailSo = null;
 global   Map<Id,Set<String>>  toEmailAddressMap;
 global   Map<Id,Set<String>>  ccEmailAddressMap;

 public MassEmailBatch (String massEmailRecordIdParam,   Map<Id,Set<String>> toMap ,   Map<Id,Set<String>> ccMap)
 
 {
    massEmailRecordId = massEmailRecordIdParam;
    toEmailAddressMap  = toMap;
    ccEmailAddressMap = ccMap;
    
  massEmailSo = [select Id,From__c,SOQL_Filter_Conditions__c, OwnerId, Name,  Subject__c, Reply_To__c, Message__c, Send_To__c, CC_To__c from Mass_Email__c where id =:massEmailRecordId];
 }

 global Database.QueryLocator start(Database.BatchableContext BC)
    {
       
        Boolean fetchOwnerAccounts = false;
        List<Account> accountSoLst; 
        String query = 'select id, CA_Owner_ID__c, CA_Email_Alias_1__c , CA_Email_Alias_2__c from account ';
        if(massEmailSo.SOQL_Filter_Conditions__c!=null && massEmailSo.SOQL_Filter_Conditions__c.length() > 0)  { 
        query = query + ' where ' + massEmailSo.SOQL_Filter_Conditions__c;
        accountSoLst = Database.query(query);
        String rootCertFilter = 'Record_Type_Name__c=RootCertificate';
          String interCertFilter = 'Record_Type_Name__c=IntermediateCertificate';
          String filterConditions = massEmailSo.SOQL_Filter_Conditions__c;
          
            filterConditions= filterConditions.trim();
            
            filterConditions= filterConditions.replaceAll('(\\s+)', '');
            filterConditions= filterConditions.replaceAll('\'', '');

              if( filterConditions.contains(rootCertFilter) || filterConditions.contains(interCertFilter))
              {
                fetchOwnerAccounts = true;
              }
        }
        
        if(fetchOwnerAccounts && accountSoLst!=null && accountSoLst.size() > 0)
        {
          Set<String> ownerAccountIdSet = New Set<String>();
          
          for(Account accountSo : accountSoLst)
          {
            ownerAccountIdSet.add(accountSo.ca_owner_id__c);
          }
          // system.debug('OwnerSet==' + ownerAccountIdSet);
          query = 'select id, name, CA_Owner_ID__c, CA_Email_Alias_1__c , CA_Email_Alias_2__c from account where id in :ownerAccountIdSet';
          return Database.getQueryLocator(query);
        }
        

        
        return Database.getQueryLocator(query);
    }
    
   global void execute(Database.BatchableContext BC, List<Account> scope)
    {
    
       MassEmailBatchHelper batchHelper = new MassEmailBatchHelper ();
       batchHelper.processOwnerRecords(scope, massEmailSo, toEmailAddressMap, ccEmailAddressMap);
    
    }
    
    global void finish(Database.BatchableContext BC)  { 
    
    
    
   
   }
   

}