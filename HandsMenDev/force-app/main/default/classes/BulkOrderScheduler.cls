global class BulkOrderScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        // Find all confirmed bulk orders not yet processed
        List<Order__c> orders = [
            SELECT Id, Total_Amount__c, Customer__c
            FROM Order__c
            WHERE Status__c = 'Confirmed'
            AND Order_Date__c = TODAY
        ];

        List<Order__c> toUpdate = new List<Order__c>();
        for (Order__c o : orders) {
            o.Status__c = 'Shipped';
            toUpdate.add(o);
        }
        if (!toUpdate.isEmpty()) update toUpdate;

        // Update inventory for each processed order line
        List<Order_Line_Item__c> lines = [
            SELECT Id, Product__c, Quantity__c
            FROM Order_Line_Item__c
            WHERE Order__r.Status = 'Shipped'
        ];

        Map<Id, Decimal> stockDeductions = new Map<Id, Decimal>();
        for (Order_Line_Item__c line : lines) {
            Decimal qty = stockDeductions.containsKey(line.Product__c)
                ? stockDeductions.get(line.Product__c) : 0;
            stockDeductions.put(line.Product__c, qty + line.Quantity__c);
        }

        List<Product__c> productsToUpdate = new List<Product__c>();
        for (Id prodId : stockDeductions.keySet()) {
            productsToUpdate.add(new Product__c(
                Id = prodId,
                Stock__c = stockDeductions.get(prodId) * -1
            ));
        }
        if (!productsToUpdate.isEmpty()) update productsToUpdate;
    }
}