import 'package:finance_tracker/file_manager.dart';
import 'package:finance_tracker/model/tag.dart';
import 'package:finance_tracker/model/transaction.dart';
import 'package:flutter/material.dart';

class FileController extends ChangeNotifier {

  List<Transaction> listTransaction = [];
  Transaction? transaction;

  List<Tag> listTag = [];
  Tag? tag;

  //Inital loading of the data and mapping tags to transactions  
  FileController() {
    readTransaction();
    readTag();
  }

  //Reads and updates the tansaction list from the JSON. Notifys listeners to update shown values.
  Future<void> readTransaction() async {
    final jsonDataTransaction = await FileManager().readFileTransactionManager();
    //If transactions exist and a transaction has taggs, add the Names of the Tag to the Transaction class
    if (jsonDataTransaction != null) {
      listTransaction = (jsonDataTransaction as List).map((item) => Transaction.fromJson(item as Map<String, dynamic>)).toList();
        var i = 0;
        while(i < listTransaction.length){
          listTransaction[i].transactionTagName.clear();
          var j = 0;
          listTransaction[i].transactionTagName = [];
          while(j < listTransaction[i].transactionTag.length){
            try{
              listTransaction[i].transactionTagName.add(listTag[listTransaction[i].transactionTag[j]].tagName);

            }catch(e){
            }
            j++;
          }
          i++;
      }
      notifyListeners();
    }
  }

  //Takes input and creates a new Transaction. Automaticlly updates the Tag-Transaction mapping
  createTransaction(transactionName, transactionDate, transactionTag, transactionAmount) async {
    await FileManager().writeFileTransactionManager(transactionName, transactionDate, transactionTag, transactionAmount);
    await refreshTagsAndTransactions();
}

  updateTransaction(transactionIndex, transactionName, transactionDate, tag, transactionAmount) async{
    await FileManager().updateTransactionManager(transactionIndex, transactionName, transactionDate, tag, transactionAmount);
    await refreshTagsAndTransactions();
}

  deleteTransaction(transactionIndex) async{
    await FileManager().deleteTransactionManager(transactionIndex);
    await refreshTagsAndTransactions();
}


  //nuke whole transaction JSON file
  resetTransaction() async{
    await FileManager().resetFileTransactionManager();
    listTransaction = [];
    await refreshTagsAndTransactions();
  }


  //--------------------------------------------------------------- TAGS ---------------------------------------------------------------//


  //Reads and updates the list of tags from the JSON. Notifys listeners to update shown values.
  Future<void> readTag() async {
    final jsonDataTag = await FileManager().readTagManager();
    if (jsonDataTag != null) {
      listTag = (jsonDataTag as List).map((item) => Tag.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      listTag = [];
    }
    notifyListeners();

  }

  //Takes input and creates a new tag. Automaticlly updates the Tag-Transaction mapping
  createTag(tagName, tagDescription) async{
    tag = await FileManager().writeTagManager(tagName ,tagDescription);
    await refreshTagsAndTransactions();

    }

  updateTag(tagIndex, tagName, tagDescription) async{
    tag = await FileManager().updateTagManager(tagIndex, tagName ,tagDescription);
    await refreshTagsAndTransactions();

  }

  //deletes Tag and updates transactionTag indices
  deleteTag(tagIndex) async{
    await FileManager().deleteTagManager(tagIndex);
    await refreshTagsAndTransactions();

  }

  //nuke whole tag JSON file
  resetTag() async{
    await FileManager().resetTagManager();
    listTag = [];
    await refreshTagsAndTransactions();
  }

  Future<void> refreshTagsAndTransactions() async {
    await readTag();
    await readTransaction();
  }

}