// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../components/tool_box.dart';
import '../core/hive.dart';
import '../core/models/user_model.dart';
import '../core/providers/theme_provider.dart';
import '../core/providers/user_provider.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    initApp();
    super.initState();
  }
  initApp() async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    //bool isSignedIn = await HiveDatabase.getSignInState();
    bool isFirstInstall = await HiveDatabase.getIsFirstInstallState();
    bool themeHive = await HiveDatabase.getTheme();
    bool isSignedIn = FirebaseAuth.instance.currentUser != null;

    print("Is Signed In ?: "+ isSignedIn.toString());
    userProvider.setSignInState(isSignedIn);
    themeProvider.setTheme(themeHive);

    if(isSignedIn == true){
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection("USERS").doc(userId).get().then((doc) {
        if(doc.exists){
          UserModel userModel = UserModel.fromDocument(doc, doc.data() as Map);
          ToolBox.showMsg(context: context, text: "Account signed in: ${userModel.email.toString()}");
          userProvider.setUserProfile(userModel);
          context.go('/home');
        }
        else {
          context.go('/sign-in');
        }
      });
    }
    else {
      await Future.delayed(const Duration(seconds: 1));
      context.go('/sign-in');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Icon(Iconsax.video, size: 200,),
      ),
    );
  }
}