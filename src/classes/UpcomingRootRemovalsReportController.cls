/********************************************************************************************************************
  UpcomingRootRemovalsReportController is a controller for UpcomingRootRemovalsReport, UpcomingRootRemovalsReportCSVFormat
  and UpcomingRootRemovalsReportPEMCSV VF pages to list root certificates to be removed. Report name used is 'Mozilla Upcoming Root Removals List' 
  
 *********************************************************************************************************************/

public class UpcomingRootRemovalsReportController{

 public List<Account> accountSoLst {get;set;}
 
  // constructor method for standard controller
    public UpcomingRootRemovalsReportController() {   
                                          
           accountSoLst =  [select  Parent.Name,
                                    Certificate_Issuer_Organization__c,
                                    Certificate_Issuer_Organizational_Unit__c,
                                    Name,
                                    SHA_256_Fingerprint__c, 
                                    Certificate_Serial_Number__c,
                                    Certificate_ID__c,                                                                
                                    Valid_From_YYYY_MMM_DD__c,
                                    Valid_To_YYYY_MMM_DD__c,
                                    Public_Key_Algorithm__c,
                                    Signature_Hash_Algorithm__c,
                                    Trust_Bits__c,
                                    EV_Policy_OID_s__c, 
                                    Removal_Bug_No_or_Date__c,
                                    Approval_Bug__c,
                                    NSS_Release_When_First_Included__c,
                                    Firefox_Release_When_First_Included__c,
                                    NSS_Release_When_Removed__c,
                                    Firefox_Release_When_Removed__c,
                                    URL_to_Test_Website_or_Example_Cert__c,
                                    Mozilla_Applied_Constraints__c, 
                                    Parent.Company_Website__c,
                                    Parent.Geographic_Focus__c,
                                    Certificate_Policy_CP__c,
                                    Certification_Practice_Statement_CPS__c,
                                    Standard_Audit__c,
                                    BR_Audit__c, 
                                    EV_Audit__c,
                                    Auditor__c,
                                    Standard_Audit_Type__c,
                                    Standard_Audit_Statement_Dt__c,
                                    X_509_Certificate_PEM__c,
                                    Comments__c  
                                          from  Account
                                          where Status__c Not In ('Removed') and 
                                          Removal_Bug_No_or_Date__c <> '' and 
                                          RecordType.Name In ('Root Certificate')
                                          order by Parent.Name, Name];
                                          
       // if we are generating a CSV file then we need to replace the double quotes in all text fields with null
       if(ApexPages.currentPage().getUrl().contains('CSV') && accountSoLst !=null && accountSoLst.size() > 0)
       {
          for(Account accountSo : accountSoLst)
          {
              if(accountSo.Parent.Name !=null && accountSo.Parent.Name.length() > 0) 
                   accountSo.Parent.Name = accountSo.Parent.Name.replace('"',''); 
              if(accountSo.name !=null && accountSo.name.length() > 0) 
                   accountSo.name = accountSo.name.replace('"',''); 
              if(accountSo.Certificate_Issuer_Organization__c !=null && accountSo.Certificate_Issuer_Organization__c.length() > 0) 
                   accountSo.Certificate_Issuer_Organization__c = accountSo.Certificate_Issuer_Organization__c.replace('"','');                                        
              if(accountSo.Certificate_Issuer_Organizational_Unit__c !=null && accountSo.Certificate_Issuer_Organizational_Unit__c.length() > 0) 
                   accountSo.Certificate_Issuer_Organizational_Unit__c = accountSo.Certificate_Issuer_Organizational_Unit__c.replace('"','');  
              if(accountSo.SHA_256_Fingerprint__c !=null && accountSo.SHA_256_Fingerprint__c.length() > 0) 
                   accountSo.SHA_256_Fingerprint__c = accountSo.SHA_256_Fingerprint__c.replace('"','');                  
              if(accountSo.EV_Policy_OID_s__c !=null && accountSo.EV_Policy_OID_s__c.length() > 0) 
                   accountSo.EV_Policy_OID_s__c = accountSo.EV_Policy_OID_s__c.replace('"','');                   
              if(accountSo.Removal_Bug_No_or_Date__c !=null && accountSo.Removal_Bug_No_or_Date__c.length() > 0) 
                   accountSo.Removal_Bug_No_or_Date__c = accountSo.Removal_Bug_No_or_Date__c.replace('"','');                      
              if(accountSo.Approval_Bug__c !=null && accountSo.Approval_Bug__c.length() > 0) 
                   accountSo.Approval_Bug__c = accountSo.Approval_Bug__c.replace('"','');                                                      
              if(accountSo.NSS_Release_When_First_Included__c !=null && accountSo.NSS_Release_When_First_Included__c.length() > 0) 
                   accountSo.NSS_Release_When_First_Included__c = accountSo.NSS_Release_When_First_Included__c.replace('"','');
              if(accountSo.Firefox_Release_When_First_Included__c !=null && accountSo.Firefox_Release_When_First_Included__c.length() > 0) 
                   accountSo.Firefox_Release_When_First_Included__c = accountSo.Firefox_Release_When_First_Included__c.replace('"','');
              if(accountSo.NSS_Release_When_Removed__c !=null && accountSo.NSS_Release_When_Removed__c.length() > 0) 
                   accountSo.NSS_Release_When_Removed__c = accountSo.NSS_Release_When_Removed__c.replace('"','');
              if(accountSo.Firefox_Release_When_Removed__c !=null && accountSo.Firefox_Release_When_Removed__c.length() > 0) 
                   accountSo.Firefox_Release_When_Removed__c = accountSo.Firefox_Release_When_Removed__c.replace('"','');                    
              if(accountSo.URL_to_Test_Website_or_Example_Cert__c !=null && accountSo.URL_to_Test_Website_or_Example_Cert__c.length() > 0) 
                   accountSo.URL_to_Test_Website_or_Example_Cert__c = accountSo.URL_to_Test_Website_or_Example_Cert__c.replace('"','');                   
              if(accountSo.Mozilla_Applied_Constraints__c !=null && accountSo.Mozilla_Applied_Constraints__c.length() > 0) 
                   accountSo.Mozilla_Applied_Constraints__c = accountSo.Mozilla_Applied_Constraints__c.replace('"','');                   
              if(accountSo.Parent.Company_Website__c !=null && accountSo.Parent.Company_Website__c.length() > 0) 
                   accountSo.Parent.Company_Website__c = accountSo.Parent.Company_Website__c.replace('"','');
              if(accountSo.Parent.Geographic_Focus__c !=null && accountSo.Parent.Geographic_Focus__c.length() > 0) 
                   accountSo.Parent.Geographic_Focus__c = accountSo.Parent.Geographic_Focus__c.replace('"','');                    
              if(accountSo.Certificate_Policy_CP__c !=null && accountSo.Certificate_Policy_CP__c.length() > 0) 
                   accountSo.Certificate_Policy_CP__c = accountSo.Certificate_Policy_CP__c.replace('"','');                      
              if(accountSo.Certification_Practice_Statement_CPS__c !=null && accountSo.Certification_Practice_Statement_CPS__c.length() > 0) 
                   accountSo.Certification_Practice_Statement_CPS__c = accountSo.Certification_Practice_Statement_CPS__c.replace('"','');                    
              if(accountSo.Standard_Audit__c !=null && accountSo.Standard_Audit__c.length() > 0) 
                   accountSo.Standard_Audit__c = accountSo.Standard_Audit__c.replace('"','');
              if(accountSo.BR_Audit__c !=null && accountSo.BR_Audit__c.length() > 0) 
                   accountSo.BR_Audit__c = accountSo.BR_Audit__c.replace('"','');
              if(accountSo.EV_Audit__c !=null && accountSo.EV_Audit__c.length() > 0) 
                   accountSo.EV_Audit__c = accountSo.EV_Audit__c.replace('"','');                  
              if(accountSo.Auditor__c !=null && accountSo.Auditor__c.length() > 0) 
                   accountSo.Auditor__c = accountSo.Auditor__c.replace('"',''); 
              if(accountSo.Comments__c !=null && accountSo.Comments__c.length() > 0) 
                   accountSo.Comments__c = accountSo.Comments__c.replace('"','');               
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