import 'package:flutter/material.dart';
import 'package:videohub/core/models/user_model.dart';

class UserProvider with ChangeNotifier {

  UserModel? user;
  bool? isSignedIn;
  bool enableMentorEdit;
  bool enableChildEdit;
  bool enableTutorEdit;
  bool enableVisitEdit;
  
  UserProvider({this.isSignedIn, this.user, this.enableChildEdit = false, this.enableMentorEdit = false, this.enableTutorEdit = false, this.enableVisitEdit = false});

  bool? get getSignInState => isSignedIn;
  UserModel? get getUser => user;

  void setUserProfile(UserModel val){
    user = val;
    notifyListeners();
  }

  void destroyProfile(){
    user = null;
    notifyListeners();
  }

  void setSignInState(bool? val){
    if(val == null){
      isSignedIn = false;
    }
    else {
      isSignedIn = val;
    }  
    notifyListeners();
  }

  void editChild(bool val){
    enableChildEdit = val;
    notifyListeners();
  }

  void editMentor(bool val){
    enableMentorEdit = val;
    notifyListeners();
  }

  void editTutor(bool val){
    enableTutorEdit = val;
    notifyListeners();
  }

  void editVisit(bool val){
    enableVisitEdit = val;
    notifyListeners();
  }

}