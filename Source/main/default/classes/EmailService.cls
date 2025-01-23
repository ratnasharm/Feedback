public class EmailService {

    /**
     * Sends an email to a list of recipients using a specified template.
     *
     * @param whatIdandContactMapping A map to contact id with related record id where of email addresses to send the email to.
     * @param templateName The name of the Email Template to use.
     */
    public static void sendEmail(Map<Id, Id> whatIdandContactMapping,  String emailTemplateName) {
        
        List<EmailTemplate> emailTemplates = [Select Id from EmailTemplate where name =: emailTemplateName];
        
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage>();

        for(Id whatId : whatIdandContactMapping.keyset()){
            Id contactId = whatIdandContactMapping.get(whatId);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new List<Id>{contactId};
            message.setWhatId (whatId);
            message.setTemplateId(emailTemplates.get(0).Id);
            messages.add(message);
        }

        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }
}