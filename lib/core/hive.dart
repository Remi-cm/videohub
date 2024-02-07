import 'package:hive/hive.dart';

import 'utils/constants.dart';

class HiveDatabase {


  //Setters

  static setSignInState(bool? val) async {
    Box authBox = await Hive.openBox(authBoxLabel);
    if(val is! bool){
      authBox.put('isSignedIn', false);
    }
    authBox.put('isSignedIn', val);
  }

  static setFirstInstallState(bool? val) async {
    Box authBox = await Hive.openBox(authBoxLabel);
    if(val is! bool){
      authBox.put(isFistInstallKey, false);
    }
    authBox.put(isFistInstallKey, val);
  }

  static setRegisterState(bool? val) async {
    Box authBox = await Hive.openBox(authBoxLabel);
    /*if(val == null){
      authBox.put('isRegistered', false);
    }*/
    authBox.put('isRegistered', val);
  }

  static setTheme(bool val) async {
    Box themeBox = await Hive.openBox(themeBoxLabel);
    themeBox.put('isDark', val);
  }

  static setLanguage(String val) async {
    Box languageBox = await Hive.openBox(languageBoxLabel);
    languageBox.put('locale', val);
  }


  //Getters

  static Future<String> getlanguage() async {
    Box languageBox = await Hive.openBox(languageBoxLabel);
    return languageBox.get('locale');
  }
  
  static Future<bool> getSignInState() async {
    Box authBox = await Hive.openBox(authBoxLabel);
    return authBox.get('isSignedIn') ?? false;
  }
  static Future<bool?> getRegisterState() async {
    Box authBox = await Hive.openBox(authBoxLabel);
    return authBox.get('isRegistered');
  }
  static Future<bool> getIsFirstInstallState() async {
    Box authBox = await Hive.openBox(authBoxLabel);
    return authBox.get(isFistInstallKey) ?? true;
  }
  static Future<bool> getTheme() async {
    Box themeBox = await Hive.openBox(themeBoxLabel);
    return themeBox.get('isDark') ?? false;
  }

  
}