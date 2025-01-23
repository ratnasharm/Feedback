public class EmailService {

    /**
     * Sends emails to a list of recipients using a specified template.
     *
     * 
     * Best Practices Implemented:
     * - Bulk processing: Emails are processed in a single batch so that we will avoid hitting governor limits
     *
     * @param whatIdandContactMapping
     * @param emailTemplateName 
     */
    public static void sendEmail(Map<Id, Id> whatIdandContactMapping, String emailTemplateName) {
        
        // Retrieve the email template ID based on the given name.
        Id emailTemplateId = getEmailTemplateId(emailTemplateName);
        
        // Prepare a list of email messages to be sent in bulk.
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();

        System.debug('--> ' + whatIdandContactMapping);

        // Iterate through the map and construct email messages.
        for (Id whatId : whatIdandContactMapping.keySet()) {
            Id contactId = whatIdandContactMapping.get(whatId);

            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            
            message.setTargetObjectId(contactId); // Contact receiving the email.
            message.setWhatId(whatId); // related to the email.
            message.setTemplateId(emailTemplateId);

            messages.add(message);
        }

    }

    /**
     * Retrieves the Id of an Email Template by its name.
     */
    private static Id getEmailTemplateId(String emailTemplateName) {
        
        // Query the Email Template by name.
        List<EmailTemplate> emailTemplates = [ SELECT Id FROM EmailTemplate WHERE Name = :emailTemplateName LIMIT 1 ];
        return emailTemplates[0].Id;
    }
}
