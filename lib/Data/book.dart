class Book{
  String? id;
  String? title;
  String? author;
  String? thumbnail;
  String? uuid;



  Book( this.id, this.title, this.author, this.thumbnail, this.uuid);

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'title': title,
      'author' : author,
      'thumbnail' : thumbnail,
      'uuid' : uuid,

    };
  }
  Book.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        author = json['author'],
       thumbnail = json['thumbnail'],
        uuid = json['uuid'];



  toJson() {
    return {
      'id' : id,
      'title': title,
      'author' : author,
      'thumbnail' : thumbnail,
      'uuid' : uuid,


    };
  }

}