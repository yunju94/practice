class Review{
  String? id;
  String? title;
  String? startDate;
  String? endDate;
  String? simpleFeel;
  int? count;
  String uuid;


  Review(this.id, this.title,  this.startDate, this.endDate, this.simpleFeel, this.count, this.uuid);

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'title': title,
      'startDate' : startDate,
      'endDate' : endDate,
      'simpleFeel': simpleFeel,
      'count' : count,
      'uuid' : uuid,
    };
  }
  Review.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        startDate = json['startDate'],
        endDate = json['endDate'],
        simpleFeel = json['simpleFeel'],
        count = json['count'] ,
        uuid = json['uuid'];

  toJson() {
    return {
      'id' : id,
      'title': title,
      'startDate' : startDate,
      'endDate' : endDate,
      'simpleFeel': simpleFeel,
      'count' : count,
      'uuid' : uuid,

    };
  }

}