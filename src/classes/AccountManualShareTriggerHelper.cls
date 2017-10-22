// This method replaces sharing rules from sharing settings
// This method is used to add manually share intermediate cert records for community user. 
// Community users beloning to same UserGroup can read/edit each others intermediate certs other can only read.
// It is called from trigger each time when community user inserts and updates.

public class AccountManualShareTriggerHelper {
    //New method for sharing by Sunil
    public static void ManualAccountSharing(List<Account> lstallAccounts) {
        String ICertificateRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Intermediate Certificate').getRecordTypeId();
        set<Id> setAccountIds = new set<Id>();
        boolean isCommunityUser = false;
        string strLoggedUserRoleId = '';
        string strUserGroupId = '';
        //get Parent RoleId for Portal Users
        List<User> lstUsers = new List<User>([select Id,Name,Contact.Account.Id,IsPortalEnabled,UserRoleId from User Where Id =: UserInfo.getUserId()]); 
        if(lstUsers.size() > 0 && lstUsers[0].IsPortalEnabled && lstUsers[0].UserRoleId != null) {
            isCommunityUser = true;
            strLoggedUserRoleId = lstUsers[0].UserRoleId;
        }
        // find the user group for CA Owner
        List<Group> lstCAOwnergroup = new List<Group>([SELECT Id, Name, DeveloperName, RelatedId, Type, Email FROM 
                            Group Where RelatedId =: strLoggedUserRoleId and Type =: 'Role']);
        if(lstCAOwnergroup.size() > 0) {
            strUserGroupId = lstCAOwnergroup[0].Id;
        }
        if(isCommunityUser) {
            if(string.Isnotblank(strUserGroupId)){
                // assign access level 
                List<AccountShare> lstAccountSharetoUpsert = new List<AccountShare>();
                for(Account objAccount: lstallAccounts){
                    if(objAccount.RecordTypeId == ICertificateRecordTypeId){
                        AccountShare objAccountShare = new AccountShare();
                        objAccountShare.AccountAccessLevel = 'Edit';
                        objAccountShare.ContactAccessLevel = 'Read';
                        objAccountShare.OpportunityAccessLevel = 'Read';
                        objAccountShare.CaseAccessLevel = 'Read';
                        objAccountShare.AccountId = objAccount.Id;
                        objAccountShare.UserOrGroupId = strUserGroupId;
                        lstAccountSharetoUpsert.add(objAccountShare);
                    }
                }
                
                if(lstAccountSharetoUpsert.size() > 0) {
                    upsert lstAccountSharetoUpsert;
                }
            }
        } else {
            for(Account objAccount: lstallAccounts){
                if(objAccount.RecordTypeId == ICertificateRecordTypeId){
                    // Commented by Poonam on 5/17/2017 - allow internal users to add intermediate certs until Microsoft CAs are added to the community
                    // objAccount.addError('Root Store Manager should not create intermediate cert record. Please ask CA to login as community user to create an intermediate cert.');
                }
            }
        }
    }
}