import 'package:finance_tracker/file_manager.dart';
import 'package:finance_tracker/model/tag.dart';
import 'package:finance_tracker/model/transaction.dart';
import 'package:flutter/material.dart';

class FileController extends ChangeNotifier {
  List<Transaction> listTransaction = [];
  Transaction? transaction;

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

  // Takes input and creates a new transaction. Automatically updates the Tag-Transaction mapping
  createTransaction(String transactionName, String transactionDate, List<int> transactionTag, double transactionAmount) async {
    await FileManager().writeFileTransactionManager(transactionName, transactionDate, transactionTag, transactionAmount);
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
    await refreshTagsAndTransactions();
  }

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
  }
}
