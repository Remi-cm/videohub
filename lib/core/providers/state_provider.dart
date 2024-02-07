import 'package:flutter/material.dart';

class StateProvider with ChangeNotifier {
  String? visitId;
  String? searchedName;

  StateProvider({this.visitId, this.searchedName});

  String? get getVisitId => visitId;
  String? get getSearchedName => searchedName;

  void setVisitId(String val){
    visitId = val;
    notifyListeners();
  }

  void setSearchedName(String val){
    searchedName = val;
    notifyListeners();
  }
}