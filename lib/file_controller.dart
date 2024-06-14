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
    final jsonDataTransaction = await FileManager().readFileTransaction();
    //If transactions exist and a transaction has taggs, add the Names of the Tag to the Transaction class
    if (jsonDataTransaction != null) {
      listTransaction = (jsonDataTransaction as List).map((item) => Transaction.fromJson(item as Map<String, dynamic>)).toList();
      if (listTransaction[1].transactionTag !=  []){
        var i = 0;
        while(i < listTransaction.length){
          listTransaction[i].transactionTagName.clear();
          var j = 0;
          while(j < listTransaction[i].transactionTag.length){
            try{
              listTransaction[i].transactionTagName.add(listTag[listTransaction[i].transactionTag[j]].tagName);

            }catch(e){
            }
            j++;
          }
          i++;
        }
      }
      notifyListeners();
    }
  }

  //Takes input and creates a new Transaction. Automaticlly updates the Tag-Transaction mapping
  createTransaction(transactionName, transactionDate, transactionTag, transactionAmount) async {
    await FileManager().writeFileTransaction(transactionName, transactionDate, transactionTag, transactionAmount);
    await readTransaction();
    await readTag();
  }

  //nuke whole transaction JSON file
  resetTransaction() async{
    await FileManager().resetFileTransaction();
    listTransaction = [];
    await readTransaction();
    await readTag();
  }

  //Reads and updates the list of tags from the JSON. Notifys listeners to update shown values.
  Future<void> readTag() async {
    final jsonDataTag = await FileManager().readTag();
    if (jsonDataTag != null) {
      listTag = (jsonDataTag as List).map((item) => Tag.fromJson(item as Map<String, dynamic>)).toList();
    }
    notifyListeners();

  }

  //Takes input and creates a new tag. Automaticlly updates the Tag-Transaction mapping
  createTag(tagName, tagDescription) async{
    tag = await FileManager().writeTag(tagName ,tagDescription);
    await readTag();
    await readTransaction();
    }

  //nuke whole tag JSON file
  resetTag() async{
    await FileManager().resetTag();
    listTag = [];
    await readTransaction();
    await readTag();
  }

}