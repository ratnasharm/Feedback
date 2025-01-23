@RestResource(urlMapping='/uc-feedback')
global class FeedbackREST {

    /**
     * Handles bulk insert of Feedback__c records via REST request.
     */
    @HttpPost
    global static String saveFeedback(List<Feedback__c> feedbackList) {
        List<Feedback__c> validFeedback = new List<Feedback__c>();
        List<String> errors = new List<String>();

        // Validate each record
        for (Feedback__c feedback : feedbackList) {
            if (feedback.Customer_Email__c == null) {
                // Add error message if Email__c is empty
                errors.add('Missing Email__c for - ' + feedback.Customer_Name__c);
            } else {
                validFeedback.add(feedback);
            }
        }

        // Insert valid records into Salesforce
        try {
            if (!validFeedback.isEmpty()) {
                insert validFeedback;
            }
        } catch (DmlException e) {
            // Add any DML errors to the error list
            for (Integer i = 0; i < e.getNumDml(); i++) {
                errors.add('Error inserting record: ' + e.getDmlMessage(i));
            }
        }

        // Return the result as JSON
        Map<String, Object> response = new Map<String, Object>{
            'successCount' => validFeedback.size(),
            'errorsCount' => errors.size(),
            'errors' => errors
        };
        
        return JSON.serialize(response);
    }
}
