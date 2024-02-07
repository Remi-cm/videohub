import 'package:cloud_firestore/cloud_firestore.dart';

class Actor {
  String? id, orphanageId, photoUrl, name, phoneNumber, grade, fullPhoneNumber, email, gender, countryCode;
  bool? isMarried, tutorAssistedSession, wasConverted;
  int? nberKids;
  DateTime? birthDate, dateCreated;
  List? skills;

 Actor({this.photoUrl, this.orphanageId, this.name, this.phoneNumber, this.fullPhoneNumber, this.email, this.grade, this.wasConverted, this.countryCode, this.tutorAssistedSession, this.gender, this.skills, this.isMarried, this.nberKids, this.birthDate, this.id, this.dateCreated});

  factory Actor.fromDocument(DocumentSnapshot doc, Map data){
    return Actor(
      id: doc.id, 
      orphanageId: data["orphanageId"],
      photoUrl: data["photoUrl"], 
      name: data["name"], 
      grade: data["grade"],
      phoneNumber: data["phoneNumber"], 
      fullPhoneNumber: data["phoneNumberFull"],
      email: data["email"], 
      gender: data["gender"], 
      isMarried: data["isMarried"], 
      skills: data["skills"],
      nberKids: data["berKids"], 
      countryCode: data["countryCode"],
      tutorAssistedSession: data["tutorAssistedSession"],
      wasConverted: data["wasConverted"],
      birthDate: data["birthDate"] != null ? data["birthDate"].toDate() : data["birthDate"], 
      dateCreated: data['dateCreated'] != null ? data['dateCreated'].toDate() : data['dateCreated']
    );
  }
}