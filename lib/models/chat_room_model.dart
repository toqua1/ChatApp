class ChatRoom {
  String? id;
  List? members ;
  String? createdAt;
  String? lastMessage ;
  String? lastMessageTime ;

  ChatRoom({
    required this.id ,
    required this.createdAt ,
    required this.lastMessage ,
    required this.lastMessageTime,
    required this.members
  });

  factory ChatRoom.fromJson(Map<String , dynamic>json){
    return ChatRoom(
        id: json['id'] ?? "",/*if null return empty*/
        createdAt: json['created_at'],
        lastMessage: json['last_message'] ??"",
        lastMessageTime: json['last_message_time'] ?? "",
        members: json['members'] ?? []);
  }

  Map<String ,dynamic> toJson(){
    return {
      'id':id ,
      'created_at':createdAt ,
      'last_message':lastMessage ,
      'last_message_time':lastMessageTime ,
      'members': members
    } ;
  }


}