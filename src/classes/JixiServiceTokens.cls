/*
    Jixi Service Tokens is the collection of variables to prepare Request & Response JSON
*/
public class JixiServiceTokens {
    
    public JixiServiceRequest caseObj{get; set;}
    
    /************* Request JSON **************/
    public class JixiServiceRequest {
        
        public String CaseRecordID{get; set;}
        public String CaseNumber{get; set;}
        public String CAOwnerName{get; set;}
        public String Auditor{get; set;}
        
        public AuditInfo StandardAudit{get; set;}
        public AuditInfo BRAudit{get; set;}
        public AuditInfo EVSSL{get; set;}
        public AuditInfo EVCodeSigning{get; set;}
        
        public List<RootCases> RootCases{get; set;}
    }

    public class AuditInfo {
        
        public String AuditType{get; set;}
        public String StatementDate{get; set;}
        public String AuditPeriodStart{get; set;}
        public String AuditPeriodEnd{get; set;}
        public String Link{get; set;}
    }

    public class RootCases {
        
        public String RootCaseRecordID{get; set;}
        public String RootCaseNumber{get; set;}
        public String Name{get; set;}
        public String SHA1Thumbprint{get; set;}
        public String SHA256Thumbprint{get; set;}
        public String MicrosoftTrustBits{get; set;}
        public String MicrosoftEVEnabled{get; set;}
    }
    
    /************** Response JSON ****************/
    public class JixiServiceResponse {
        
        public String CaseRecordID {get; set;}
        public AuditResult StandardAudit {get; set;}
        public AuditResult BRAudit {get; set;}
        public AuditResult EVSSLAudit {get; set;}
        public AuditResult EVCodeSigning {get; set;}
        public List<RootCasesResult> RootCases {get; set;}
        public List<String> ErrorLog {get; set;}
    }
    
    public class RootCasesResult {
        
        public String RootCaseRecordID {get; set;}
        public String RootCaseNumber {get; set;}
        public String Name {get; set;}
        public String SHA1Thumbprint {get; set;}
        public String SHA256Thumbprint {get; set;}
        public Boolean AutoReviewStatus {get; set;}
        public String AutoReviewResults {get; set;}
    }
    
    public class AuditResult {
        
        public String AutoReviewStatus {get; set;}
        public String AutoReviewResults {get; set;}
    }
    
    public static JixiServiceResponse parse(String json) {
        return (JixiServiceResponse) System.JSON.deserialize(json, JixiServiceResponse.class);
    }
}