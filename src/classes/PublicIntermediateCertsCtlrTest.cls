/**

Test Case for the following Controller Extension:
PublicIntermediateCertsController

**/

@isTest 
public class PublicIntermediateCertsCtlrTest{

    static testMethod void validateTest() {
  
        Account parentAccount = getParentAccount();
        insert parentAccount;
        
        Id profile = [select id from profile Where Name ='Customer Community Plus Login User For CCADB' AND UserType = 'PowerCustomerSuccess' LIMIT 1].id;
           
        Contact con = new Contact(LastName ='testCon',AccountId = parentAccount.Id);
        insert con;  
                  
        User user = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = profile, country='United States',IsActive =true,
                ContactId = con.Id,
                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        
        system.runAs(user) {
            // create the child account - record type = Root
            Account childAccount = getChildAccount(parentAccount.id);
            childAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Root Certificate').getRecordTypeID();
            insert childAccount;
            
            Account childAccount1 = getChildAccount(childAccount.id);
            insert childAccount1;
        }
        PageReference pref = Page.PublicIntermediateCertsCSVFormat;
        Apexpages.currentpage().getparameters().put('CAOwnerName','ParentAccount');
        Test.setCurrentPage(pref);
        
        PageReference pageRef = Page.PublicIntermediateCerts;
        Apexpages.currentpage().getparameters().put('CAOwnerName','ParentAccount');
        PublicIntermediateCertsController pacrc = new PublicIntermediateCertsController();
        Apexpages.currentpage().getparameters().put('CAOwnerName','');
        PublicIntermediateCertsController pacrc1 = new PublicIntermediateCertsController();
        pacrc1.getCurrentDate();
    }
  
    public static Account getParentAccount()
    {
        Account parentAccount = new Account();
        parentAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CA Owner').getRecordTypeID();
        parentAccount.name = 'ParentAccount';
        parentAccount.type = 'Owner';
        parentAccount.status__c= 'Included';
        parentAccount.Revocation_Status__c = 'Included';
        parentAccount.phone='2128425500';
        parentAccount.website  = 'https//www.test.com';
        parentAccount.valid_From_GMT__c= date.today()+1;
        parentAccount.valid_to_GMT__c= date.today()+10;
        parentAccount.company_website__c=  'https//www.test.com';
        parentAccount.organizational_type__c=  'Organizational Type';
        parentAccount.geographic_focus__c=  'Geographic focus';
        parentAccount.primary_market_customer_base__c = 'Primary Market';
        return parentAccount;
    }
    
    
    public static Account getChildAccount(ID parentAccountId)
    {
        Account childAccount = new Account();
        childAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Intermediate Certificate').getRecordTypeID();
        childAccount.name = 'ChildAccount';
        childAccount.type = 'Root';
        
        childAccount.phone='2128425500';
        childAccount.Revocation_Status__c = 'Not Revoked';
        childAccount.website  = 'https//www.test.com';
        childAccount.valid_From_GMT__c= date.today()+1;
        childAccount.valid_to_GMT__c= date.today()+10;
        childAccount.company_website__c=  'https//www.test.com';
        childAccount.SHA_1_Fingerprint__c= '12:34:56:78:90:12:34:56:78:90:12:34:56:78:90:12:34:56:78:90';
        childAccount.parentid = parentAccountId;
        
        return childAccount;
    }

}