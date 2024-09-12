class Book{
  int? id;
  String? title;
  String? author;
  String? startDate;
  String? endDate;

  Book({this.id, this.title, this.author, this.startDate, this.endDate});

  Map<String, dynamic> toMap(){
    return{
      'id' : id,
      'title': title,
      'author' : author,
      'startDate' : startDate,
      'endDate' : endDate,
    };
  }

}