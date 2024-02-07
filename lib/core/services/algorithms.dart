import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:videohub/core/services/server.dart';
import 'package:videohub/core/utils/constants.dart';
import 'package:videohub/core/utils/size_config.dart';

import '../../components/tool_box.dart';

class Algorithms { 

  static Future<File?> getImage({required BuildContext context}) async {
    File? file;
    await showModalBottomSheet(
      context: context, 
      builder: (BuildContext bc){
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Gallery"),
                  onTap: () async {
                    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery, maxDuration: const Duration(seconds: 10));
                    file = pickedFile?.path != null ? File(pickedFile!.path) : null;
                    if(context.mounted) context.pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text("Camera"),
                onTap: () async {
                    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.camera);
                    file = pickedFile?.path != null ? File(pickedFile!.path) : null;
                    if(context.mounted) context.pop();
                },
              ),
            ],
          ),
        );
      }
    );
    return file;
  }

  static showCustomBottomSheet({required BuildContext context, required Widget child, double? minHeight, double? maxHeight}){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(minHeight: minHeight ?? hv*60, maxHeight: maxHeight ?? hv*100),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context){
        return child;
      }
    );
  }

  static Future<List<StateModel>> getStates(String? countryISO) async {
    List<StateModel> _states = [];
    String iso = countryISO ?? 'cm';
    var response = await Server().getStates(iso);
    if(response["code"] == 200){
      List statesJson = response['result'];
      for(int i=0; i<statesJson.length; i++){
        _states.add(StateModel(name: statesJson[i]['value'], key: statesJson[i]['key']));
      }
    }
    return _states;
  }

  static Future<List<CityModel>> getCities(String state) async {
    var response = await Server().getCities(state);
    List<CityModel> _cities = [];
    List citiesJson = [];
    if(response["code"] == 200){
      citiesJson = response['result'];
      for(int i=0; i<citiesJson.length; i++){
        _cities.add(CityModel(name: citiesJson[i]['value'], key: citiesJson[i]['key']));
      }
    }
    return _cities;
  }
  
  static String? getStateNameFromStateList({required String key, required  List<StateModel> states}) {
    String? _stateName;
    for(int i=0; i<states.length; i++){
      if(states[i].key == key){
        _stateName = states[i].name!;
      }
    }
    return _stateName;
  }

  static String? getCityNameFromCityList({required String key, required List<CityModel> cities}) {
    String? _cityName;
    for(int i=0; i<cities.length; i++){
      if(cities[i].key == key){
        _cityName = cities[i].name!;
      }
    }
    return _cityName;
  }

  static List getKeyWords(String input) {
    List getKeys(String input) {
      var keyWords = List.filled(input.length, "", growable: true);
      for (int i = 0; i < input.length; i++) {
        keyWords[i] = input.substring(0, i + 1).toLowerCase();
      }
      return keyWords;
    }

    List getKeysReversed(String input) {
      var keyWords = List.filled(input.length, "", growable: true);
      for (int i = 0; i < input.length; i++) {
        keyWords[i] =
            input.substring(0, i + 1).toLowerCase().split('').reversed.join('');
      }
      return keyWords;
    }

    var results = [];
    String inputReversed = input.split('').reversed.join('');
    var words = input.toLowerCase().split(RegExp('\\s+'));
    var wordsReversed = inputReversed.toLowerCase().split(RegExp('\\s+'));
    words.add(input);
    wordsReversed.add(inputReversed);

    for (int i = 0; i < words.length; i++) {
      results = results + getKeys(words[i]);
    }
    for (int i = 0; i < words.length; i++) {
      results = results + getKeysReversed(wordsReversed[i]);
    }

    results = results + getKeys(input);
    results = results.toSet().toList();

    return results;
  }

  static pickImage({required BuildContext context, bool isFromGallery = true, bool isFile = false, required Function(String url) action, required Function(File) fileAction, required Function() startLoadingAction, required Function() stopLoadingAction, required String path, required String name, required DocumentReference doc, required String keyName}) async {
    final pickedFile = await ImagePicker().pickImage(source: isFromGallery ? ImageSource.gallery : ImageSource.camera, imageQuality: 70);

    if (pickedFile != null) {
      isFile ? debugPrint("") : startLoadingAction();
      if(!isFile){ 
        String? fileName = name;
        Reference storageReference = FirebaseStorage.instance.ref().child('$path$fileName');
        final metadata = SettableMetadata(contentType: 'image/jpeg', customMetadata: {'picked-file-path': File(pickedFile.path).path});
        UploadTask storageUploadTask = (kIsWeb) ? storageReference.putData(File(pickedFile.path).readAsBytesSync(), metadata) : storageReference.putFile(File(pickedFile.path), metadata);
        storageUploadTask.catchError((e){
          stopLoadingAction();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
          return e;
        });
        await storageUploadTask.whenComplete(() async {
          ToolBox.showMsg(context: context, text: "Photo added!");
          String url = await storageReference.getDownloadURL();
          await doc.update({keyName: FieldValue.arrayUnion([url])});
          action(url);
          stopLoadingAction();
          debugPrint("download url: $url");
        });
      }
      else {
        fileAction(File(pickedFile.path));
      }
    } else {
      debugPrint('No image selected.');
    }
  }

  static deleteImage({required BuildContext context, String? url, File? file, bool isFile = false, required Function() startLoadingAction, required Function() stopLoadingAction, required Function(String url) action, required Function(File file) fileAction, required DocumentReference doc, required String keyName}) async {
    isFile ? debugPrint("") : startLoadingAction();
    try {
      if(!isFile){
        await doc.update({keyName: FieldValue.arrayRemove([url])}).then((v) async {
          action(url!);
          await FirebaseStorage.instance.refFromURL(url).delete().then((v) => ToolBox.showMsg(context: context, text: "Photo deleted.."));
          stopLoadingAction();
        });
      }
      else {
        fileAction(file!);
      }
    }
    catch(e){
      stopLoadingAction();
      ToolBox.showMsg(context: context, text: "Sorry, an error occured, try later..");
      debugPrint(e.toString());

    }
  }

  
  
  static digitInputOperation ({required TextEditingController controller, required bool isAddition}){
    int? value = int.tryParse(controller.text);
    if(value != null){
      String minus = value > 0 ? (value - 1).toString() : "0";
      String plus = (value + 1).toString();
      controller.text = isAddition ? plus : minus;
    }
    else {
      if(isAddition){
        controller.text = "1";
      }
    }
  }




}

//END CLASS

String computeAge(DateTime dob) {
  DateTime now = DateTime.now();
  final year = now.year - dob.year;
  final mth = now.month - dob.month;
  final days = now.day - dob.day;
  if(mth < 0){
    return "Aura $year ans cette année";
  }
  else {
    return('$year ans');
  }
}

String getGradeLabelFromKey({required String key, String lang = "fr"}){
  String res = "None";
  for(int i = 0; i < gradesList.length; i++){
    if(gradesList[i].key == key){
      res = gradesList[i].abbrev ?? (lang == "fr" ? gradesList[i].fr : gradesList[i].en);
    }
  }
  return res;
}

class StateModel {
  final String? name;
  final String? key;

  StateModel({this.name, this.key});
}

class CityModel {
  final String? name;
  final String? key;

  CityModel({this.name, this.key});
}

extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    }
    List getKeyWords() {
      return Algorithms.getKeyWords(this);
    }
}

extension ListExtension on List {
    void addOnce(String val) {
      contains(val) ? debugPrint("No add") : add(val);
    }
}

extension DateExtension on DateTime {
  String getFormattedDate1(){
    return (DateFormat('MMMM', 'fr_FR').format(this).substring(0,3)+" "+ year.toString()).capitalize();
  }
  String getFormattedDate2(){
    return (day.toString().padLeft(2, '0') + " "+DateFormat('MMMM', 'en_US').format(this)+" "+ year.toString()).capitalize();
  }
  String getFormattedDate3(){
    return (day.toString().padLeft(2, '0') + "/"+month.toString().padLeft(2, '0')+"/"+ year.toString());
  }
  int getAgeFromDate(){
    return ((DateTime.now().difference(this).inDays)/365).floor();
  }
  String getAgeStringFromDate(){
    return computeAge(this);
  }
  DateTime getSameDateAt24Hours(){
    return DateTime(year, month, day, 23, 59);
  }
  bool isAtSameDayAs(DateTime date){
    return DateTime(year, month, day).isAtSameMomentAs(DateTime(date.year, date.month, date.day));
  }
  DateTime mergeWithTime(TimeOfDay time){
    return DateTime(year, month, day, time.hour, time.minute);
  }
}

extension IntExtension on int {
  String getLiteralForm(bool isEnglish){
    String res = "EXTRA";
    switch (this) {
      case 1: res = isEnglish ? "ONE" : "UNE"; break;
      case 2: res = isEnglish ? "TWO" : "DEUX"; break;
      case 3: res = isEnglish ? "THREE" : "TROIS"; break;
      case 4: res = isEnglish ? "FOUR" : "QUATRE"; break;
      case 5: res = isEnglish ? "FIVE" : "CINQ"; break;
      case 6: res = isEnglish ? "SIX" : "SIX"; break;
    }
    return res;
  }
  String getStringCustomized(){
    return this < 10 ? toString().padLeft(2, '0') : toString();
  }
  String getNumberFormat(){
    return NumberFormat("#,##0.00", "en_US").format(this);
  }
}