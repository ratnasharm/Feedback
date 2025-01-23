
/*
 * Trigger functionality: send apology email, create Contact and Task
 * for bad reviews where "Rating ≤ 2"
*/
trigger BadReviewAutoResponse on Feedback__c (after insert) {
  
  //List of Feedback where rating is ≤ 2
  List<Feedback__c> feedbacks = new List<Feedback__c> (); 
 
 
 // Loop each feedback record and capture it in the list if "Rating ≤ 2"
  for(Feedback__c eachFeedbackRecord : Trigger.new){
    if(eachFeedbackRecord.Rating__c <= 2){
      feedbacks.add(eachFeedbackRecord);
    }
  }

  if(feedbacks.size()> 0){
    
    BadReviewAutoResponseHelper.createContact(feedbacks);
    BadReviewAutoResponseHelper.sendEmail(feedbacks);
    BadReviewAutoResponseHelper.createTask(feedbacks);
  }

}