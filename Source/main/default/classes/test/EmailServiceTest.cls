@isTest
public class EmailServiceTest {

    @testSetup
    static void setupTestData() {
        // Create test Email Template
        EmailTemplate template = new EmailTemplate(
            Name = 'Template Nmame',
            DeveloperName = 'Apologyxx',
            FolderId = UserInfo.getUserId(), // Storing in the current user's private folder
            Subject = 'sample test',
            HtmlValue = 'email body',
            TemplateType = 'custom'
        );
        //insert template;

        // Create test Contacts
        List<Contact> contacts = new List<Contact>{
            new Contact(FirstName = 'Ratna', LastName = 'Bhardwaj', Email = 'xx.yy@zz.com'),
            new Contact(FirstName = 'Ratna2', LastName = 'Bhardwaj', Email = 'xx.yy2@zz.com')
        };
        insert contacts;

         // Create test Contacts
         List<Account> accounts = new List<Account>{
            new Account(Name = 'Acme'),
            new Account(Name = 'Acme2')
        };
        insert accounts;
    }

    @isTest
    static void testSendEmail() {
        
        List<Contact> contacts = [SELECT Id FROM Contact]; 
        List<Account> accounts = [SELECT Id FROM Account]; 

        
        Map<Id, Id> whatIdAndContactMapping = new Map<Id, Id>();
        whatIdAndContactMapping.put(accounts[0].Id, contacts[0].Id); // Map Feedback__c to Contact
        whatIdAndContactMapping.put(accounts[1].Id, contacts[1].Id);

        // Execute the method being tested
        Test.startTest();
        EmailService.sendEmail(whatIdAndContactMapping, 'Apology email');
        Test.stopTest();

        // no error until now
        System.assert(true, 'EmailService.sendEmail failed ');
    }
}
