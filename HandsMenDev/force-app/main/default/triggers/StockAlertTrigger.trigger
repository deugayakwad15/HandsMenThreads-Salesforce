trigger StockAlertTrigger on Product__c (after update) {
    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

    for (Product__c p : Trigger.new) {
        Product__c old = Trigger.oldMap.get(p.Id);
        // Only alert if stock just dropped below 5
        if (p.Stock__c < 5 && old.Stock__c >= 5) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{'warehouse@handsmenthreads.com'});
            mail.setSubject('⚠️ Low Stock Alert: ' + p.Name);
            mail.setPlainTextBody(
                'Product: ' + p.Name + '\n' +
                'Current Stock: ' + p.Stock__c + ' units\n' +
                'Please restock immediately.'
            );
            emails.add(mail);
        }
    }
    if (!emails.isEmpty()) Messaging.sendEmail(emails);
}