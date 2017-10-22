/**

Test Case for the AccountTrigger apex trigger and AccountTriggerHelper apex class

**/

@isTest 
public class AccountTriggerHelperTest{
    
    static testMethod void validateAccount() {
    
        Account acc = new Account(Name='Test Account Name223223##');
        insert acc;
            
        Contact con = new Contact(LastName = 'Contact Last Name', Email = 'testclass@userrole.com', AccountId = acc.id);
        con.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CA Contact').getRecordTypeId();
        insert con;
        
        //UserRole urole = [Select PortalType, PortalAccountId From UserRole where PortalType = 'CustomerPortal' and PortalAccountId != null limit 1];
        
        User user = new User();
        //user.UserRoleId = urole.Id;//UserInfo.getUserRoleId();//
        //user.ProfileID = [Select Id From Profile Where UserType = 'PowerCustomerSuccess' LIMIT 1].id;
        user.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus Login User For CCADB' AND UserType = 'PowerCustomerSuccess' LIMIT 1].Id;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.FirstName = 'first';
        user.LastName = 'last';
        user.Username = 'test@test1234098.com';   
        user.CommunityNickname = 'testUser09887123';
        user.Alias = 't1';
        user.Email = 'no@email.com';
        user.IsActive = true;
        user.ContactId = con.Id;
        //user.PortalRole = 'Manager';
        insert user;
        
        AccountShare aShare = new AccountShare();
        aShare.AccountAccessLevel = 'Edit';
        aShare.ContactAccessLevel = 'Edit';
        aShare.OpportunityAccessLevel = 'Edit';
        aShare.RowCause = 'Manual';
        aShare.AccountId = acc.Id;
        aShare.UserOrGroupId = user.Id;
        insert aShare;
        
        System.RunAs(user) {
        
            // create a ROOT CA
            Account rootCA = New Account();
            rootCA.recordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Root Certificate').getRecordTypeId(); 
            rootCa.name = 'testRoot';
            rootCa.parentId = acc.id;
            rootCa.X_509_Certificate_PEM__c = 'abc';
            insert rootCa;
            
            // create intermediate CA
            Account testAccount = New Account();
            testAccount.name = 'Hello';
            testAccount.recordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Intermediate Certificate').getRecordTypeId();
            testAccount.Status__c='Removed';
            testAccount.parentId = rootCA.id;
            testAccount.X_509_Certificate_PEM__c = 'abc';
            
            insert testAccount;
            testAccount.X_509_Certificate_PEM__c = 'test';
            testAccount.parentId = rootCa.id;
            update testAccount;
            
            acc.Name = 'SymantecAccount';
            update acc;
        }
        
        Account accountSo = New Account(name='SymantecAccount');
        insert accountSo;
        
        accountSo.Name = 'NameChanged';
        update accountSo;
    }
}