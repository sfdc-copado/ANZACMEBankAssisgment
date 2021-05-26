@RestResource(urlMapping='/Transaction/ACM_Transaction')
global with sharing class ACM_TransactionWebService {
    @HttpPost
    global static Boolean createTransactionHistoryRecord() {
        try{
            String jsonString = RestContext.request.requestBody.toString();
            List<TransactionWrapper> tranWrap = new List<TransactionWrapper>();
            tranWrap = (List<TransactionWrapper>) System.JSON.deserialize(jsonString, List<TransactionWrapper>.class);
            Boolean isSuccess = processInput(tranWrap);
            return isSuccess;
        }catch(exception e){
            System.debug('Exception ' + e);
        }
        return false;
    }
    
    private static Boolean processInput( List<TransactionWrapper> tranWrapList){
        Set<String> accountNumberList = new Set<String>();
        Map<String,Id> accountNumberMap = new  Map<String,Id>();
        List<Account> financialAccountList = new   List<Account>();
        
        List<Transaction_History__c> transactionHistoryList = new List<Transaction_History__c>();
        if(tranWrapList != null && !tranWrapList.isEmpty()){
            System.debug('tranWrapList ' + tranWrapList);
            for(TransactionWrapper trans: tranWrapList ){
                accountNumberList.add(String.valueOf(trans.accountNumber));
            }
        }
        if(accountNumberList != null && !accountNumberList.isEmpty()){
            financialAccountList = [SELECT Id,AccountNumber from Account WHERE AccountNumber IN:accountNumberList ];
            System.debug('financialAccounts ' + financialAccountList);
        }
        if(financialAccountList != null && !financialAccountList.isEmpty()){
            for(Account acc: financialAccountList){
                if(!accountNumberMap.containsKey(acc.accountNumber)){
                    accountNumberMap.put(acc.accountNumber, acc.Id);
                }
            }
        }
        
        for(TransactionWrapper tranWrap : tranWrapList){
            if(accountNumberMap.containsKey(String.valueof(tranWrap.accountNumber))){
                Transaction_History__c transactionHistory = new Transaction_History__c();
                transactionHistory.merchantABN__c = String.valueOf(tranWrap.merchantABN);
                transactionHistory.merchantBSB__c = String.valueOf(tranWrap.merchantBSB);
                transactionHistory.merchantName__c = String.valueOf(tranWrap.merchantName);
                transactionHistory.Type__c = tranWrap.typeInput;
                transactionHistory.Financial_Account__c = accountNumberMap.get(String.valueof(tranWrap.accountNumber));
                transactionHistory.Transaction_Time__c = covertStringToTime(tranWrap.timeInput);
                transactionHistory.Transaction_Date__c = covertStringToDate(tranWrap.dateInput);
                
                if(tranWrap.typeInput.equalsIgnoreCase('debit')){
                    transactionHistory.Amount__c = -tranWrap.amount;
                }else if(tranWrap.typeInput.equalsIgnoreCase('credit')){
                    transactionHistory.Amount__c = tranWrap.amount;
                }
                transactionHistoryList.add(transactionHistory);
            }
            
        }
        System.debug('transactionHistoryList ' + transactionHistoryList);
        if(transactionHistoryList != null && !transactionHistoryList.isEmpty()){
            Database.SaveResult[] dbSaveResult = Database.insert(transactionHistoryList,false);     
            if(dbSaveResult.size() == transactionHistoryList.size()){
                return true;
            }
        }
        return false;
    }
    private static time covertStringToTime(String inputString){
        List<String> strTimeSplit = new  List<String>();
        strTimeSplit = inputString.split(':');
        Time timeChange = Time.newInstance( Integer.valueOf(strTimeSplit[0]) //hour
                                           ,Integer.valueOf(strTimeSplit[1]) //min
                                           ,0                                //sec
                                           ,0); 
        return timeChange;
    }
    private static Date covertStringToDate(String inputString){
        list<String> lstSplitDate = inputString.split('/');
        Date convertedDate = date.newinstance(Integer.valueOf(lstSplitDate[0]), Integer.valueOf(lstSplitDate[1]), Integer.valueOf(lstSplitDate[2]));
        return convertedDate;
    }
    
    
    class TransactionWrapper{
        public String abid {get;set;} 
        public Integer accountNumber {get;set;} 
        public Double amount {get;set;} 
        public String currencyType {get;set;} 
        public String dateInput {get;set;} 
        public Integer merchantABN {get;set;} 
        public Integer merchantBSB {get;set;} 
        public String merchantName {get;set;} 
        public String timeInput {get;set;} 
        public String typeInput {get;set;}
    }
}