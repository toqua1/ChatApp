class GroupChat {
  String id;
  String name;
  String? image;
  List admin ;
  List members ;
  String createdAt;
  String lastMessage ;
  String lastMessageTime ;

  GroupChat({
    required this.id ,
    required this.name ,
    required this.image,
    required this.admin,
    required this.createdAt ,
    required this.lastMessage ,
    required this.lastMessageTime,
    required this.members
  });

  factory GroupChat.fromJson(Map<String , dynamic>json){
    return GroupChat(
        id: json['id'] ?? "",/*if null return empty*/
        name: json['name'] ?? '',
        image: json['image'] ?? '',
        admin: json['admins_id'] ?? [] ,
        createdAt: json['created_at'],
        lastMessage: json['last_message'] ??"",
        lastMessageTime: json['last_message_time'] ?? "",
        members: json['members'] ?? [],

    );
  }

  Map<String ,dynamic> toJson(){
    return {
      'id':id ,
      'name': name ,
      'image':image,
      'admins_id':admin,
      'created_at':createdAt ,
      'last_message':lastMessage ,
      'last_message_time':lastMessageTime ,
      'members': members ,
    } ;
  }


}