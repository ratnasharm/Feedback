public class EmailService {

    /**
     * Sends an email to a list of recipients using a specified template.
     *
     * @param whatIdandContactMapping A map to contact id with related record id where of email addresses to send the email to.
     * @param templateName The name of the Email Template to use.
     */
    public static void sendEmail(Map<Id, Id> whatIdandContactMapping,  String emailTemplateName) {
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage>();
        Id emailTemplateId = getEmailTemplateId(emailTemplateName);

        System.debug('whatIdandContactMapping --> ' + whatIdandContactMapping);

        for(Id whatId : whatIdandContactMapping.keyset()){
            Id contactId = whatIdandContactMapping.get(whatId);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new List<Id>{contactId};
            message.setWhatId (whatId);
            message.setTemplateId(emailTemplateId);
            message.setTargetObjectId(contactId);
            messages.add(message);
            System.debug('Message --> ' + message);
        }

        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }

    private static Id getEmailTemplateId(String emailTemplateName){
        List<EmailTemplate> emailTemplates = [Select Id from EmailTemplate where name =: emailTemplateName];
        return emailTemplates.get(0).Id;
    }
}