public class UpcomingRootInclusionsReportController{

 public List<Root_case__c> rootCaseSoLst {get;set;}
 
  // constructor method for standard controller
    public UpcomingRootInclusionsReportController() {   
                                          
           rootCaseSoLst =  [select Case_No__r.Account.name,
                                    RecordType.Name,
                                    O_From_Issuer_Field__c,
                                    OU_From_Issuer_Field__c,
                                    Root_Certificate_Name__c,
                                    Request_Status__c,
                                    Root_Certificate_Download_URL__c,
                                    SHA_1_Fingerprint__c,
                                    Valid_From_YYYY_MMM_DD__c,
                                    Valid_To_YYYY_MMM_DD__c,
                                    Public_Key_Algorithm__c,
                                    Signature_Hash_Algorithm__c,
                                    Trust_Bits__c,
                                    EV_Policy_OID_s__c, 
                                    Case_No__r.Link_to_Bugzilla_Bug__c,
                                    Test_Website_URL_SSL_or_Example_Cert__c,
                                    Mozilla_Applied_Constraints__c, 
                                    Case_No__r.Company_Website__c,
                                    Case_No__r.Geographic_Focus__c, 
                                    CA_Document_Repository__c,
                                    CP__c, 
                                    CPS__c , 
                                    Standard_Audit__c,
                                    BR_Audit__c, 
                                    EV_Audit__c, 
                                    Auditor_Name__c    ,
                                    Standard_Audit_Type__c, 
                                    Standard_Audit_Statement_Dt__c , 
                                    Publicly_Disclosed_and_Audited_subCAs__c 
                                          from  Root_Case__c
                                          where RecordType.Name = 'CA Owner/Root Inclusion Request' and 
                                          Case_No__r.Status != 'Closed'  and 
                                          Request_Status__c in ('Approved, Pending Inclusion','Approved, Pending Inclusion and EV')
                                          order by Case_No__r.Account.name, Root_Certificate_Name__c];
                                          
      // if we are generating a CSV file then we need to replace the double quotes in all text fields with null
       if(ApexPages.currentPage().getUrl().contains('CSV') && rootCaseSoLst !=null && rootCaseSoLst.size() > 0)
       {
          for(Root_Case__c rootCaseSo : rootCaseSoLst)
          {
              if(rootCaseSo.Case_No__r.Account.name !=null && rootCaseSo.Case_No__r.Account.name.length() > 0) 
                   rootCaseSo.Case_No__r.Account.name = rootCaseSo.Case_No__r.Account.name.replace('"',''); 
              if(rootCaseSo.O_From_Issuer_Field__c !=null && rootCaseSo.O_From_Issuer_Field__c.length() > 0) 
                   rootCaseSo.O_From_Issuer_Field__c = rootCaseSo.O_From_Issuer_Field__c.replace('"','');                      
              if(rootCaseSo.OU_From_Issuer_Field__c !=null && rootCaseSo.OU_From_Issuer_Field__c.length() > 0) 
                   rootCaseSo.OU_From_Issuer_Field__c = rootCaseSo.OU_From_Issuer_Field__c.replace('"','');  
              if(rootCaseSo.Root_Certificate_Name__c !=null && rootCaseSo.Root_Certificate_Name__c.length() > 0) 
                   rootCaseSo.Root_Certificate_Name__c = rootCaseSo.Root_Certificate_Name__c.replace('"','');
              if(rootCaseSo.Root_Certificate_Download_URL__c !=null && rootCaseSo.Root_Certificate_Download_URL__c.length() > 0) 
                   rootCaseSo.Root_Certificate_Download_URL__c = rootCaseSo.Root_Certificate_Download_URL__c.replace('"',''); 
              if(rootCaseSo.SHA_1_Fingerprint__c !=null && rootCaseSo.SHA_1_Fingerprint__c.length() > 0) 
                   rootCaseSo.SHA_1_Fingerprint__c = rootCaseSo.SHA_1_Fingerprint__c.replace('"','');
              if(rootCaseSo.EV_Policy_OID_s__c !=null && rootCaseSo.EV_Policy_OID_s__c.length() > 0) 
                   rootCaseSo.EV_Policy_OID_s__c = rootCaseSo.EV_Policy_OID_s__c.replace('"',''); 
              if(rootCaseSo.Case_No__r.Link_to_Bugzilla_Bug__c !=null && rootCaseSo.Case_No__r.Link_to_Bugzilla_Bug__c.length() > 0) 
                   rootCaseSo.Case_No__r.Link_to_Bugzilla_Bug__c = rootCaseSo.Case_No__r.Link_to_Bugzilla_Bug__c.replace('"','');     
              if(rootCaseSo.Test_Website_URL_SSL_or_Example_Cert__c !=null && rootCaseSo.Test_Website_URL_SSL_or_Example_Cert__c.length() > 0) 
                   rootCaseSo.Test_Website_URL_SSL_or_Example_Cert__c = rootCaseSo.Test_Website_URL_SSL_or_Example_Cert__c.replace('"','');
              if(rootCaseSo.Mozilla_Applied_Constraints__c !=null && rootCaseSo.Mozilla_Applied_Constraints__c.length() > 0) 
                   rootCaseSo.Mozilla_Applied_Constraints__c = rootCaseSo.Mozilla_Applied_Constraints__c.replace('"','');
              if(rootCaseSo.Case_No__r.Company_Website__c !=null && rootCaseSo.Case_No__r.Company_Website__c.length() > 0) 
                   rootCaseSo.Case_No__r.Company_Website__c = rootCaseSo.Case_No__r.Company_Website__c.replace('"','');
              if(rootCaseSo.Case_No__r.Geographic_Focus__c !=null && rootCaseSo.Case_No__r.Geographic_Focus__c.length() > 0) 
                   rootCaseSo.Case_No__r.Geographic_Focus__c = rootCaseSo.Case_No__r.Geographic_Focus__c.replace('"','');  
              if(rootCaseSo.CA_Document_Repository__c !=null && rootCaseSo.CA_Document_Repository__c.length() > 0) 
                   rootCaseSo.CA_Document_Repository__c = rootCaseSo.CA_Document_Repository__c.replace('"','');  
              if(rootCaseSo.CP__c !=null && rootCaseSo.CP__c.length() > 0) 
                   rootCaseSo.CP__c = rootCaseSo.CP__c.replace('"','');
              if(rootCaseSo.CPS__c !=null && rootCaseSo.CPS__c.length() > 0) 
                   rootCaseSo.CPS__c = rootCaseSo.CPS__c.replace('"','');
              if(rootCaseSo.Standard_Audit__c !=null && rootCaseSo.Standard_Audit__c.length() > 0) 
                   rootCaseSo.Standard_Audit__c = rootCaseSo.Standard_Audit__c.replace('"','');
              if(rootCaseSo.BR_Audit__c !=null && rootCaseSo.BR_Audit__c.length() > 0) 
                   rootCaseSo.BR_Audit__c = rootCaseSo.BR_Audit__c.replace('"','');
              if(rootCaseSo.EV_Audit__c !=null && rootCaseSo.EV_Audit__c.length() > 0) 
                   rootCaseSo.EV_Audit__c = rootCaseSo.EV_Audit__c.replace('"','');
              if(rootCaseSo.Auditor_Name__c !=null && rootCaseSo.Auditor_Name__c.length() > 0) 
                   rootCaseSo.Auditor_Name__c = rootCaseSo.Auditor_Name__c.replace('"',''); 
              if(rootCaseSo.Publicly_Disclosed_and_Audited_subCAs__c !=null && rootCaseSo.Publicly_Disclosed_and_Audited_subCAs__c.length() > 0) 
                   rootCaseSo.Publicly_Disclosed_and_Audited_subCAs__c = rootCaseSo.Publicly_Disclosed_and_Audited_subCAs__c.replace('"','');               
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