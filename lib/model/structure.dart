
class Transaction {
  final String transactionName;
  final String transactionDate;
  final List<int> transactionTag;
  final double transactionAmount; 
  final List<String> transactionTagName;  //Gets automaticlly filled with the tagName when the date got read. Input needed ist the Index of the Tag stored in the Tag JSON

  Transaction(this.transactionName, this.transactionDate, this.transactionTag, this.transactionAmount, this.transactionTagName);

  //converting JSON to transaction object
  Transaction.fromJson(Map<String, dynamic> json)
    : transactionName = json['transactionName'],
      transactionDate = json['transactionDate'],
      transactionTag = List<int>.from(json['transactionTag']),
      transactionAmount = json['transactionAmount'],
      transactionTagName = List<String>.from(json['transactionTagName']);

  //converting transaction object to JSON
  Map<String, dynamic> toJson() => {
    'transactionName': transactionName,
    'transactionDate': transactionDate,
    'transactionTag': transactionTag,
    'transactionAmount': transactionAmount,
    'transactionTagName': transactionTagName,
  };

  //Improves readability of output
  @override
  String toString() {
    return 'transaction:{transactionName: $transactionName, transactionDate: $transactionDate, transactionTag: $transactionTag, transactionAmount: $transactionAmount, transactionTagName: $transactionTagName}';
  }

}

class Tag {
  final String tagName;
  final String tagDescription;

  Tag(this.tagName, this.tagDescription);

  //converting JSON to tag object
  Tag.fromJson(Map<String, dynamic> json)
    : tagName =json['tagName'],
      tagDescription = json['tagDescription'];

  //converting tag object to JSON    
  Map<String, dynamic> toJson()=> {
    'tagName': tagName,
    'tagDescription': tagDescription,
  };

  //Improves readability 
  @override
  String toString(){
    return 'Tags{tagName: $tagName, tagDescription: $tagDescription}';
  }

}