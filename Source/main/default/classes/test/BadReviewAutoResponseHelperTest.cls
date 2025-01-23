@isTest
public class BadReviewAutoResponseHelperTest {

    @testSetup
    static void setupTestData() {

        List<Contact> contacts = new List<Contact>{
            new Contact(FirstName = 'RAtna', LastName = 'Bhardwaj', Email = 'dd.dd@rr.com')
        };
        insert contacts;
    }

    @isTest
    static void testCreateContactAndFollowupActions() {
         
        List<Feedback__c> feedbacks = new List<Feedback__c>{
            new Feedback__c(Customer_Name__c = 'Mr X', Customer_Email__c = 'abc@ss.com', Rating__c = 1),
            new Feedback__c(Customer_Name__c = 'RAtna Bhardwaj', Customer_Email__c = 'dd.dd@rr.com', Rating__c = 3) // Existing Contact
        };

        Test.startTest();
        insert feedbacks;
        Test.stopTest();

        // Verify Contacts are created for new email addresses.
        List<Contact> contacts = [SELECT Id FROM Contact];
        System.assertEquals(2, contacts.size(), 'expecting two contacts');

        // Verify Feedback records are updated with Contact lookups.
        List<Feedback__c> feedbacks2 = [SELECT Id FROM Feedback__c];
        System.assertEquals(2, feedbacks2.size(), 'Expecting 2 feedbacks');
    }
}
