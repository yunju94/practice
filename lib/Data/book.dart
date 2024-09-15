class Book{
  String? id;
  String? title;
  String? author;
  String? thumbnail;



  Book( this.id, this.title, this.author, this.thumbnail);

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'title': title,
      'author' : author,
      'thumbnail' : thumbnail,

    };
  }
  Book.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        author = json['author'],
       thumbnail = json['thumbnail'];


  toJson() {
    return {
      'id' : id,
      'title': title,
      'author' : author,
      'thumbnail' : thumbnail,


    };
  }

}