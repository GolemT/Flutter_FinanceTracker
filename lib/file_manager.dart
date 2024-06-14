import 'dart:convert';
import 'dart:io';

import 'package:finance_tracker/model/structure.dart';
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
    return File('$path/test.json');
  }

  //Setting the file for tags
  Future<File> get getFileTag async{
    final path = await directoryPath;
    return File('$path/tagList.json');
  }

  //trying to read the transaction data and decodes them
  Future readFileTransaction() async{
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


  //reading existing transaction data and adding the new transaction.
  //Ensure that existing and new transaction are a List
  // Saving all JSON encoded to the transaction file
 Future writeFileTransaction(String transactionName, String transactionDate, List<int> tag, double transactionAmount) async {
    final Transaction newTransaction = Transaction(transactionName, transactionDate, tag, transactionAmount, []); 
    File fileTransaction = await getFileTransaction;

    List<dynamic> jsonListTransaction = [];
    try{

    if (await fileTransaction.exists()) {
      String fileContentTransaction = await fileTransaction.readAsString();
      if(fileContentTransaction.isNotEmpty){
        dynamic currentJsonListTransaction = json.decode(fileContentTransaction);

        if (currentJsonListTransaction is List) {
          jsonListTransaction = currentJsonListTransaction;
        } else if (currentJsonListTransaction is Map) {
          jsonListTransaction = [currentJsonListTransaction];
        } else {

          jsonListTransaction = []; //WTF WARUM MACH ICH DREIMAL DAS GLEICHE???
        }
      } else{
        jsonListTransaction = [];
      }
    }
    }catch(e){
      jsonListTransaction = [];
    }
    jsonListTransaction.add(newTransaction.toJson());

    await fileTransaction.writeAsString(json.encode(jsonListTransaction), flush: true);
  }

  //Overwriting the transactino Json with empty String. Could call it nuclear fission
  Future resetFileTransaction()async{
    File fileTransaction = await getFileTransaction;
    await fileTransaction.writeAsString("", flush: true);

  }

  //trying to read the tag data from the get file function and decodes them
   Future readTag() async{
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



  //reading existing tag data and adding the new tag.
  //Ensure that existing and new tag are a List
  // Saving all JSON encoded to the tag file
  Future writeTag(String tagName, String tagDescription) async {
    final Tag newTag = Tag(tagName, tagDescription);
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
        } else {

          jsonListTag = [];               //WTF WARUM MACH ICH DREIMAL DAS GLEICHE???
        }
      } else{
        jsonListTag = [];
      }
    }
    }catch(e){
          jsonListTag = [];
    }


    jsonListTag.add(newTag.toJson());

    await fileTag.writeAsString(json.encode(jsonListTag), flush: true);
  }

  //Overwriting tag file with empty string. Oppenheimer mode!!!
  Future resetTag()async{
    File fileTag = await getFileTag;
    await fileTag.writeAsString("", flush: true);

  }


}
