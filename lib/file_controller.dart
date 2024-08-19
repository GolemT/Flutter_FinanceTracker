import 'package:finance_tracker/file_manager.dart';
import 'package:finance_tracker/model/tag.dart';
import 'package:finance_tracker/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FileController extends ChangeNotifier {
  List<Transaction> listTransaction = [];
  Transaction? transaction;

  List<Transaction> listRepTransaction = [];
  Transaction? repTransaction;

  List<Tag> listTag = [];
  Tag? tag;

  // Initial loading of the data and mapping tags to transactions
  FileController() {
    refreshTagsAndTransactions();
  }

  // Reads and updates the transaction list from the JSON. Notifies listeners to update shown values.
  Future<void> readTransaction() async {
    final jsonDataTransaction = await FileManager().readFileTransactionManager();
    // If transactions exist and a transaction has tags, add the names of the tags to the Transaction class

    if (jsonDataTransaction != null) {
      listTransaction = (jsonDataTransaction as List).map((item) => Transaction.fromJson(item as Map<String, dynamic>)).toList();
      for (var transaction in listTransaction) {
        transaction.transactionTagName.clear();
        transaction.transactionTagName = transaction.transactionTag.map((index) => listTag[index].tagName).toList();
      }
      notifyListeners();
    }
  }

  //Takes input and creates a new Transaction. Automatically updates the Tag-Transaction mapping
  createTransaction(transactionName, transactionDate, transactionTag, transactionAmount, bool repeat) async {
    await FileManager().writeFileTransactionManager(transactionName, transactionDate, transactionTag, transactionAmount, repeat);
    await refreshTagsAndTransactions();
}

  updateTransaction(int transactionIndex, String transactionName, String transactionDate, List<int> tag, double transactionAmount) async {
    await FileManager().updateTransactionManager(transactionIndex, transactionName, transactionDate, tag, transactionAmount);
    await refreshTagsAndTransactions();
  }

  deleteTransaction(int transactionIndex) async {
    await FileManager().deleteTransactionManager(transactionIndex);
    await refreshTagsAndTransactions();
  }

  // Nuke whole transaction JSON file
  resetTransaction() async {
    await FileManager().resetFileTransactionManager();
    listTransaction = [];    
    await FileManager().resetFileRepTransactionManager();
    await refreshTagsAndTransactions();
  }

  //------------------------------------------------------ REPEATING TRANSACTIONS ------------------------------------------------------//

  Future<void> readRepTransaction() async {

    final jsonDataRepTransaction = await FileManager().readFileRepTransactionManager();
    // If transactions exist and a transaction has tags, add the names of the tags to the Transaction class

    if (jsonDataRepTransaction != null) {
      listRepTransaction = (jsonDataRepTransaction as List).map((item) => Transaction.fromJson(item as Map<String, dynamic>)).toList();
      for (var transaction in listRepTransaction) {
        transaction.transactionTagName.clear();
        transaction.transactionTagName = transaction.transactionTag.map((index) => listTag[index].tagName).toList();
      }
      notifyListeners();
    }
  }

  updateRepTransaction(int transactionIndex, String transactionName, String transactionDate, List<int> tag, double transactionAmount) async {
    await FileManager().updateRepTransactionManager(transactionIndex, transactionName, transactionDate, tag, transactionAmount);
    await refreshTagsAndTransactions();
      }

  deleteRepTransaction(int transactionIndex) async {
    await FileManager().deleteRepTransactionManager(transactionIndex);
    await refreshTagsAndTransactions();
  }


  //--------------------------------------------------------------- TAGS ---------------------------------------------------------------//


  // Reads and updates the list of tags from the JSON. Notifies listeners to update shown values.
  Future<void> readTag() async {
    final jsonDataTag = await FileManager().readTagManager();
    if (jsonDataTag != null) {
      listTag = (jsonDataTag as List).map((item) => Tag.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      listTag = [];
    }
    notifyListeners();
  }

  // Takes input and creates a new tag. Automatically updates the Tag-Transaction mapping
  createTag(String tagName, String tagDescription) async {
    tag = await FileManager().writeTagManager(tagName, tagDescription);
    await refreshTagsAndTransactions();
  }

  updateTag(int tagIndex, String tagName, String tagDescription) async {
    tag = await FileManager().updateTagManager(tagIndex, tagName, tagDescription);
    await refreshTagsAndTransactions();
  }

  // Deletes tag and updates transactionTag indices
  deleteTag(int tagIndex) async {
    await FileManager().deleteTagManager(tagIndex);
    await refreshTagsAndTransactions();
  }

  // Nuke whole tag JSON file
  resetTag() async {
    await FileManager().resetTagManager();
    listTag = [];
    await refreshTagsAndTransactions();
  }

  Future<void> refreshTagsAndTransactions() async {
    await readTag();
    await readTransaction();
    await readRepTransaction();
  }


  //----------------------------------------------------------  WORKMANAGER ZEUGS ----------------------------------------------------------//

Future<void> performTask() async {
  final  fileController = FileController();

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');


  final jsonDataRepTransaction = await fileController.readRepTransaction();
  final listRepTransaction = (jsonDataRepTransaction as List).map((item) => Transaction.fromJson(item as Map<String, dynamic>)).toList();

  int i = 0;

  while(i < listRepTransaction.length){

    final DateTime now = DateTime.now();
    int transactionDay = dateFormat.parse(listRepTransaction[i].transactionDate).day;

    //Checks if the current Data matches the transaction date. Controlls that the day is included in the current month, if not it will uses the last day of the month 
    DateTime firstDayOfNextMonth = (now.month < 12)
      ? DateTime(now.year, now.month + 1, 1)
      : DateTime(now.year + 1, 1, 1);

    DateTime lastDayOfCurrentMonth = firstDayOfNextMonth.subtract(const Duration(days: 1));

    if ((now.day == transactionDay) ||
    (now.day ==  lastDayOfCurrentMonth.day && transactionDay > 28)){
        await fileController.createTransaction(
          listRepTransaction[i].transactionName, 
          DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(), 
          listRepTransaction[i].transactionTag, 
          listRepTransaction[i].transactionAmount, 
          false
        );

    } 

  i += 1;
  }
}


}
