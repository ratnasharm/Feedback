public class BadReviewAutoResponseHelper {

  /**
   * Create new contact from feedback and handle follow-up actions.
   *
   * 1) Checks for existing contacts based on customer email.
   * 2) Creates new Contact records for unique email addresses.
   * 3) Links feedback records to corresponding Contacts.
   * 4) Triggers follow-up actions is rating <= 2
   *
   */
  public static void createContactAndFollowupActions(List<Feedback__c> feedbacks) {
    
    List<Contact> contacts = new List<Contact>();

    // Fetch existing Contacts based on feedback customer emails.
    Map<String, Contact> existingContacts = getExistingContacts(feedbacks);

    for (Feedback__c feedback : feedbacks) {
      // Prevent duplication: check if the email already exists in the map.
      if (!existingContacts.containsKey(feedback.Customer_Email__c)) {
        // Parse customer name into first and last names.
        NameParser.FullName contactName = NameParser.extractNames( feedback.Customer_Name__c);

        Contact newContact = new Contact(
          FirstName = contactName.firstName,
          LastName = contactName.lastName, 
          Email = feedback.Customer_Email__c
        );

        contacts.add(newContact);

        // Add the new Contact to the map so that we can use it later
        existingContacts.put(feedback.Customer_Email__c, newContact);
      }
    }

    if (!contacts.isEmpty()) {
      insert contacts;
    }

    // Link feedback records to Contacts.
    saveContactLookup(feedbacks, existingContacts);

    // Perform follow-up actions for rating <=2 
    feedbackFollowup(feedbacks, existingContacts);
  }

  /**
   *
   * This method updates the Contact lookup field (contact__c) on each Feedback__c
   * record, ensuring the feedback is associated with the correct Contact.
   */
  public static void saveContactLookup(List<Feedback__c> feedbacks, Map<String, Contact> existingContacts) {
    
    List<Feedback__c> feedbacksToUpdate = new List<Feedback__c>();

    // Update each feedback record with the corresponding Contact ID.
    for (Feedback__c feedback : feedbacks) {
      if (existingContacts.containsKey(feedback.Customer_Email__c)) {
        Feedback__c feedbackToUpdate = new Feedback__c(
          Id = feedback.Id,
          Contact__c = existingContacts.get(feedback.Customer_Email__c).Id
        );

        feedbacksToUpdate.add(feedbackToUpdate);
      }
    }

    if (!feedbacksToUpdate.isEmpty()) {
      update feedbacksToUpdate;
    }
  }

  /**
   *
   * Sends apology emails and creates follow-up tasks for feedback records
   * with a rating of 2 or lower.
   */
  private static void feedbackFollowup(List<Feedback__c> feedbacks, Map<String, Contact> existingContacts) {
    // Map to store Feedback ID to Contact ID mappings for follow-up.
    Map<Id, Id> feedbackAndContactIdMapping = new Map<Id, Id>();

    for (Feedback__c feedback : feedbacks) {
      if (feedback.Rating__c <= 2) {
        feedbackAndContactIdMapping.put(feedback.Id, existingContacts.get(feedback.Customer_Email__c).Id);
      }
    }

    if (!feedbackAndContactIdMapping.isEmpty()) {
      // Send apology emails.
      EmailService.sendEmail(feedbackAndContactIdMapping, 'Apology email');
      
      // Create follow-up tasks.
      createTask(feedbackAndContactIdMapping);
    }
  }

  /**
   *
   * Each task is linked to both the Feedback__c record (WhatId) and the
   * Contact (WhoId) to provide context for support teams.
   *
   * @param feedbackAndContactIdMapping Map of Feedback ID to Contact ID.
   */
  private static void createTask(Map<Id, Id> feedbackAndContactIdMapping) {
    List<Task> tasks = new List<Task>();

    for (Id feedbackId : feedbackAndContactIdMapping.keySet()) {
      Task newTask = new Task(
        Subject = 'Respond to Bad Feedback Review',
        Status = 'Not Started',
        Priority = 'High', // Set priority to high for bad reviews.
        WhatId = feedbackId, // Link to the Feedback__c record.
        WhoId = feedbackAndContactIdMapping.get(feedbackId) // Link to the Contact.
      );

      tasks.add(newTask);
    }

    if (!tasks.isEmpty()) {
      insert tasks;
    }
  }

  /**
   *
   * Queries the Contact records in a map with email as key 
   */
  private static Map<String, Contact> getExistingContacts(List<Feedback__c> feedbacks) {
    // Extract unique email addresses from feedback records.
    Set<String> contactEmails = new Set<String>();
    for (Feedback__c feedback : feedbacks) {
      if (feedback.Customer_Email__c != null) {
        contactEmails.add(feedback.Customer_Email__c);
      }
    }

    // Query Contacts based on the email addresses.
    Map<String, Contact> existingContacts = new Map<String, Contact>();
    for (Contact contact : [SELECT Id, Email FROM Contact WHERE Email IN :contactEmails]) {
      existingContacts.put(contact.Email, contact);
    }

    return existingContacts;
  }
}
