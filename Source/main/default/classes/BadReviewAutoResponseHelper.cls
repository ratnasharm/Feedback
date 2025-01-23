public class BadReviewAutoResponseHelper {
  /**
   * Send email to feedback using CustomerEmail address
   */
  public static void sendEmail(List<Feedback__c> feedbacks) {
    Map<Id,Id> feedbackAndContactIdMapping = new Map<Id,Id>();

    for (Feedback__c feedback : feedbacks) {
      feedbackAndContactIdMapping.put(feedback.id, feedback.contact__c);
    }

    EmailService.sendEmail(feedbackAndContactIdMapping,  'Apology email');
  }

  /**
   * Create new contact from feedback
   */
  public static void createContact(List<Feedback__c> feedbacks) {
    List<Contact> contacts = new List<Contact>();

    Map<String, Contact> existingContacts = getExistingContacts(feedbacks);
    Map<ID, ID> feedbackToContactMapping = new Map<ID, ID>();

    for (Feedback__c feedback : feedbacks) {
      //duplicate prevention
      if (existingContacts.containsKey(feedback.Customer_Email__c) == false) {
        NameParser.FullName contactName = NameParser.extractNames(
          feedback.Customer_Name__c
        );

        // Create a new contact record
        Contact newContact = new Contact(
          FirstName = contactName.firstName,
          LastName = contactName.firstName,
          Email = feedback.Customer_Email__c
        );

        contacts.add(newContact);
      }
    }

    insert contacts;

    // Add contact lookup to each feedback record
    for(Feedback__c feedback : feedbacks){
      feedback.contact__c = existingContacts.get(feedback.Customer_Email__c).id;
    }

    update feedbacks;
  }


  /**
   * Create new follow up task so that support team can help customer
   */
  public static void createTask(List<Feedback__c> feedbacks) {
    List<Task> tasks = new List<Task>();

    for (Feedback__c feedback : feedbacks) {
      Task newTask = new Task(
        Subject = 'Respond to Bad feedback review',
        Status = 'Not Started', 
        Priority = 'Normal' ,
        Whatid = feedback.Id
      );

      tasks.add(newTask);
    }

    insert tasks;
  }

  private static Map<String, Contact> getExistingContacts(
    List<Feedback__c> feedbacks
  ) {
    List<String> contactEmails = new List<String>();

    //capturing all email address from feedback records
    for (Feedback__c feedback : feedbacks) {
      contactEmails.add(feedback.Customer_Email__c);
    }
    // Map to store existing Contacty by email addresses
    Map<String, Contact> existingContacts = new Map<String, Contact>();

    // Query Contacts based on the email and store contacts in the existingContacts if found
    for (Contact contact : [ SELECT Id FROM Contact WHERE Email IN :contactEmails ]) {
      existingContacts.put(contact.email, contact);
    }

    return existingContacts;
  }
}
