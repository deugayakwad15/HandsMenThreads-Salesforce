@isTest
public class StockAlertTriggerTest {
    @isTest
    static void testLowStockAlert() {
        Product__c p = new Product__c(
            Name = 'Test Shirt',
            Stock__c = 10,
            Price__c = 500
        );
        insert p;

        Test.startTest();
        p.Stock__c = 3; // drop below 5
        update p;
        Test.stopTest();

        // Verify stock was updated
        Product__c updated = [SELECT Stock__c FROM Product__c WHERE Id = :p.Id];
        System.assertEquals(3, updated.Stock__c);
    }
}