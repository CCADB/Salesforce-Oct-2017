// this is the controller class for the RunAuditReminderBatcForMSFTh VF page. 
public class AuditReminderBatchControllerForMSFT{

// var which holds the exception message
 public String errorText {get;set;}
 
 // method which executes the batch job
 public void startBatch()
  
  {
     errorText = ' ';
   
     Database.executeBatch(new AuditReminderBatchForMSFT(),10); 
 
  }
  
}