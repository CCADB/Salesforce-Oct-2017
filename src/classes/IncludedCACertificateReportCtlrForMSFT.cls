public class IncludedCACertificateReportCtlrForMSFT {

 public List<Account> accountSoLst {get;set;}
 
  // constructor method for standard controller
    public IncludedCACertificateReportCtlrForMSFT() {   
                                          
           accountSoLst =  [select  Parent.Name, Name, Friendly_Name__c, SHA_1_Fingerprint__c, SHA_256_Fingerprint__c, Microsoft_Trust_Bits__c, Microsoft_EV_policy_OID_s__c, X_509_Certificate_PEM__c
                            from  Account
                            where Microsoft_Status__c In ('Included','Change Requested') 
                            and   RecordType.Name In ('Root Certificate')
                            order by Parent.Name, Friendly_Name__c];
     
       // if we are generating a CSV file then we need to replace the double quotes in all text fields with null
       if ((ApexPages.currentPage().getUrl().contains('CSV') && accountSoLst !=null && accountSoLst.size() > 0) || Test.isRunningTest())
       {
          for(Account accountSo : accountSoLst)
          {
              if(accountSo.name !=null && accountSo.name.length() > 0) 
                   accountSo.name = accountSo.name.replace('"',''); 
              if(accountSo.parent.name !=null && accountSo.parent.name.length() > 0) 
                   accountSo.parent.name = accountSo.parent.name.replace('"',''); 
              if(accountSo.Friendly_Name__c !=null && accountSo.Friendly_Name__c.length() > 0) 
                   accountSo.Friendly_Name__c = accountSo.Friendly_Name__c.replace('"',''); 
          } 
       }   

 
       // if we are generating a CSV file then we need to replace the double quotes in all text fields with null
       if((ApexPages.currentPage().getUrl().contains('CSV') && accountSoLst !=null && accountSoLst.size() > 0) || Test.IsRunningTest())
       {
          for(Account accountSo : accountSoLst)
          {
              if(accountSo.Microsoft_EV_Policy_OID_s__c !=null && accountSo.Microsoft_EV_Policy_OID_s__c.length() > 0) 
                   accountSo.Microsoft_EV_Policy_OID_s__c = accountSo.Microsoft_EV_Policy_OID_s__c.replace('"','');   
           }
        }
    

    } 
     
     String CurrentDate = ' ';
 
    // Get current Datetime in long date format   

    public String getCurrentDate() {

      Datetime cDT = System.now();
      CurrentDate = cDT.format('MMMM d, yyyy');

      return CurrentDate;

   }
     
}