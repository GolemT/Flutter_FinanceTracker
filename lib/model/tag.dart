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