import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {

  bool _isSignedIn;
  
  AuthProvider(this._isSignedIn);

  bool get getSignInState => _isSignedIn;

  void getAuthStateHive() async {}

  void setSignInState(bool? val){
    if(val == null){
      _isSignedIn = false;
    }
    else {
      _isSignedIn = val;
    }
    
    notifyListeners();
  }

}