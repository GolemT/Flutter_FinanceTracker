class RepTransaction {
  String transactionName;
  //String transactionDate;
  List<int> transactionTag;
  double transactionAmount; 
  List<String> transactionTagName;  //Gets automaticlly filled with the tagName when the date got read. Input needed ist the Index of the Tag stored in the Tag JSON

  RepTransaction(this.transactionName, this.transactionTag, this.transactionAmount, this.transactionTagName);

  //converting JSON to reptransaction object
  RepTransaction.fromJson(Map<String, dynamic> json)
    : transactionName = json['transactionName'],
      //transactionDate = json['transactionDate'],
      transactionTag = List<int>.from(json['transactionTag']),
      transactionAmount = json['transactionAmount'],
      transactionTagName = List<String>.from(json['transactionTagName']);

  //converting reptransaction object to JSON
  Map<String, dynamic> toJson() => {
    'transactionName': transactionName,
    //'transactionDate': transactionDate,
    'transactionTag': transactionTag,
    'transactionAmount': transactionAmount,
    'transactionTagName': transactionTagName,
  };

  //Improves readability of output
  @override
  String toString() {
    return 'reptransaction:{transactionName: $transactionName, transactionTag: $transactionTag, transactionAmount: $transactionAmount, transactionTagName: $transactionTagName}';
  }

}