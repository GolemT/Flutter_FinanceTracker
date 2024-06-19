import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:finance_tracker/model/tag.dart';
import 'package:finance_tracker/model/transaction.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {

  //TRANSACTIONS:

  //Reading of the mobile device path
    Future<String> get directoryPath async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  //Setting the file for transactions
  Future<File> get getFileTransaction async{
    final path = await directoryPath;
    return File('$path/test.json');
  }

  //Setting the file for tags
  Future<File> get getFileTag async{
    final path = await directoryPath;
    return File('$path/tagList.json');
  }

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
        print(error);
      }
    }
    
    return null;
  }

  //read data from the transaction File and returning it
  //Ensure that existing and new transaction are a List
  Future<List<dynamic>> listTransactionManager() async{
    File fileTransaction = await getFileTransaction;

    List<dynamic> jsonListTransaction = [];
    try {
      if (await fileTransaction.exists()) {
        String fileContentTransaction = await fileTransaction.readAsString();
        jsonListTransaction = [];

        if (fileContentTransaction.isNotEmpty) {
          dynamic currentJsonListTransaction = json.decode(fileContentTransaction);

          if (currentJsonListTransaction is List) {
            jsonListTransaction = currentJsonListTransaction;
          } else if (currentJsonListTransaction is Map) {
            jsonListTransaction = [currentJsonListTransaction];
          }
        }
      } else {
        jsonListTransaction = [];
      }
    } catch (e) {
      jsonListTransaction = [];
    }
    return jsonListTransaction;
  }

  //reading existing transaction data and adding the new transaction.
  //Saving all JSON encoded to the transaction file
 Future writeFileTransactionManager(String transactionName, String transactionDate, List<int> tag, double transactionAmount) async {
    final Transaction newTransaction = Transaction(transactionName, transactionDate, tag, transactionAmount, []); 
    File fileTransaction = await getFileTransaction;

    List<dynamic> jsonListTransaction = await listTransactionManager();

    jsonListTransaction.add(newTransaction.toJson());

    await fileTransaction.writeAsString(json.encode(jsonListTransaction), flush: true);
  }

  //overwriting the transaction of the given index
  Future updateTransactionManager(int transactionIndex, String transactionName, String transactionDate, List<int> tag, double transactionAmount) async{
    final Transaction newTransaction = Transaction(transactionName, transactionDate, tag, transactionAmount, []); 
    File fileTransaction = await getFileTransaction;

    List<dynamic> jsonListTransaction = await listTransactionManager();

    jsonListTransaction[transactionIndex] = newTransaction.toJson();

    await fileTransaction.writeAsString(json.encode(jsonListTransaction), flush: true);

  }

  Future deleteTransactionManager(transactionIndex) async{
    File fileTransaction = await getFileTransaction;

    List<dynamic> jsonListTransaction = await listTransactionManager();
    
    jsonListTransaction.removeAt(transactionIndex);

    await fileTransaction.writeAsString(json.encode(jsonListTransaction), flush: true);
  }


  //Overwriting the transactino Json with empty String. Could call it nuclear fission
  Future resetFileTransactionManager()async{
    File fileTransaction = await getFileTransaction;
    await fileTransaction.writeAsString("", flush: true);

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
        print(error);
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
      jsonListTag = [];

      if(fileContentTag.isNotEmpty){
        dynamic currentJsonListTag = json.decode(fileContentTag);

        if (currentJsonListTag is List) {
          jsonListTag = currentJsonListTag;
        } else if (currentJsonListTag is Map) {
          jsonListTag = [currentJsonListTag];
        }
      } else{
        jsonListTag = [];
      }
    }
    }catch(e){
      jsonListTag = [];
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

  List<dynamic> jsonListTag = await listTagManager();
  List<dynamic> jsonListTransaction = await listTransactionManager();
  List<Transaction> listFormatedTransaction = (jsonListTransaction as List).map((item) => Transaction.fromJson(item as Map<String, dynamic>)).toList();

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
    await fileTransaction.writeAsString(json.encode(listFormatedTransaction), flush: true);

    print(listFormatedTransaction);

  }

}
