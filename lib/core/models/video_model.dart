import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  final String? id, name, author, url, thumbnailUrl, description;
  final DateTime? dateCreated;

  VideoModel({this.id, this.name, this.author, this.url, this.dateCreated, this.thumbnailUrl, this.description});

  factory VideoModel.fromDocument(DocumentSnapshot doc, Map data) {
    return VideoModel(
      id: doc.id,
      name: data["name"], 
      author: data["author"], 
      url: data["url"], 
      thumbnailUrl: data["thumbnailUrl"], 
      description: data["description"], 
      dateCreated: data['dateCreated']?.toDate(),
    );
  }

}