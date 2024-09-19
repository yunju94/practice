class Member{
  String id;
  String pw;
  String createTime;

  Member(this.id, this.pw, this.createTime);
  Member.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        pw = json['pw'],
        createTime = json['createTime'];

  toJson() {
    return {
      'id': id,
      'pw': pw,
      'createTime': createTime,
    };

  }

}