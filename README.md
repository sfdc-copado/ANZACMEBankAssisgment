
# Part 1: Modelling

## RecordType creation
I have created two record types to Store customer Account and Financial account

## Junction Object to relate both type accounts
As in the second point it says All Customers can have Financial Accounts, So i have created on junction object Account relationsip to relate both type accounts.

## Custom Object to store transaction history
Also, to store transaction history, i have created a custom object to store all the transaction related information coming from the external system.

## Roll up summary field sum the amount from the child transaction records
Created roll up summary field to sum the amount of child transaction records.


# Part 2: Provisioning

## ABID generation
Created auto number field with the formatting provided in the requirement doc.

## Pubish customer account detalils on creation
Created a platform event object and process builder to publish it.
![image](https://user-images.githubusercontent.com/18612751/92447370-78430e80-f1fa-11ea-9cf6-ea0a57b53145.png)



# Part 3: Receiving Transactions

- Created ACM_TransactionWebService class to get input from External system.
- I have updated the JSON structure to accept list of input so that it can accept multiple records at a time.
- Also, please note as type,time,date are system data types so we can not use the in the wrapper class.
- So the updated JSON can be as below.

![image](https://user-images.githubusercontent.com/18612751/92448960-b0e3e780-f1fc-11ea-98a4-50f60b879e69.png)

### Updated Sample JSON format for bulk records:

[
   {
      "abid":"ACM 123 456 789",
      "accountNumber":1231,
      "amount":125.68,
      "currency":"AUD",
      "dateInput":"2020/01/01",
      "merchantABN":123456789,
      "merchantBSB":123456,
      "merchantName":"Beau Flowers",
      "timeInput":"17:32:25",
      "typeInput":"credit"
   },
    {
      "abid":"ACM 123 456 789",
      "accountNumber":1232,
      "amount":125.68,
      "currency":"AUD",
      "dateInput":"2020/01/01",
      "merchantABN":123456789,
      "merchantBSB":123456,
      "merchantName":"Beau Flowers",
      "timeInput":"17:32:25",
      "typeInput":"credit"
   }
   
]

### Updated Sample JSON format for single record:

[{
      "abid":"ACM 123 456 789",
      "accountNumber":1232,
      "amount":125.68,
      "currency":"AUD",
      "dateInput":"2020/01/01",
      "merchantABN":123456789,
      "merchantBSB":123456,
      "merchantName":"Beau Flowers",
      "timeInput":"17:32:25",
      "typeInput":"credit"
   }
   
]
    
   
