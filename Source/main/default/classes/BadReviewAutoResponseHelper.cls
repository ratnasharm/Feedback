public class BadReviewAutoResponseHelper {
  
  /**
   * Create new contact from feedback
   */
  public static void createContactAndFollowupActions(List<Feedback__c> feedbacks) {
    List<Contact> contacts = new List<Contact>();
    
    Map<String, Contact> existingContacts = getExistingContacts(feedbacks);

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

        existingContacts.put(feedback.Customer_Email__c, newContact);
      }
    }

    insert contacts;


    saveContactLookup(feedbacks, existingContacts);

    feedbackFollowup(feedbacks, existingContacts);
  }

  /**
   * Create new contact from feedback
   */
  public static void saveContactLookup(List<Feedback__c> feedbacks, Map<String, Contact> existingContacts) {

      List<Feedback__c> feedbacksToUpdate = new List<Feedback__c>();
      
      // Add contact lookup to each feedback record
      for(Feedback__c feedback : feedbacks){
        Id feedbackId = feedback.id;
        Id contactId = existingContacts.get(feedback.Customer_Email__c).id;

        Feedback__c feedbackToUpdate = new Feedback__c(
          id = feedbackId,
          contact__c = contactId
        );

        feedbacksToUpdate.add(feedbackToUpdate);
      }

      update feedbacksToUpdate;
  }

   /**
   * Create new follow up task so that support team can help customer
   */
  private static void feedbackFollowup(List<Feedback__c> feedbacks, Map<String, Contact> existingContacts) {
      Map<Id,Id> feedbackAndContactIdMapping = new Map<Id,Id>();

      // Add contact lookup to each feedback record
      for(Feedback__c feedback : feedbacks){
        
        // filter feedback for task creation and sending email 
        if(feedback.Rating__c <= 2){
          Id contactId = existingContacts.get(feedback.Customer_Email__c).id;
          feedbackAndContactIdMapping.put(feedback.Id, contactId);
        }
      }

      if(feedbackAndContactIdMapping.size() > 0){
        EmailService.sendEmail(feedbackAndContactIdMapping,  'Apology email');
        createTask(feedbackAndContactIdMapping);
      }
  }

  /**
   * Create new follow up task so that support team can help customer
   */
  private static void createTask(Map<Id,Id> feedbackAndContactIdMapping) {
    List<Task> tasks = new List<Task>();

    for (Id feedbackId : feedbackAndContactIdMapping.keyset()) {
      Id contactId = feedbackAndContactIdMapping.get(feedbackId);
      Task newTask = new Task(
        Subject = 'Respond to Bad feedback review',
        Status = 'Not Started', 
        Priority = 'Normal' ,
        Whatid = feedbackId,
        WhoId = contactId
      );

      tasks.add(newTask);
    }

    insert tasks;
  }

  private static Map<String, Contact> getExistingContacts( List<Feedback__c> feedbacks) {
    List<String> contactEmails = new List<String>();

    //capturing all email address from feedback records
    for (Feedback__c feedback : feedbacks) {
      contactEmails.add(feedback.Customer_Email__c);
    }
    // Map to store existing Contacty by email addresses
    Map<String, Contact> existingContacts = new Map<String, Contact>();

    // Query Contacts based on the email and store contacts in the existingContacts if found
    for (Contact contact : [ SELECT Id, email FROM Contact WHERE Email IN :contactEmails ]) {
      existingContacts.put(contact.email, contact);
    }

    return existingContacts;
  }
}
