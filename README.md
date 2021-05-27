
# Part 1: Modelling

## Object creation
I have created 1 new object as Financial Account its child object of Standard Account Object as Customer account can have multiple Finance Account.

## Master-Detail relationship
I have connected Financial Accouont & Customer Account as Master Detail relationship and Account standard object as Parent Object..

## Custom Object to store transaction history
Also, to store transaction history, i have created a custom object to store all the transaction related information coming from the external system.Trying to think abount create Big Object but on Big object Roll up summary field is not possible.

## Roll up summary field sum the amount from the child transaction records
Created roll up summary field to sum the amount of child transaction records.


# Part 2: Provisioning

## ABID generation
Created auto number field with the formatting provided in the requirement doc.I can create the Test field with 12 digit but via process builder counter was not possible. Hence as Best practise we need to use first configuration except Trigger. Else Customization trigger should be work.

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
    
   
