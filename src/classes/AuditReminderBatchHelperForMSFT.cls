// This is the helper class for the AuditReminderBatchForMSFT job 
// 
// Audit Reminder Logic:
// For each CA owner, create one audit reminder email for all of the root certs that they own 
// that have outdated audit statements. Attach the activity to the CA Owner Object. Also set
// one user as 'Microsoft CA Program Manager in User object'. The sender will be copied as BCC (uncomment code)
// 'Compliance BCC Email' may or may not be enabled. Ignore Root Certs which have 'Do NOT send Audit Reminder'
// checked.
//
// Org Wide Email Address is being used to set 'From' and 'Display Name' of the out going email
// 
// Choose 'Microsoft Audit Reminder'Email Templates
// To: CA Email Alias1 & CA Email Alias2
// CC: Email Contacts of type 'Primary POC' and 'POCs' of the CA Owner record
// From: Org Wide Email (support@ccadb.org) ** to avoid email failures dure to DMARC policy
// BCC: CA Program Manager email address 
// Subject: Microsoft Audit Reminder 
// 
// Email template body contains following merge fields 
// - <Root Cert Name 1> <Microsoft Audit Alert Email Text>
// - <Root Cert Name 2> <Microsoft Audit Alert Email Text>
// - <Root Cert Name 3> <Microsoft Audit Alert Email Text>
//    ...... etc
//


public class AuditReminderBatchHelperForMSFT {

 // This method iterates over a list of root accounts and processes them for audit reminder email notification
 public static void processRootAccount(List<Account> parentAccountSoLLst) {
     
     Set<Account> rootAccountSOSet;
     String templateNameStr = 'Microsoft_Audit_Reminder'; //'Microsoft Audit Reminder' - using template unique name
     String subjectStr = 'Microsoft: Audit Reminder';
     
  // iterate over each root account
   for(Account accountSO : parentAccountSoLLst)
      {
          rootAccountSOSet = new Set<Account>();
          
          for (Account rootAccountSo: [select id,  name, parentid, parent.name, Standard_Audit__c, br_Audit__c,ev_Audit__c, 
                                      Microsoft_Trust_Bits__c, Microsoft_EV_Enabled__c, Standard_Audit_Statement_Date__c,
                                      br_audit_statement_date__c,ev_audit_statement_date__c, Microsoft_Audit_Alert_Email_Text__c  
                                      from account where parentid = :accountSO.id and Type = 'Root' 
                                      and Microsoft_Status__c in ('Included','Change Requested')
                                      and Microsoft_Audit_Alert__c like 'Audit Alert%'
                                      and name != '<Fill in Cert Name>'
                                      and Microsoft_Do_NOT_Send_Audit_Reminder__c = False
                                      ])
          {
              
              // system.debug('accountSo Id = ' + accountSo.Id);
              // system.debug('rootAccount ID = ' + rootAccountSo.Id);
              // system.debug('showEVAuditInfo = ' + showEVAuditInfo);
              // system.debug('rootAccountSo.trust_Bits__c = ' + rootAccountSo.trust_Bits__c);
              // system.debug('rootAccountSo.ev_policy_oid_s__c = ' + rootAccountSo.ev_policy_oid_s__c);                                 
              // system.debug('trustBits='+rootAccountSo.trust_Bits__c.contains('Off'));
              // system.debug('days='+system.today().daysBetween(rootAccountSo.standard_audit_statement_date__c));
              
              rootAccountSOSet.add(rootAccountSo);
             
          }
          
          // create the lists which will hold the TO and CC email addresses
          List<String> toAddressesLst = new List<String>();
          List<String> ccAddressesLst = new List<String>();  
             
          // check if the email alias info is available on the parent account   
          if((accountSO.CA_Email_Alias_1__c!=null && accountSO.CA_Email_Alias_1__c.length()>0) 
             || (accountSO.CA_Email_Alias_2__c!=null && accountSO.CA_Email_Alias_2__c.length()>0))
             {            
               // system.debug('Sending email for Account ' + accountSo.Id);
             
               // if email alias info is available on the parent account then we need to send the 
               // the audit reminder email notification to these email addresses
               try {
               
                     // add email alias 1 to the list if it is not null
                     if(accountSO.CA_Email_Alias_1__c!=null && accountSO.CA_Email_Alias_1__c.length() > 0)
                       {
                           toAddressesLst.add(accountSo.CA_Email_Alias_1__c); 
                       }

                     // add email alias 2 to the list if it is not null             
                     if(accountSO.CA_Email_Alias_2__c!=null && accountSO.CA_Email_Alias_2__c.length() > 0)
                       {
                           toAddressesLst.add(accountSo.CA_Email_Alias_2__c); 
                       }                      

                } catch(Exception ex) {
                   // System.debug('Exception type caught: ' + ex.getTypeName());    
                   // System.debug('Message: ' + ex.getMessage());    
                   // System.debug('Cause: ' + ex.getCause());    // returns null
                   // System.debug('Line number: ' + ex.getLineNumber());    
                   // System.debug('Stack trace: ' + ex.getStackTraceString());    
               }
             }            
             
            // fetch the Primary POC and POC contacts from the parent account
            List<Contact> contactLst = [select id, email, Type__c from contact where account.id=:accountSO.id and (Type__c = 'Primary POC' or Type__c = 'POC')];
               
            // if such contacts exists
            if(contactLst!=null && contactLst.size()>0)
            {               
                 // iterate over each contact record and add Primary POC & POC email address is added to CC list                 
                 for(Contact contactSO: contactLst)
                 {      
                       //check for email is not null
                       if(contactSO.email != null) {
                           ccAddressesLst.add(contactSO.email);    
                       }
                 }                                        
           }        
          
          if((toAddressesLst.size()>0 || ccAddressesLst.size()>0) && rootAccountSoSet.size() > 0 )
          {
             // system.debug('Sending email to =' );
             // system.debug('rootAccountSet = ' + rootAccountSoSet);
             sendEmail(toAddressesLst, ccAddressesLst, accountSo, subjectStr, templateNameStr, 
                       rootAccountSoSet);
          }
          
      }
    
  }
    
    
// this method sends out the email to the Primary POC and POC contacts associated with the parent account
public static void sendEmail(List<String> toAddressesLst, List<String> ccAddressesLst, Account rootAccountSo,
                                 String subjectStr,String templateNameStr, Set<Account> rootAccountSoSet) {

    // create a new instance of singleEmailMessage
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
    // grab the email template
    EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where developername = :templateNameStr];
        
    // get the HTML body from the template
    String htmlBody = emailTemplate.HtmlValue;
    
    string strCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CA Audit Update Request').getRecordTypeId();
    //fill set for existing cases and root cases - Fills set of existing Root cases if there is any open cases - later we will add asterisk to those root certificates
    set<string> setSubmittedRootCases = new set<string>();
    List<Root_Case__c> lstRootCases = new List<Root_Case__c>([select Id,Root_Certificate_Name_Existing__r.Name from Root_Case__c Where 
                        Root_Certificate_Name_Existing__c in: rootAccountSoSet
                        and Case_No__r.AccountId =: rootAccountSo.Id and Case_No__r.RecordTypeId =: strCaseRecordTypeId and Case_No__r.Status =: 'Open']);
    for(Root_Case__c objRC: lstRootCases) {
        setSubmittedRootCases.add(objRC.Root_Certificate_Name_Existing__r.Name);
    }
    
    
    String bodyStr;
    
    // set the TO addresses on email 
    if(toAddressesLst!=null &toAddressesLst.size()>0)
    {
         mail.setToAddresses(toAddressesLst);
    }   
    bodyStr = 'To Addresses: ' + toAddressesLst + '\n\n';
    
    // set the CC addresses on email
    if(ccAddressesLst!=null && ccAddressesLst.size()>0)
    {
         mail.setCCAddresses(ccAddressesLst);
         bodyStr = bodyStr + 'CC Addresses: ' + ccAddressesLst + '\n\n';
    } 
    
    // set the BCC and ReplyTo address in email
    List<User> userLst = [select email,name,firstname,lastname,companyname,title,phone from user 
                           where Microsoft_CA_Program_Manager__c = True order by name];
     
    if(userLst!=null && userLst.size()>0)
    {        
         List<String> bccAddressesLst = new List<String>();
         bccAddressesLst.add(userLst[0].email);
         mail.setBccAddresses(bccAddressesLst);          
         mail.setReplyTo(userLst[0].email);      // added by Poonam        
         // mail.setSenderDisplayName(userLst[0].name);
    }  
     
    // Set the 'From' display name and email address by using Organization Wide Emails for 'Microsoft'  
    // Special Note: DMARC policy caused emails sent by Microsoft user to fail, thus changed to CCAADB Support email alias - change done by Poonam
    for(OrgWideEmailAddress orgWide : [select id, Address, DisplayName from OrgWideEmailAddress where DisplayName = 'CCADB Support']) {
        mail.setOrgWideEmailAddressId(orgWide.id); 
    }

    // set other mandatory parameters like subject, replyTo etc
    mail.setSubject(emailTemplate.subject);

    String rootAccountHTMLStr = '<ul>';
    String rootAccountPlainStr = '' ;
       
    boolean isFoundOpenCases = false;
    for(Account accountSo: rootAccountSoSet)
    {            
       if(!isFoundOpenCases && setSubmittedRootCases.contains(accountSo.name)) isFoundOpenCases = true; 
       // rootAccountHTMLStr  =  rootAccountHTMLStr + '<li>' +  accountSo.name + '</li><br/>' ;     
       // rootAccountPlainStr = (rootAccountPlainStr!=null & rootAccountPlainStr.length()>0)?  rootAccountPlainStr + '- ' + accountSo.name + '\n' : '- ' + accountSo.name + '\n';
     
      rootAccountHTMLStr  =  rootAccountHTMLStr + '<li>' +  accountSo.Microsoft_Audit_Alert_Email_Text__c + (setSubmittedRootCases.contains(accountSo.name) ? '<br/><b>** Audit Case in the Common CA Database is under review for this root certificate.</b>' : '') + '</li><br/>' ;
      rootAccountPlainStr = (rootAccountPlainStr != null & rootAccountPlainStr.length()>0 ) 
              ? rootAccountPlainStr + ('\n' + accountSo.Microsoft_Audit_Alert_Email_Text__c + (setSubmittedRootCases.contains(accountSo.name) ? '\n** Audit Case in the Common CA Database is under review for this root certificate.' : '') + '\n') 
              : '\n' + accountSo.Microsoft_Audit_Alert_Email_Text__c + (setSubmittedRootCases.contains(accountSo.name) ? '\n** Audit Case in the Common CA Database is under review for this root certificate.' : '') + '\n';
    }

    if(rootAccountHTMLStr.length()> 3)
    {
        rootAccountHTMLStr += '</ul>';
    }
    
    //if(isFoundOpenCases) {
    //    rootAccountHTMLStr  += '<br/>** Audit Case in the Common CA Database is under review for this root certificate.<br/><br/>';
    //    rootAccountPlainStr += '\n\n** Audit Case in the Common CA Database is under review for this root certificate.\n';
    //} 
   
     // if the HTML body is not null, provide values for all the merge fields in the template
    if(htmlBody!=null && htmlBody.length() > 0)
    {
        
        if(userLst!=null && userLst.size()>0)
        {
          htmlBody = htmlBody.replace('{!User.FirstName}', userLst[0].FirstName == null ? ' ' : userLst[0].FirstName);
          htmlBody = htmlBody.replace('{!User.LastName}', userLst[0].LastName == null ? ' ' : userLst[0].LastName);
          htmlBody = htmlBody.replace('{!User.Title}', userLst[0].Title   == null ? ' ' : userLst[0].Title);
          htmlBody = htmlBody.replace('{!User.CompanyName}', userLst[0].CompanyName  == null ? ' ' : userLst[0].CompanyName);         
          // htmlBody = htmlBody.replace('{!User.Phone}', userLst[0].phone  == null ? ' ' : userLst[0].phone);           
        }
        
         htmlBody = htmlBody.replace('{!RootCertificateList}', rootAccountHTMLStr );
     
         mail.setHtmlBody(htmlBody);
    }
    
    // get the plan text body from the template
    String plainBody = emailTemplate.Body;
    
    // if the plain text body is not null, provide values for all the merge fields in the template
    if(plainBody!=null && plainBody.length() > 0)
     {
        plainBody = plainBody.replace('{!RootCertificateList}', rootAccountPlainStr);

       if(userLst!=null && userLst.size()>0)
        {
          plainBody = plainBody.replace('{!User.FirstName}', userLst[0].FirstName == null ? ' ' : userLst[0].FirstName);
          plainBody = plainBody.replace('{!User.LastName}', userLst[0].LastName == null ? ' ' : userLst[0].LastName);
          plainBody = plainBody.replace('{!User.Title}', userLst[0].Title   == null ? ' ' : userLst[0].Title);
          plainBody = plainBody.replace('{!User.CompanyName}', userLst[0].CompanyName  == null ? ' ' : userLst[0].CompanyName);         
          // plainBody = plainBody.replace('{!User.Phone}', userLst[0].phone  == null ? ' ' : userLst[0].phone);
        }
        plainBody = plainBody.replace('<br/>','\n');
        plainBody = plainBody.replace('<ul>',' ');
        plainBody = plainBody.replace('</ul>',' ');
        plainBody = plainBody.replace('<li>',' ');
        plainBody = plainBody.replace('</li>',' ');     
 
       mail.setPlainTextBody(plainBody);    
     }
  
    
    // send out the email
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    
    // create a task record for the sent email so that it shows up 
    // on the related list for the corresponding root account
    
    createTask(mail.getSubject(),bodyStr + mail.getPlainTextBody(),userLst != null && userLst.size() > 0 ? userLst[0].Id : UserInfo.getUserId(),rootAccountSo.id);
    
    }
    
    
    // this method creates the task that would be associated with the corresponding root account
    // this lets the users know that an email was sent out for the root account
    
    public static void createTask(String subject, String mailBody, String userId, String accountId){
            
        Task taskSo = new Task();
        taskSo.subject = subject;
        if(mailBody != null && mailBody.contains('<br>')){
            mailBody = mailBody.replaceAll('<br>', '\n');
        }
        taskSo.Description = mailBody; 
        taskSo.status = 'Completed';
        taskSo.OwnerId = userId; //user id        
        taskSo.WhatId = accountId; //record id
    
        insert taskSo; 
        
    }
}