class Book{
  String? title;
  String? author;
  String? startDate;
  String? endDate;
  String? simpleFeel;
  String? id;

  Book(this.title, this.author, this.startDate, this.endDate, this.simpleFeel, this.id);

  Map<String, dynamic> toMap(){
    return{
      'title': title,
      'author' : author,
      'startDate' : startDate,
      'endDate' : endDate,
      'simpleFeel': simpleFeel,
      'id': id,
    };
  }
  Book.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        author = json['author'],
        startDate = json['endDate'],
        endDate = json['endDate'],
        simpleFeel = json['simpleFeel'];

  toJson() {
    return {
      'title': title,
      'author' : author,
      'startDate' : startDate,
      'endDate' : endDate,
      'simpleFeel': simpleFeel,
      'id' : id,
    };
  }

}