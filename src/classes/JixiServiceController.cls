/***************************************************************************************************
Audit Letter Validation or Jixi service allows root store managers to validate audit docuemnts. It is 
invoked from a button "Audit Letter Validation" on Audit Case page. A self signed certificate is required
to authenticate and establish the connection. 
1. Prepare a request from Case and Root Case records. Method Name: prepareRequest
2. Do a Callout. Method Name: doCallout
3. Perform Post Callout Activities. Method Name: postCallActions

***************************************************************************************************/

public class JixiServiceController{
    
    public Case caseSO {get; private set;}
    public String request{get; private set;}
    public String response{get; private set;}
    public Boolean hasErrors{get; private set;}
    public String statusText {get; private set;}
    public List<Root_Case__c> lstRootCases{get; private set;}
    public List<String> lstErrorLog {get; private set;}
    
    private Map<Integer, String> mapHttpStatusCodes;
    
    public JixiServiceController(ApexPages.StandardController stdCon){
        
        this.caseSO = getCaseRecord(stdCon.getId());
                       
        this.hasErrors = false;
        this.statusText = 'Invoking ALV Sevice...  \n';
        this.lstErrorLog = new List<String>();
        
        this.lstRootCases = new List<Root_Case__c>();
        this.lstRootCases = this.caseSO.Root_Cases__r;
        this.hasErrors = this.lstRootCases.isEmpty();
        mapHttpStatusCodes = new Map<Integer, String>();  
        mapHttpStatusCodes.put(204, 'Error Code: 204 - The server successfully processed the request and is not returning any content.');            
        mapHttpStatusCodes.put(400, 'Error Code: 400 - Bad Request');
        mapHttpStatusCodes.put(401, 'Error Code: 401 - Unauthorized Request. Authentication failed.');
        mapHttpStatusCodes.put(403, 'Error Code: 403 - Forbidden, Request is valid but Server refused action.');
        mapHttpStatusCodes.put(404, 'Error Code: 404 - The requested resource could not be found but may be available in the future.');
        mapHttpStatusCodes.put(408, 'Error Code: 408 - The server timed out waiting for the request.'); 
        mapHttpStatusCodes.put(500, 'Error Code: 500 - Internal Server Error. Unexpected condition was encountered.');
        mapHttpStatusCodes.put(501, 'Error Code: 501 - Not Implemented. The server either does not recognize the request method, or it lacks the ability to fulfill the request.');
        mapHttpStatusCodes.put(503, 'Error Code: 503 - Service Unavailable. The server is currently unavailable.');
    }
    
    /*
    * get Case Record
    */
    private Case getCaseRecord(Id caseId){
       
       return [SELECT Id, CaseNumber, Account.Name, Auditor_New__r.Name, Auditor__c, Standard_Audit_Type__c, Standard_Audit_Statement_Date__c,
       Standard_Audit_Period_Start_Date__c,Standard_Audit_Period_End_Date__c,Standard_Audit_Statement_Link__c,
       BR_Audit_Type__c,BR_Audit_Statement_Date__c,BR_Audit_Period_Start_Date__c,BR_Audit_Period_End_Date__c,
       BR_Audit_Statement_Link__c,EV_Audit_Type__c,EV_Audit_Statement_Date__c,EV_Audit_Period_Start_Date__c,
       EV_Audit_Period_End_Date__c,EV_Audit_Statement_Link__c,EV_Code_Signing_Audit_Type__c,
       EV_Code_Signing_Audit_Statement_Date__c,EV_Code_Signing_Audit_Period_Start_Date__c,
       EV_Code_Signing_Audit_Period_End_Date__c,EV_Code_Signing_Audit_Statement_Link__c,
       Standard_Audit_Auto_Review_Status__c, Standard_Audit_Auto_Review_Results__c, 
       BR_Audit_Auto_Review_Status__c, BR_Audit_Auto_Review_Results__c, EV_SSL_Audit_Auto_Review_Status__c,
       EV_SSL_Audit_Auto_Review_Results__c, EV_Code_Signing_Audit_AutoReviewStatus__c, 
       EV_Code_Signing_Audit_AutoReviewResults__c,
       (SELECT Id, Name, Included_Certificate_Name__c, Root_Certificate_Name_Existing__c, SHA_1_Fingerprint__c, SHA_256_Fingerprint__c, 
       Microsoft_Trust_Bits__c, Microsoft_EV_Enabled__c, Auto_Review_Status__c, Auto_Review_Results__c
       FROM Root_Cases__r) 
       FROM Case
       WHERE Id = :caseId];
    }
    
    /*
    * prepareRequest - prepare request JSON at the begining of page load.
    */
    public void prepareRequest(){
        
        try{
        
        //Code added by Sunil - Start
        JSONGenerator gen = JSON.createGenerator(true);
        
        //start main object
        gen.writeStartObject();
        
        gen.writeStringField('CaseRecordID', caseSO.Id);
        gen.writeStringField('CaseNumber', caseSO.CaseNumber);
        gen.writeStringField('CAOwnerName', caseSO.Account.Name);
        gen.writeStringField('Auditor', caseSO.Auditor_New__c != null ? caseSO.Auditor_New__r.Name : '');
        
        //start StandardAudit
        gen.writeFieldName('StandardAudit');
        gen.writeStartObject();
        
        gen.writeStringField('AuditType', caseSO.Standard_Audit_Type__c != null ? caseSO.Standard_Audit_Type__c : '');
        gen.writeStringField('StatementDate', caseSO.Standard_Audit_Statement_Date__c != null ? String.valueOf(caseSO.Standard_Audit_Statement_Date__c) : '');
        gen.writeStringField('AuditPeriodStart', caseSO.Standard_Audit_Period_Start_Date__c != null ? String.valueOf(caseSO.Standard_Audit_Period_Start_Date__c) : '');
        gen.writeStringField('AuditPeriodEnd', caseSO.Standard_Audit_Period_End_Date__c != null ? String.valueOf(caseSO.Standard_Audit_Period_End_Date__c) : '');
        gen.writeStringField('Link', caseSO.Standard_Audit_Statement_Link__c != null ? caseSO.Standard_Audit_Statement_Link__c : '');
        
        //end StandardAudit
        gen.writeEndObject();
        
        
        //start BRAudit
        gen.writeFieldName('BRAudit');
        gen.writeStartObject();
        
        gen.writeStringField('AuditType', caseSO.BR_Audit_Type__c != null ? caseSO.BR_Audit_Type__c : '');
        gen.writeStringField('StatementDate', caseSO.BR_Audit_Statement_Date__c != null ? String.valueOf(caseSO.BR_Audit_Statement_Date__c) : '');
        gen.writeStringField('AuditPeriodStart', caseSO.BR_Audit_Period_Start_Date__c != null ? String.valueOf(caseSO.BR_Audit_Period_Start_Date__c) : '');
        gen.writeStringField('AuditPeriodEnd', caseSO.BR_Audit_Period_End_Date__c != null ? String.valueOf(caseSO.BR_Audit_Period_End_Date__c) : '');
        gen.writeStringField('Link', caseSO.BR_Audit_Statement_Link__c != null ? caseSO.BR_Audit_Statement_Link__c : '');
        
        //end BRAudit
        gen.writeEndObject();
        
        //start EVSSL
        gen.writeFieldName('EVSSL');
        gen.writeStartObject();
        
        gen.writeStringField('AuditType', caseSO.EV_Audit_Type__c != null ? caseSO.EV_Audit_Type__c : '');
        gen.writeStringField('StatementDate', caseSO.EV_Audit_Statement_Date__c != null ? String.valueOf(caseSO.EV_Audit_Statement_Date__c) : '');
        gen.writeStringField('AuditPeriodStart', caseSO.EV_Audit_Period_Start_Date__c != null ? String.valueOf(caseSO.EV_Audit_Period_Start_Date__c) : '');
        gen.writeStringField('AuditPeriodEnd', caseSO.EV_Audit_Period_End_Date__c != null ? String.valueOf(caseSO.EV_Audit_Period_End_Date__c) : '');
        gen.writeStringField('Link', caseSO.EV_Audit_Statement_Link__c != null ? caseSO.EV_Audit_Statement_Link__c : '');
        
        //end EVSSL
        gen.writeEndObject();
        
        //start EVCodeSigning
        gen.writeFieldName('EVCodeSigning');
        gen.writeStartObject();
        
        gen.writeStringField('AuditType', caseSO.EV_Code_Signing_Audit_Type__c != null ? caseSO.EV_Code_Signing_Audit_Type__c : '');
        gen.writeStringField('StatementDate', caseSO.EV_Code_Signing_Audit_Statement_Date__c != null ? String.valueOf(caseSO.EV_Code_Signing_Audit_Statement_Date__c) : '');
        gen.writeStringField('AuditPeriodStart', caseSO.EV_Code_Signing_Audit_Period_Start_Date__c != null ? String.valueOf(caseSO.EV_Code_Signing_Audit_Period_Start_Date__c) : '');
        gen.writeStringField('AuditPeriodEnd', caseSO.EV_Code_Signing_Audit_Period_End_Date__c != null ? String.valueOf(caseSO.EV_Code_Signing_Audit_Period_End_Date__c) : '');
        gen.writeStringField('Link', caseSO.EV_Code_Signing_Audit_Statement_Link__c != null ? caseSO.EV_Code_Signing_Audit_Statement_Link__c : '');
        
        //end EVCodeSigning
        gen.writeEndObject();

        //start rootcases
        gen.writeFieldName('RootCases');
        gen.writeStartArray();
        for(Root_Case__c rootCase : caseSO.Root_Cases__r){
            //start object
            gen.writeStartObject();

            gen.writeStringField('RootCaseRecordID', rootCase.Id);
            gen.writeStringField('RootCaseNumber', rootCase.Name);
            gen.writeStringField('Name', rootCase.Included_Certificate_Name__c != null ? rootCase.Included_Certificate_Name__c : '');
            gen.writeStringField('SHA1Thumbprint', rootCase.SHA_1_Fingerprint__c != null ? rootCase.SHA_1_Fingerprint__c : '');
            gen.writeStringField('SHA256Thumbprint', rootCase.SHA_256_Fingerprint__c != null ? rootCase.SHA_256_Fingerprint__c : '');
            gen.writeStringField('MicrosoftTrustBits', rootCase.Microsoft_Trust_Bits__c != null ? rootCase.Microsoft_Trust_Bits__c : '');
            gen.writeStringField('MicrosoftEVEnabled', String.valueOf(rootCase.Microsoft_EV_Enabled__c));
            
            //end object
            gen.writeEndObject();
        }
        //end rootcases
        gen.writeEndArray();
        //gen.writeObjectField('RootCases', lstCertificates);
        
        //end main object
        gen.writeEndObject();

        //Code added by Sunil - End
        
        /*JixiServiceTokens reqObj = new JixiServiceTokens();
        
        JixiServiceTokens.JixiServiceRequest caseObj = new JixiServiceTokens.JixiServiceRequest();
        caseObj.CaseRecordID = caseSO.Id;
        caseObj.CaseNumber = caseSO.CaseNumber;//sending case number in the request
        caseObj.CAOwnerName = caseSO.Account.Name;
        caseObj.Auditor = caseSO.Auditor_New__r.Name;// send Auditor name instead of "Auditor__c"
        
        JixiServiceTokens.AuditInfo stdAudit = new JixiServiceTokens.AuditInfo();
        stdAudit.AuditType = caseSO.Standard_Audit_Type__c;
        stdAudit.StatementDate = String.valueOf(caseSO.Standard_Audit_Statement_Date__c);
        stdAudit.AuditPeriodStart = String.valueOf(caseSO.Standard_Audit_Period_Start_Date__c);
        stdAudit.AuditPeriodEnd = String.valueOf(caseSO.Standard_Audit_Period_End_Date__c);
        stdAudit.Link = caseSO.Standard_Audit_Statement_Link__c;
        
        JixiServiceTokens.AuditInfo brAudit = new JixiServiceTokens.AuditInfo();
        brAudit.AuditType = caseSO.BR_Audit_Type__c;
        brAudit.StatementDate = String.valueOf(caseSO.BR_Audit_Statement_Date__c);
        brAudit.AuditPeriodStart = String.valueOf(caseSO.BR_Audit_Period_Start_Date__c);
        brAudit.AuditPeriodEnd = String.valueOf(caseSO.BR_Audit_Period_End_Date__c);
        brAudit.Link = caseSO.BR_Audit_Statement_Link__c;
        
        JixiServiceTokens.AuditInfo evsslAudit = new JixiServiceTokens.AuditInfo();
        evsslAudit.AuditType = caseSO.EV_Audit_Type__c;
        evsslAudit.StatementDate = String.valueOf(caseSO.EV_Audit_Statement_Date__c);
        evsslAudit.AuditPeriodStart = String.valueOf(caseSO.EV_Audit_Period_Start_Date__c);
        evsslAudit.AuditPeriodEnd = String.valueOf(caseSO.EV_Audit_Period_End_Date__c);
        evsslAudit.Link = caseSO.EV_Audit_Statement_Link__c;
        
        JixiServiceTokens.AuditInfo evCodeSigningAudit = new JixiServiceTokens.AuditInfo();
        evCodeSigningAudit.AuditType = caseSO.EV_Code_Signing_Audit_Type__c;
        evCodeSigningAudit.StatementDate = String.valueOf(caseSO.EV_Code_Signing_Audit_Statement_Date__c);
        evCodeSigningAudit.AuditPeriodStart = String.valueOf(caseSO.EV_Code_Signing_Audit_Period_Start_Date__c);
        evCodeSigningAudit.AuditPeriodEnd = String.valueOf(caseSO.EV_Code_Signing_Audit_Period_End_Date__c);
        evCodeSigningAudit.Link = caseSO.EV_Code_Signing_Audit_Statement_Link__c;
        
        List<JixiServiceTokens.RootCases> lstCertificates = new List<JixiServiceTokens.RootCases>();
        for(Root_Case__c rootCase : caseSO.Root_Cases__r){
            
            JixiServiceTokens.RootCases cert = new JixiServiceTokens.RootCases();
            cert.RootCaseRecordID = rootCase.Id;
            cert.RootCaseNumber = rootCase.Name;// adding Root Case Number - 10/12
            cert.Name = rootCase.Included_Certificate_Name__c;//rootCase.Name; --> replaced 'Name' with 'Included Certificate Name' - 10/12
            cert.SHA1Thumbprint = rootCase.SHA_1_Fingerprint__c;
            cert.SHA256Thumbprint = rootCase.SHA_256_Fingerprint__c;
            cert.MicrosoftTrustBits = rootCase.Microsoft_Trust_Bits__c;
            cert.MicrosoftEVEnabled = String.valueOf(rootCase.Microsoft_EV_Enabled__c);
            lstCertificates.add(cert);
        }
        
        caseObj.StandardAudit = stdAudit;
        caseObj.BRAudit = brAudit;
        caseObj.EVSSL = evsslAudit;
        caseObj.EVCodeSigning = evCodeSigningAudit;
        caseObj.RootCases = lstCertificates;
        this.request = JSON.serialize(caseObj);*/
        
        this.request = gen.getAsString();
        
        //this.request = JSON.serialize(req);
        
        System.debug(this.request);
        
        }catch(Exception exp){
            
            this.hasErrors = true;
            this.response = exp.getMessage() + ' Please contact your administrator.';
            System.debug(exp.getStackTraceString());
            System.debug(exp.getLineNumber());
        }
        this.statusText += 'Sending HTTPS request to ALV Sevice...  \n';
    }
    
    /*
    * doCallout - do an actual callout to Jixi server
      TODO: Create a custom setting and put all integration variables there.
    */
    public void doCallout(){
        
        if(!this.hasErrors){
            
            try{
                
                /*
                String endpoint = 'https://ccadbwebapiservice.azurewebsites.net/api/CAs';
                hReq.setHeader('Content-Type', 'application/json');
                hReq.setEndpoint(endpoint);//don't forget to set remote site setting for this endpoint.
                hReq.setMethod('POST');
                hReq.setBody(this.request);
                hReq.setTimeout(120000);  // 2 minutes
                hReq.setClientCertificateName('SelfSignedCertForJixi');
                */
                
                Jixi_Integration_Tokens__c tokens = Jixi_Integration_Tokens__c.getInstance('Jixi Service Tokens');
                //system.debug(tokens);
                
                HttpRequest hReq = new HttpRequest();
                hReq.setHeader('Content-Type', 'application/json');
                hReq.setEndpoint(tokens.Service_Endpoint__c);//don't forget to set remote site setting for this endpoint.
                hReq.setMethod(tokens.HTTP_Method__c);
                hReq.setBody(this.request);
                hReq.setTimeout(Integer.valueOf(tokens.Timeout__c));
                hReq.setClientCertificateName(tokens.Client_Certification_Name__c);
                
                Http http = new Http();
                
                HttpResponse hRes = http.send(hReq);
                
                System.debug(hRes.getHeaderKeys());
                System.debug(hRes.getHeader('Location'));//if response code 201 CREATED then Jixi is returning "https://ccadbwebapiservice.azurewebsites.net/api/CAs/50063000004KUgE" in location
                System.debug(hRes.getBody());
                
                //200 OK, 201 CREATED, 202 ACCEPTED
                if(hRes != null && (hRes.getStatusCode() == 200 || hRes.getStatusCode() == 201 || hRes.getStatusCode() == 202)){
                    this.response = hRes.getBody();
                    System.debug(this.response);
                }else{
                    System.debug(hRes);
                    this.hasErrors = true;
                    this.response = mapHttpStatusCodes.containsKey(hRes.getStatusCode()) ? mapHttpStatusCodes.get(hRes.getStatusCode()) +
                     ' Please contact your administrator.' : 'Unexpected Error Occurred. Please contact your administrator.' + this.response;
                }
            }catch(Exception exp){
                System.debug(exp.getMessage());
                System.debug(exp.getStackTraceString());
                System.debug(exp.getLineNumber());
                this.hasErrors = true;
                this.response = exp.getMessage() + ' Please contact your administrator.';
            }
        }
        
        this.statusText += 'Parsing Response and updating Case & Root Case records...  \n'; //'Sending HTTPS POST to Jixi Sevice';
    }
    
    /*
    * postCallActions - Get the response string, parse and update case & root case records
    */
    public PageReference postCallActions(){
        
        //this.hasErrors = true;
        pageReference pref = null;
        if(this.hasErrors){
            return pref;
        }

        try{
            
            //if no errors so far then parse the response
            JixiServiceTokens.JixiServiceResponse result = JixiServiceTokens.parse(this.response);
            System.debug(result);
            
            //update case record
            Case caseSO = new Case(Id = result.CaseRecordID);
    
            //update std audit
            caseSO.Standard_Audit_Auto_Review_Status__c = result.StandardAudit.AutoReviewStatus;
            caseSO.Standard_Audit_Auto_Review_Results__c = result.StandardAudit.AutoReviewResults;
    
            //update br audit        
            caseSO.BR_Audit_Auto_Review_Status__c = result.BRAudit.AutoReviewStatus;
            caseSO.BR_Audit_Auto_Review_Results__c = result.BRAudit.AutoReviewResults;
            
            //update ev ssl audit
            caseSO.EV_SSL_Audit_Auto_Review_Status__c = result.EVSSLAudit.AutoReviewStatus;
            caseSO.EV_SSL_Audit_Auto_Review_Results__c = result.EVSSLAudit.AutoReviewResults;
            
            //update ev code signing
            caseSO.EV_Code_Signing_Audit_AutoReviewStatus__c = result.EVCodeSigning.AutoReviewStatus;
            caseSO.EV_Code_Signing_Audit_AutoReviewResults__c = result.EVCodeSigning.AutoReviewResults;
            
            List<String> lstErrorLog = result.ErrorLog != null ? result.ErrorLog : new List<String>();
            this.lstErrorLog = lstErrorLog;
            
            //update root cases
            List<Root_Case__c> lstRootCases = new List<Root_Case__c>();
            for(JixiServiceTokens.RootCasesResult rootCaseResult : result.RootCases){
                
                Root_Case__c rootCase = new Root_Case__c(Id = rootCaseResult.RootCaseRecordID);
                rootCase.Auto_Review_Status__c = String.valueOf(rootCaseResult.AutoReviewStatus);
                rootCase.Auto_Review_Results__c = rootCaseResult.AutoReviewResults;
                lstRootCases.add(rootCase);
            }
            
            update caseSO;
            
            if(lstRootCases.size() > 0){
                update lstRootCases;
            }
            
            pref = new PageReference('/'+caseSO.Id); //stdCon.view();
            
        }catch(Exception exp){
            System.debug(exp.getMessage());
            System.debug(exp.getStackTraceString());
            System.debug(exp.getLineNumber());
            this.hasErrors = true;
            this.response = this.response +'\n***** ERROR ****: '+exp.getMessage();
        }
        
        this.caseSO = getCaseRecord(this.caseSO.Id);
                        
        this.lstRootCases = new List<Root_Case__c>();
        
        this.lstRootCases = this.caseSO.Root_Cases__r;
                       
        return null;//change it to 'pref' then it won't wait on the screen and directly go to Case record detail page
    }
}