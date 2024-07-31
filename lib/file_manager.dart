import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:finance_tracker/model/tag.dart';
import 'package:finance_tracker/model/transaction.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {

  //Reading of the mobile device path
    Future<String> get directoryPath async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  //Setting the file for transactions
  Future<File> get getFileTransaction async{
    final path = await directoryPath;
    return File('$path/transactionList.json');
  }

  //Setting the file for repeating Transaction
  Future<File> get getFileRepTransaction async{
    final path = await directoryPath;
    return File('$path/repTransactionList.json');
  }

  //Setting the file for tags
  Future<File> get getFileTag async{
    final path = await directoryPath;
    return File('$path/tagList.json');
  }

  //----------------------------------------------------------  TRANSACTIONS ----------------------------------------------------------//


  //trying to read the transaction data and decodes them
  Future readFileTransactionManager() async{
    String fileContentTransaction;
    File fileTransaction = await getFileTransaction;

    if (await fileTransaction.exists()){
      try{
        fileContentTransaction = await fileTransaction.readAsString();
        if (fileContentTransaction.isNotEmpty){
        return json.decode(fileContentTransaction);
        }
      }catch(error){
      }
    }
    
    return null;
  }

  //read data from the transaction File and returning it
  //Ensure that existing and new transaction are a List
  Future<List<dynamic>> listTransactionManager(fileTransaction) async{

    List<dynamic> jsonListTransaction = [];
    try {
      if (await fileTransaction.exists()) {
        String fileContentTransaction = await fileTransaction.readAsString();

        if (fileContentTransaction.isNotEmpty) {
          dynamic currentJsonListTransaction = json.decode(fileContentTransaction);
          if (currentJsonListTransaction is List) {
            jsonListTransaction = currentJsonListTransaction;
          } else if (currentJsonListTransaction is Map) {
            jsonListTransaction = [currentJsonListTransaction];
          }
        }
      }
    } catch (e) {
      //loggin later?
    }
    return jsonListTransaction;
  }

  //reading existing transaction data and adding the new transaction.
  //Saving all JSON encoded to the transaction file
 Future writeFileTransactionManager(String transactionName, String transactionDate, List<int> tag, double transactionAmount, bool repeat) async {
    
    final Transaction newTransaction = Transaction(transactionName, transactionDate, tag, transactionAmount, []); 

    File fileTransaction;

    if (repeat){
      fileTransaction = await getFileRepTransaction;
    }else{
      fileTransaction = await getFileTransaction;
    } 


    List<dynamic> jsonListTransaction = await listTransactionManager(fileTransaction);
    jsonListTransaction.add(newTransaction.toJson());
    await fileTransaction.writeAsString(json.encode(jsonListTransaction), flush: true);

  }

  //overwriting the transaction of the given index
  Future updateTransactionManager(int transactionIndex, String transactionName, String transactionDate, List<int> tag, double transactionAmount) async{
    final Transaction newTransaction = Transaction(transactionName, transactionDate, tag, transactionAmount, []); 
    File fileTransaction = await getFileTransaction;

    List<dynamic> jsonListTransaction = await listTransactionManager(fileTransaction);

    jsonListTransaction[transactionIndex] = newTransaction.toJson();

    await fileTransaction.writeAsString(json.encode(jsonListTransaction), flush: true);

  }

  Future deleteTransactionManager(transactionIndex) async{
    File fileTransaction = await getFileTransaction;

    List<dynamic> jsonListTransaction = await listTransactionManager(fileTransaction);
    
    jsonListTransaction.removeAt(transactionIndex);

    await fileTransaction.writeAsString(json.encode(jsonListTransaction), flush: true);
  }


  //Overwriting the transactino Json with empty String. Could call it nuclear fission
  Future resetFileTransactionManager()async{
    File fileTransaction = await getFileTransaction;
    await fileTransaction.writeAsString("", flush: true);

  }


  //------------------------------------------------------ REPEATING TRANSACTIONS ------------------------------------------------------//

  
  //trying to read the repeating transaction data and decodes them
  Future readFileRepTransactionManager() async{
    String fileContentRepTransaction;
    File fileRepTransaction = await getFileRepTransaction;

    if (await fileRepTransaction.exists()){
      try{
        fileContentRepTransaction = await fileRepTransaction.readAsString();
        if (fileContentRepTransaction.isNotEmpty){
        return json.decode(fileContentRepTransaction);
        }
      }catch(error){
      }
    }
    
    return null;
  }

  //read data from the transaction File and returning it
  //Ensure that existing and new transaction are a List
  Future<List<dynamic>> listRepTransactionManager(fileRepTransaction) async{


    List<dynamic> jsonListRepTransaction = [];
    try {
      if (await fileRepTransaction.exists()) {
        String fileContentRepTransaction = await fileRepTransaction.readAsString();

        if (fileContentRepTransaction.isNotEmpty) {
          dynamic currentJsonListRepTransaction = json.decode(fileContentRepTransaction);

          if (currentJsonListRepTransaction is List) {
            jsonListRepTransaction = currentJsonListRepTransaction;
          } else if (currentJsonListRepTransaction is Map) {
            jsonListRepTransaction = [currentJsonListRepTransaction];
          }
        }
      }
    } catch (e) {
      //loggin later?
    }
    return jsonListRepTransaction;
  }


    //overwriting the transaction of the given index
  Future updateRepTransactionManager(int transactionIndex, String transactionName, String transactionDate, List<int> tag, double transactionAmount) async{
    final Transaction newTransaction = Transaction(transactionName, transactionDate, tag, transactionAmount, []); 
    File fileRepTransaction = await getFileRepTransaction;

    List<dynamic> jsonListRepTransaction = await listTransactionManager(fileRepTransaction);

    jsonListRepTransaction[transactionIndex] = newTransaction.toJson();

    await fileRepTransaction.writeAsString(json.encode(jsonListRepTransaction), flush: true);

  }

  Future deleteRepTransactionManager(transactionRepIndex) async{
    File fileRepTransaction = await getFileRepTransaction;

    List<dynamic> jsonListRepTransaction = await listTransactionManager(fileRepTransaction);
    
    jsonListRepTransaction.removeAt(transactionRepIndex);

    await fileRepTransaction.writeAsString(json.encode(jsonListRepTransaction), flush: true);
  }


  //Overwriting the transactino Json with empty String. Could call it nuclear fission
  Future resetFileRepTransactionManager()async{
    File fileRepTransaction = await getFileRepTransaction;
    await fileRepTransaction.writeAsString("", flush: true);

  }

  

  //--------------------------------------------------------------- TAGS ---------------------------------------------------------------//


  //trying to read the tag data from the get file function and decodes them
   Future readTagManager() async{
    String fileContentTag;
    File fileTag = await getFileTag;

    if (await fileTag.exists()){
      try{
        fileContentTag = await fileTag.readAsString();
        if (fileContentTag.isNotEmpty){
        return json.decode(fileContentTag);
        }
      }catch(error){
      }
    }
    
    return null;
  }

  //Reading Tags from tag file to list
  //Ensure that existing and new tag are a List
  Future<List<dynamic>> listTagManager() async{
    
    File fileTag = await getFileTag;

    List<dynamic> jsonListTag = [];
    try{

    if (await fileTag.exists()) {
      String fileContentTag = await fileTag.readAsString();

      if(fileContentTag.isNotEmpty){
        dynamic currentJsonListTag = json.decode(fileContentTag);

        if (currentJsonListTag is List) {
          jsonListTag = currentJsonListTag;
        } else if (currentJsonListTag is Map) {
          jsonListTag = [currentJsonListTag];
        }
      }
    }
    }catch(e){
      //loggin later?
    }

    return jsonListTag;

  }

  //reading existing tag data and adding the new tag.
  // Saving all JSON encoded to the tag file
  Future writeTagManager(String tagName, String tagDescription) async {
    final Tag newTag = Tag(tagName, tagDescription);
    File fileTag = await getFileTag;
    
    List<dynamic> jsonListTag = await listTagManager();

    jsonListTag.add(newTag.toJson());

    await fileTag.writeAsString(json.encode(jsonListTag), flush: true);
  }

  //Overwriting tag file with empty string. Oppenheimer mode!!!
  Future resetTagManager()async{
    File fileTag = await getFileTag;
    await fileTag.writeAsString("", flush: true);

  }

  Future updateTagManager(int tagIndex, String tagName, String tagDescription) async {
    final Tag newTag = Tag(tagName, tagDescription);
    File fileTag = await getFileTag;

    List<dynamic> jsonListTag = await listTagManager();

    jsonListTag[tagIndex] = newTag;

    await fileTag.writeAsString(json.encode(jsonListTag), flush: true);
  }

  //delte Tag from tag file -> tag indices higher than the removed get changed
  //Tag will be removed from transaction
  Future deleteTagManager(int tagIndex) async {
    File fileTag = await getFileTag;
    File fileTransaction = await getFileTransaction;
    File fileRepTransaction = await getFileRepTransaction;

  List<dynamic> jsonListTag = await listTagManager();
  List<dynamic> jsonListTransaction = await listTransactionManager(fileTransaction);
  List<Transaction> listFormatedTransaction = (jsonListTransaction as List).map((item) => Transaction.fromJson(item as Map<String, dynamic>)).toList();

  List<dynamic> jsonListRepTransaction = await listRepTransactionManager(fileRepTransaction);
  List<Transaction> listFormatedRepTransaction = (jsonListRepTransaction as List).map((item) => Transaction.fromJson(item as Map<String, dynamic>)).toList();


    jsonListTag.removeAt(tagIndex);
    await fileTag.writeAsString(json.encode(jsonListTag), flush: true);

    //Remove Tag from Transaction if it gets deleted and all transactionTag get updated if the index of the Tags gets changed through deletion
    var i = 0;
    while(i < listFormatedTransaction.length){
        var j = 0;
        while(j < listFormatedTransaction[i].transactionTag.length){
          if(listFormatedTransaction[i].transactionTag[j] == tagIndex){
            listFormatedTransaction[i].transactionTag.removeAt(j);
          }
          else if (listFormatedTransaction[i].transactionTag[j] > tagIndex){
            listFormatedTransaction[i].transactionTag[j] = listFormatedTransaction[i].transactionTag[j] - 1;
          }
          j++;
        }
        i++;
    }

    //Remove Tag from repeating Transaction if it gets deleted and all transactionTag get updated if the index of the Tags gets changed through deletion
    var k = 0;
    while(k < listFormatedRepTransaction.length){
        var h = 0;
        while(h < listFormatedRepTransaction[k].transactionTag.length){
          if(listFormatedRepTransaction[k].transactionTag[h] == tagIndex){
            listFormatedRepTransaction[k].transactionTag.removeAt(h);
          }
          else if (listFormatedRepTransaction[k].transactionTag[h] > tagIndex){
            listFormatedRepTransaction[k].transactionTag[h] = listFormatedRepTransaction[k].transactionTag[h] - 1;
          }
          h++;
        }
        k++;
    }

    await fileTransaction.writeAsString(json.encode(listFormatedTransaction), flush: true);
    await fileRepTransaction.writeAsString(json.encode(listFormatedRepTransaction), flush: true);

  }

}
