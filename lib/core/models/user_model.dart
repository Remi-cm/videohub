import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id, photoUrl, username, familyname, firstname, email, phone, role;
  int? permissionLevel;
  DateTime? dateCreated;

  UserModel({this.id, this.photoUrl, this.dateCreated, this.username, this.familyname, this.firstname, this.email, this.phone, this.role, this.permissionLevel = 3});

  void setPhotoUrl(String url){
    photoUrl = url;
  }

  factory UserModel.fromDocument(DocumentSnapshot doc, Map data){
    return UserModel(
      id: doc.id,
      photoUrl: data["photoUrl"],
      dateCreated: data["dateCreated"]?.toDate(),
      username: data["username"],
      familyname: data["familyname"],
      firstname: data["firstname"],
      email: data["email"],
      phone: data["phone"],
      role: data["role"],
      permissionLevel: data["level"]
    );
  }
}