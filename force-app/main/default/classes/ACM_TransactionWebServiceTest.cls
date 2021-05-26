@isTest
private class ACM_TransactionWebServiceTest {
    @testSetup
    private static void setup(){
        Id recordTypeIdFinance = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Financial Account').getRecordTypeId();
        List<Account> lstAccount = new  List<Account>();
        for(Integer i=0;i<2;i++) {
            lstAccount.add(new Account(Name = 'TestAcct'+i, recordTypeId=recordTypeIdFinance,accountNumber= '123'+i));
        }
        insert lstAccount;
    }
    
    @isTest
    private static void invokeTranactionWebServicetestDebit(){
        //Given
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Transaction/ACM_Transaction';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        RestContext.request = req;
        RestContext.response= res;
        
        Map<String, String> headers = RestContext.request.headers;
        
        headers.put('Content-Type', 'application/json');
        RestContext.request.requestBody = Blob.valueOf('[{"abid":"ACM 123 456 789","accountNumber":1231,"amount":125.68,"currency":"AUD","dateInput":"2020/01/01","merchantABN":123456789,"merchantBSB":123456,"merchantName":"Beau Flowers","timeInput":"17:32:25","typeInput":"debit"}]');
        
        //When
        Test.startTest();
        Boolean isSuccess = ACM_TransactionWebService.createTransactionHistoryRecord();
        Test.stopTest();
        
        //Then
        Transaction_History__c tranHistory = [SELECT id,Amount__c from Transaction_History__c LIMIT 1];
        System.assert(true,isSuccess);
        System.assertEquals(-125.68, tranHistory.Amount__c);
        
    }
    @isTest
    private static void invokeTranactionWebServicetestCredit(){
        //Given
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Transaction/ACM_Transaction';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        RestContext.request = req;
        RestContext.response= res;
        
        Map<String, String> headers = RestContext.request.headers;
        
        headers.put('Content-Type', 'application/json');
        RestContext.request.requestBody = Blob.valueOf('[{"abid":"ACM 123 456 789","accountNumber":1231,"amount":126.68,"currency":"AUD","dateInput":"2020/01/01","merchantABN":123456789,"merchantBSB":123456,"merchantName":"Beau Flowers","timeInput":"17:32:25","typeInput":"credit"}]');
        //When
        Test.startTest();
        Boolean isSuccess = ACM_TransactionWebService.createTransactionHistoryRecord();
        Test.stopTest();
        
        //Then
        Transaction_History__c tranHistory = [SELECT id,Amount__c from Transaction_History__c LIMIT 1];
        System.assert(true,isSuccess);
        System.assertEquals(126.68, tranHistory.Amount__c);
        
    }
}