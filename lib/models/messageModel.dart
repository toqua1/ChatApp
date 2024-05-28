class Message {
  String?id;
  String?toId ;
  String?message ;
  String?fromId ;
  String?type;/*text or image*/
  String?createdAt ;
  String?read ;

  Message({
    required this.id,
    required this.fromId,
    required this.toId,
    required this.createdAt,
    required this.read,
    required this.type,
    required this.message
  }) ;

  factory Message.fromJason(json){
    return Message(
      id: json['id'] ??"",
      fromId: json['from_id'],
      toId: json['to_id'],
      createdAt: json['created_at'],
      read: json['read'],
      type: json['type'],
      message: json['message'],
    );
  }

  Map<String ,dynamic> toJson(){
    return {
      "id" :id ,
      "to_id":toId,
      "from_id":fromId ,
      "message":message ,
      "type":type ,
      "read":read,
      "created_at":createdAt
    };
  }
}