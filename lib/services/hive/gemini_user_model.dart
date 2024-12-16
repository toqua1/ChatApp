import 'package:hive/hive.dart';

part 'gemini_user_model.g.dart';
@HiveType(typeId: 1)
class GeminiUserModel extends HiveObject{
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String image;

  GeminiUserModel({
    required this.uid,
    required this.name,
    required this.image,
  });
}