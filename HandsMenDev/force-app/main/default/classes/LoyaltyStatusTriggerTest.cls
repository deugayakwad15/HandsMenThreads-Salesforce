@isTest
public class LoyaltyStatusTriggerTest {

    @TestSetup
    static void makeData() {
        Customer__c customer = new Customer__c(
            Name     = 'Test Customer',
            Email__c = 'test@handsmenthreads.com'
        );
        insert customer;
    }

    @isTest
    static void testBronzeTier() {
        Customer__c cust = [SELECT Id FROM Customer__c LIMIT 1];
        Order__c order = new Order__c(
            Customer__c     = cust.Id,
            Status__c       = 'Confirmed',
            Order_Date__c   = Date.today(),
            Total_Amount__c = 500
        );
        insert order;

        Test.startTest();
        order.Status__c = 'Delivered';
        update order;
        Test.stopTest();

        Customer__c updated = [SELECT Loyalty_Status__c FROM Customer__c WHERE Id = :cust.Id];
        System.assertEquals('Bronze', updated.Loyalty_Status__c);
    }

    @isTest
    static void testGoldTier() {
        Customer__c cust = [SELECT Id FROM Customer__c LIMIT 1];
        Order__c order = new Order__c(
            Customer__c     = cust.Id,
            Status__c       = 'Confirmed',
            Order_Date__c   = Date.today(),
            Total_Amount__c = 7500
        );
        insert order;

        Test.startTest();
        order.Status__c = 'Delivered';
        update order;
        Test.stopTest();

        Customer__c updated = [SELECT Loyalty_Status__c FROM Customer__c WHERE Id = :cust.Id];
        System.assertEquals('Gold', updated.Loyalty_Status__c);
    }

    @isTest
    static void testPlatinumTier() {
        Customer__c cust = [SELECT Id FROM Customer__c LIMIT 1];
        Order__c order = new Order__c(
            Customer__c     = cust.Id,
            Status__c       = 'Confirmed',
            Order_Date__c   = Date.today(),
            Total_Amount__c = 15000
        );
        insert order;

        Test.startTest();
        order.Status__c = 'Delivered';
        update order;
        Test.stopTest();

        Customer__c updated = [SELECT Loyalty_Status__c FROM Customer__c WHERE Id = :cust.Id];
        System.assertEquals('Platinum', updated.Loyalty_Status__c);
    }
}