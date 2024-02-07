import 'package:flutter/material.dart';

import '../models/orphanage_model.dart';

class VisitProvider with ChangeNotifier {

  Visit _visit;

  VisitProvider(this._visit);

  Visit get getVisit => _visit;

  void setVisit(Visit val){
    _visit = val;
    notifyListeners();
  }

  void removeMentor(String val){
    _visit.mentors != null ? _visit.mentors!.remove(val) : null;
    notifyListeners();
  }

  void removeTutor(String val){
    _visit.tutors != null ? _visit.tutors!.remove(val) : null;
    notifyListeners();
  }

  void removeChild(String val){
    _visit.children != null ? _visit.children!.remove(val) : null;
    notifyListeners();
  }

  void addMentor(String val){
    (_visit.mentors != null) ?  _visit.mentors!.add(val) : _visit.mentors = [val];
    notifyListeners();
  }

  void addTutor(String val){
    (_visit.tutors != null) ?  _visit.tutors!.add(val) : _visit.tutors = [val];
    notifyListeners();
  }

  void addChild(String val){
    (_visit.children != null) ?  _visit.children!.add(val) : _visit.children = [val];
    notifyListeners();
  }

  void addDonationCost(int val){
    _visit.donationTotalCost = (_visit.donationTotalCost != null) ? (_visit.donationTotalCost = _visit.donationTotalCost! + val) : val;
    notifyListeners();
  }

  void addLogisticCost(int val){
    _visit.logisticTotalCost = (_visit.logisticTotalCost != null) ? (_visit.logisticTotalCost = _visit.logisticTotalCost! + val) : val;
    notifyListeners();
  }

  void addLearningMaterialCost(int val){
    _visit.learningMaterialTotalCost = (_visit.learningMaterialTotalCost != null) ? (_visit.learningMaterialTotalCost = _visit.learningMaterialTotalCost! + val) : val;
    notifyListeners();
  }
}