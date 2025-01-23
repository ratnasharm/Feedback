
/*
 * Trigger functionality: send apology email, create Contact and Task
 * for bad reviews where "Rating ≤ 2"
*/
trigger BadReviewAutoResponse on Feedback__c (after insert) {

  BadReviewAutoResponseHelper.createContactAndFollowupActions(Trigger.new);
}