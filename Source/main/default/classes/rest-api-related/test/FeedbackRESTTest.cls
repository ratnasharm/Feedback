@isTest
public class FeedbackRESTTest {
    
    @isTest
    static void testSaveFeedback() {
        // Mock input data
        List<Feedback__c> feedbackList = new List<Feedback__c>{
            new Feedback__c(Customer_Name__c = 'Mr X', Customer_Email__c = 'abc@ss.com', Rating__c = 1),
            new Feedback__c(Customer_Name__c = 'RAtna Bhardwaj', Customer_Email__c = 'dd.dd@rr.com', Rating__c = 3) // Existing Contact
        };

        Test.startTest();
        // Call the REST method
        String result = FeedbackREST.saveFeedback(feedbackList);
        Test.stopTest();

        // Deserialize the response
        Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(result);

        // Assertions
        System.assertEquals(2, response.get('successCount'), 'Two Feedback records should be there ');
    }

    @isTest
    static void testSaveFeedback_negative_withoutEmail() {
        // Mock input data
        List<Feedback__c> feedbackList = new List<Feedback__c>{
            new Feedback__c(Customer_Name__c = 'Mr X', Rating__c = 1),
            new Feedback__c(Customer_Name__c = 'RAtna Bhardwaj', Rating__c = 3) // Existing Contact
        };

        Test.startTest();
        // Call the REST method
        String result = FeedbackREST.saveFeedback(feedbackList);
        Test.stopTest();

        // Deserialize the response
        Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(result);

        // Assertions
        System.assertEquals(2, response.get('errorsCount'), 'Two records should be there ');
    }
}
