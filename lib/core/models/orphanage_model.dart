
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Orphanage {

  // INTENDED GEPEES

  String? id, countryIsoCode, countryPhoneCode, commentsAboutHandicaps, photoUrl, name, region, city, religion, principalSourceOfFinance, mostCommonDisease, childrenStudySuccessDescription;
  String? gepState; // INTENDED - ONGOING - COMPLETED
  int? nberTutors, nberChildren, nberChildrenRegistered, handicaps, nberMales, nberFemales, nberChildrenAbove13, nberChildrenBelow5, nberScholarizedChildren, nberChildrenAboveForm5, averageNberChildrenPromotedToNextGrade, averageNberChildrenRepeat, averageNberChildrenDropout;
  num? distanceToTown, averageTimeToTown;
  DateTime? dateCreated;
  List? energySources, waterSources, partners, orphanageBusinesses, childrenBusinesses, visits, photos;
  bool? display, doTheyRunOutOfFunds, abilityToFullySponsorPrimarySchoolStuds, abilityToFullySponsorSecondarySchoolStuds, abilityToFullySponsorAboveALevelStud, haveChildrenAcknowledgedTheOrphanage, areSomeChildrenIntoBusiness, doesOrphanageOwnABusiness, doesChildrenSufferMentalHealthIssues, hasBeenSentitizedAboutGEPVision, isWillingToAllowGFAOnBoardWithChildren, areTutorsWillingToWorkWithGEPTeam, havePartnersOrAffiliations;
  List<OrphanageContact>? contacts;  //List<OrphanageContact>? contacts;
  List? mainDropoutOrAcademicFailureReasons, biggestNeeds, typeOfAssistanceNeeded;
  List<Testimony>? testimonies;   //List<Testimony>? testimonies;
  List? mentors;     //List<Mentors>? mentors;
  List<Clubs>? clubs;    //List<Clubs>? clubs;
  GPSCoords? gpsCoords;


  // ONGOING GEPEES

  final String? conflictWithTutorsReason, personWhoPrayedForChildren;
  final bool? hasTutorsBeenCollaborative, hasTutorsBeenUpToExpectations, canWeCountOnTutorsToPursueGEPActivities, wereThereSuggestionsForGEPByTutors;
  final num? percentageOfResponse;
  final int? donationTotalCost, logisticTotalCost;
  List? materialsHandedToTutorsForKids, children, tutors, appreciatonsFromTutors, criticsFromTutors, logisticsHandedToStudents, affirmationForms, careerBrochures, kitchenRecipes, agendas, trainingContentUrls;
  final List<Books>? books;
  final List<Media>? selfDevelopmentmedias;

  // FOR APP COMPUTATION

  bool? edit;

  Orphanage({this.id, this.name, this.photoUrl, this.gepState, this.edit, this.children, this.visits, this.donationTotalCost, this.logisticTotalCost, this.nberChildrenRegistered, this.tutors, this.countryIsoCode, this.childrenBusinesses, this.photos, this.orphanageBusinesses, this.countryPhoneCode, this.partners, this.display, this.region, this.city, this.gpsCoords, this.religion, this.principalSourceOfFinance, this.mostCommonDisease, this.childrenStudySuccessDescription, this.energySources, this.waterSources, this.nberTutors, this.nberChildren, this.nberMales, this.nberFemales, this.nberChildrenAbove13, this.nberChildrenBelow5, this.nberScholarizedChildren, this.nberChildrenAboveForm5, this.averageNberChildrenPromotedToNextGrade, this.averageNberChildrenRepeat, this.averageNberChildrenDropout, this.distanceToTown, this.averageTimeToTown, this.dateCreated, this.doTheyRunOutOfFunds, this.abilityToFullySponsorPrimarySchoolStuds, this.abilityToFullySponsorSecondarySchoolStuds, this.abilityToFullySponsorAboveALevelStud, this.haveChildrenAcknowledgedTheOrphanage, this.areSomeChildrenIntoBusiness, this.doesOrphanageOwnABusiness, this.doesChildrenSufferMentalHealthIssues, this.hasBeenSentitizedAboutGEPVision, this.isWillingToAllowGFAOnBoardWithChildren, this.areTutorsWillingToWorkWithGEPTeam, this.havePartnersOrAffiliations, this.contacts, this.handicaps, this.mainDropoutOrAcademicFailureReasons, this.biggestNeeds, this.typeOfAssistanceNeeded, this.testimonies, this.mentors, this.clubs, this.conflictWithTutorsReason, this.personWhoPrayedForChildren, this.hasTutorsBeenCollaborative, this.hasTutorsBeenUpToExpectations, this.canWeCountOnTutorsToPursueGEPActivities, this.wereThereSuggestionsForGEPByTutors, this.percentageOfResponse, this.materialsHandedToTutorsForKids, this.appreciatonsFromTutors, this.criticsFromTutors, this.logisticsHandedToStudents, this.affirmationForms, this.careerBrochures, this.kitchenRecipes, this.agendas, this.trainingContentUrls, this.books, this.selfDevelopmentmedias, this.commentsAboutHandicaps});

  factory Orphanage.fromDocument(DocumentSnapshot doc, Map data){
    return Orphanage(
      id: doc.id,
      photoUrl: data["photoUrl"],
      photos: data["photos"],
      name: data["name"], 
      region: data["region"], 
      gepState: data["GEP_State"],
      city: data["city"], 
      display: data["display"], 
      religion: data["religion"], 
      partners: data["partners"], 
      countryIsoCode: data["countryIsoCode"],
      countryPhoneCode: data["countryPhoneCode"],
      principalSourceOfFinance: data["principalSourceOfFinance"], 
      mostCommonDisease: data["mostCommonDisease"], 
      childrenStudySuccessDescription: data["childrenStudySuccessDescription"], 
      energySources: data["energySources"], 
      waterSources: data["waterSources"],
      nberTutors: data["nberTutors"], 
      nberChildren: data["nberChildren"], 
      nberMales: data["nberMales"], 
      nberFemales: data["nberFemales"], 
      orphanageBusinesses: data["orphanageBusinesses"], 
      childrenBusinesses: data["childrenBusinesses"], 
      nberChildrenAbove13: data["nberChildrenAbove13"], 
      nberChildrenBelow5: data["nberChildrenBelow5"], 
      nberScholarizedChildren: data["nberScholarizedChildren"], 
      nberChildrenAboveForm5: data["nberChildrenAboveForm5"], 
      averageNberChildrenPromotedToNextGrade: data["averageNberChildrenPromotedToNextGrade"], 
      averageNberChildrenRepeat: data["averageNberChildrenRepeat"], 
      averageNberChildrenDropout: data["averageNberChildrenDropout"],
      distanceToTown: data["distanceToTown"], 
      averageTimeToTown: data["averageTimeToTown"],
      dateCreated: data["dateCreated"]?.toDate(),
      doTheyRunOutOfFunds: data["doTheyRunOutOfFunds"], 
      abilityToFullySponsorPrimarySchoolStuds: data["abilityToFullySponsorPrimarySchoolStuds"], 
      abilityToFullySponsorSecondarySchoolStuds: data["abilityToFullySponsorSecondarySchoolStuds"], 
      abilityToFullySponsorAboveALevelStud: data["abilityToFullySponsorAboveALevelStud"], 
      haveChildrenAcknowledgedTheOrphanage: data["haveChildrenAcknowledgedTheOrphanage"], 
      areSomeChildrenIntoBusiness: data["areSomeChildrenIntoBusiness"], 
      doesOrphanageOwnABusiness: data["doesOrphanageOwnABusiness"], 
      doesChildrenSufferMentalHealthIssues: data["doesChildrenSufferMentalHealthIssues"], 
      hasBeenSentitizedAboutGEPVision: data["hasBeenSentitizedAboutGEPVision"], 
      isWillingToAllowGFAOnBoardWithChildren: data["isWillingToAllowGFAOnBoardWithChildren"], 
      areTutorsWillingToWorkWithGEPTeam: data["areTutorsWillingToWorkWithGEPTeam"], 
      havePartnersOrAffiliations: data["havePartnersOrAffiliations"],
      handicaps: data["handicaps"], 
      commentsAboutHandicaps: data["commentsAboutHandicaps"],
      mainDropoutOrAcademicFailureReasons: data["mainDropoutOrAcademicFailureReasons"], 
      biggestNeeds: data["biggestNeeds"],
      gpsCoords: data["gpsCoords"] is Map ? GPSCoords.fromMap(data["gpsCoords"]) : null,
      mentors: data["mentors"],
      children: data["children"],
      tutors: data["tutors"],
      nberChildrenRegistered: data["nberChildrenRegistered"],
      visits: data["visits"],
      donationTotalCost: data["donationTotalCost"],
      logisticTotalCost: data["logisticTotalCost"]
    );
  }

}

class Visit {
  final String? id, feastRestauName, chiefOrganiser, impressions;
  List? donations, donationPhotos, photosWithResources, photos, sessions, logistic, feastPhotos, tutorsMeetingPhotos, scannedReports, mainReasonsForFailure, mentors, tutors, children;
  final DateTime? dateCreated, startTime, endTime;
  int? donationsValue, visitDurationMinute, rank, donationTotalCost, logisticTotalCost, learningMaterialTotalCost, feastTotalCost;
  final bool? didEvangelizationTookPlace, wasSuccessful, wasFeastEffective, wasTutorsMeetingEffective;

  Visit({this.id,this.photosWithResources, this.photos, this.rank, this.donationPhotos, this.donationTotalCost, this.feastTotalCost, this.wasFeastEffective, this.wasTutorsMeetingEffective, this.learningMaterialTotalCost, this.logisticTotalCost, this.tutorsMeetingPhotos, this.children, this.impressions, this.mentors, this.tutors, this.scannedReports, this.feastRestauName, this.chiefOrganiser, this.donations, this.sessions, this.logistic, this.feastPhotos, this.mainReasonsForFailure, this.dateCreated, this.startTime, this.endTime, this.donationsValue, this.visitDurationMinute, this.didEvangelizationTookPlace, this.wasSuccessful});

  factory Visit.fromDocument(DocumentSnapshot doc, Map data) {
    return Visit(
      id: doc.id,
      mentors: data["mentors"], 
      tutors: data["tutors"], 
      children: data["children"],
      scannedReports: data["scannedReports"], 
      feastRestauName: data["feastRestauName"], 
      chiefOrganiser: data["chiefOrganiser"],
      donations: data["donations"], 
      sessions: data["sessions"], 
      logistic: data["logistic"], 
      mainReasonsForFailure: data["mainReasonsForFailure"],
      donationsValue: data["donationsValue"], 
      visitDurationMinute: data["visiteDurationMinute"],
      didEvangelizationTookPlace: data["didEvangelizationTookPlace"], 
      wasSuccessful: data["wasSuccessful"],
      wasFeastEffective: data["wasFeastEffective"],
      wasTutorsMeetingEffective: data["wasTutorsMeetingEffective"],
      rank: data["rank"],
      photos: data["photos"],
      donationPhotos: data["donationPhotos"], 
      feastPhotos: data["feastPhotos"], 
      tutorsMeetingPhotos: data["tutorsMeetingPhotos"], 
      impressions: data["impressions"],
      feastTotalCost: data["feastTotalCost"],
      donationTotalCost: data["donationTotalCost"],
      logisticTotalCost: data["logisticTotalCost"],
      learningMaterialTotalCost: data["learningMaterialTotalCost"],
      dateCreated: data['dateCreated']?.toDate(),
      startTime: data['startTime']?.toDate(),
      endTime: data['endTime']?.toDate()
    );
  }
}

class Resource {
  final String? id, visitId, orphId, blueprintId, logisticType, learningMaterialType, mediaType, reusability, name, format, author, type, url, description;
  final DateTime? dateCreated, visitDate;
  final List? photos, authors;
  final int? cost, qty, pages;
  final bool? wasDonated;

  Resource({this.id, this.visitId, this.orphId, this.blueprintId, this.logisticType, this.reusability, this.wasDonated, this.mediaType, this.name, this.learningMaterialType, this.format, this.qty, this.author, this.type, this.url, this.photos, this.authors, this.cost, this.pages, this.visitDate, this.dateCreated, this.description});

  factory Resource.fromDocument(DocumentSnapshot doc, Map data) {
    return Resource(
      id: doc.id,
      visitId: data["visitId"],
      orphId: data["orphId"],
      blueprintId: data["blueprintId"], 
      name: data["name"], 
      format: data["format"], 
      author: data["author"], 
      type: data["resource_type"], 
      url: data["url"], 
      description: data["description"], 
      authors: data["authors"], 
      cost: data["cost"], 
      pages: data["pages"], 
      photos: data["photos"],
      qty: data["quantity"],
      logisticType: data["logistic_type"],
      learningMaterialType: data["learning_material_type"],
      reusability: data["reusability"],
      mediaType: data["media_type"],
      wasDonated: data["wasLeftToChildren"],
      dateCreated: data['dateCreated']?.toDate(),
      visitDate: data['visitDate']?.toDate()
    );
  }
}

class Session {
  final String? id, type, title, commentOnStudentsResponsiveness;
  final List? tutors, photos, mentors, groupLeaders, resources, planning;
  final bool? didEachMentorReceiveAffirmationForm, didSessionHoldAsPlanned, wereStudentsResponsive;

  Session({this.id, this.type, this.title, this.commentOnStudentsResponsiveness, this.tutors, this.photos, this.mentors, this.groupLeaders, this.resources, this.planning, this.didEachMentorReceiveAffirmationForm, this.didSessionHoldAsPlanned, this.wereStudentsResponsive});

  factory Session.fromDocument(DocumentSnapshot doc, Map data) {
    return Session(
      id: doc.id,
      type: data["type"], 
      title: data["title"], 
      tutors: data["tutors"], 
      photos: data["photos"], 
      mentors: data["mentors"], 
      groupLeaders: data["groupLeaders"], 
      resources: data["resources"], 
      planning: data["planning"], 
      commentOnStudentsResponsiveness: data["commentOnStudentsResponsiveness"], 
      didEachMentorReceiveAffirmationForm: data["didEachMentorReceiveAffirmationForm"], 
      didSessionHoldAsPlanned: data["didSessionHoldAsPlanned"], 
      wereStudentsResponsive: data["wereStudentsResponsive"]
    );
  }
}

class OrphanageContact{
  final String? id, orphanageId, photoUrl, name, role, phoneNumber;
  final DateTime? dateCreated;
  OrphanageContact({this.name, this.role, this.phoneNumber, this.photoUrl, this.id, this.orphanageId, this.dateCreated});

  factory OrphanageContact.fromDocument(DocumentSnapshot doc, Map data) {
    return OrphanageContact(
      id: doc.id, 
      orphanageId: data['orphanageId'],
      photoUrl: data['photoUrl'],
      name: data['name'],
      role: data['role'],
      phoneNumber: data['phoneNumber'],
      dateCreated: data['dateCreated'] != null ? data['dateCreated'].toDate() : data['dateCreated']
    );
  }
  
  factory OrphanageContact.fromMap(Map<String, dynamic> map) {
    return OrphanageContact(
      id: map['id'], 
      orphanageId: map['orphanageId'],
      photoUrl: map['photoUrl'],
      name: map['name'],
      role: map['role'],
      phoneNumber: map['phoneNumber'],
      dateCreated: map['dateCreated']?.toDate()
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      //"id": id,
      "orphanageId": orphanageId,
      "photoUrl": photoUrl,
      "name": name,
      "role": role,
      "phoneNumber": phoneNumber,
      "dateCreated": dateCreated
    };
    return data;
  }
}

class Testimony {
  File? photoFile;
  String? id, name, orphanageId, photoUrl, grade, description;
  int? age;
  List? difficulties;
  DateTime? dateBirth, dateCreated;

  Testimony({this.photoUrl, this.photoFile, this.grade, this.age, this.description, this.name, this.difficulties, this.dateBirth, this.id, this.orphanageId, this.dateCreated});

  factory Testimony.fromDocument(DocumentSnapshot doc, Map data) {
    return Testimony(
      id: doc.id, 
      orphanageId: data['orphanageId'],
      photoUrl: data['photoUrl'],
      name: data['name'],
      grade: data['grade'],
      description: data['description'],
      age: data['age'],
      difficulties: data['difficulties'],
      dateCreated: data['dateCreated'] != null ? data['dateCreated'].toDate() : data['dateCreated'],
    );
  }
  
  factory Testimony.fromMap(Map<String, dynamic> map) {
    return Testimony(
      id: map['id'], 
      orphanageId: map['orphanageId'],
      photoUrl: map['photoUrl'],
      name: map['name'],
      grade: map['grade'],
      description: map['description'],
      age: map['age'],
      difficulties: map['difficulties'],
      dateCreated: map['dateCreated']?.toDate(),
    );
  }

  Map<String, dynamic>? toMap() {
    final Map<String, dynamic>? data = {
      "id": id,
      "orphanageId": orphanageId,
      "photoUrl": photoUrl,
      "name": name,
      "grade": grade,
      "age": age,
      "description": description,
      "difficulties": difficulties,
      "dateCreated": dateCreated
    };
    return data;
  }

}

class Clubs {
  final String id, name, description;
  final List? mentorsIds, activities;
  final DateTime dateCreated;

  Clubs(this.id, this.name, this.description, this.mentorsIds, this.activities, this.dateCreated);
}

class Books {
  final String id, name, authors, description, photoUrl;
  final DateTime dateCreated;

  Books(this.id, this.name, this.authors, this.photoUrl, this.description, this.dateCreated);
}

class Media {
  final String? id, name, authors, description, mediaUrl, type;   // type = "CHRISTIAN" "SELF-DEVELOPMENT"
  final DateTime? dateCreated;

  Media({this.id, this.name, this.authors, this.description, this.mediaUrl, this.type, this.dateCreated});
}

class GPSCoords {
  final double? lat;
  final double? lng;

  GPSCoords(this.lat, this.lng);

  factory GPSCoords.fromMap(Map<String, dynamic> map) {
    return GPSCoords(map['lat'], map['lng']);
  }

  Map<String, dynamic>? toMap() {
    final Map<String, dynamic>? data = lat != null && lng != null ? {
      "lat": lat,
      "lng": lng
    } : null;
    return data;
  }

}