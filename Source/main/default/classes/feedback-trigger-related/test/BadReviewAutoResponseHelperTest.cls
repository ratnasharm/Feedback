@isTest
public class BadReviewAutoResponseHelperTest {

    //Creatign testing data that will be used in the testing 
    @testSetup  
    static void setupTestData() {

        Contact contact = new Contact(FirstName = 'RAtna', LastName = 'Bhardwaj', Email = 'dd.dd@rr.com');
        insert contact;
    }

    @isTest
    static void testCreateContactAndFollowupActions() {
        
        //GIVEN = There two Feedbacks
        List<Feedback__c> feedbacks = new List<Feedback__c>{
            new Feedback__c(Customer_Name__c = 'Mr X', Customer_Email__c = 'abc@ss.com', Rating__c = 1),
            new Feedback__c(Customer_Name__c = 'RAtna Bhardwaj', Customer_Email__c = 'dd.dd@rr.com', Rating__c = 3) // Existing Contact
        };


        Test.startTest();
        
        // WHEN = I am saving both Feedback records
        insert feedbacks;
        
        Test.stopTest();


        // THEN -- 
        // Verify 2 Feedback should be created  
        List<Feedback__c> feedbacks2 = [SELECT Id FROM Feedback__c];
        System.assertEquals(2, feedbacks2.size(), 'Expecting 2 feedbacks');

        // Verify 2 contacts should be created  
        List<Contact> contacts = [SELECT Id FROM Contact];
        System.assertEquals(2, contacts.size(), 'expecting two contacts');

        // Verify 2 contacts should be created ś
        List<Task> tasks = [SELECT Id, Subject ,Status,Priority ,WhatId ,WhoId  FROM Task where subject = 'Respond to Bad Feedback Review'];
        System.debug('task query' + tasks);
        System.assertEquals(1, tasks.size(), 'expecting only one task for Customer_Name__c RAtna Bhardwaj');
        
    }
}
