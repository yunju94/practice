class Review{
  String? id;
  String? title;
  String? startDate;
  String? endDate;
  String? simpleFeel;

  Review(this.id, this.title,  this.startDate, this.endDate, this.simpleFeel);

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'title': title,

      'startDate' : startDate,
      'endDate' : endDate,
      'simpleFeel': simpleFeel,

    };
  }
  Review.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        startDate = json['startDate'],
        endDate = json['endDate'],
        simpleFeel = json['simpleFeel'];

  toJson() {
    return {
      'id' : id,
      'title': title,
      'startDate' : startDate,
      'endDate' : endDate,
      'simpleFeel': simpleFeel,

    };
  }

}