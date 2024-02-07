import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:videohub/core/utils/colors.dart';

import '../components/tool_box.dart';
import '../core/models/user_model.dart';
import '../core/providers/theme_provider.dart';
import '../core/providers/user_provider.dart';
import '../core/utils/constants.dart';
import '../core/utils/size_config.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    UserProvider userProvider  = Provider.of<UserProvider>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(icon: Icon(Iconsax.arrow_left_3, size: 30, color: themeProvider.isDark ? Colors.grey[00] : bgColorDark,), onPressed: (){context.pop();},),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Hero(child: Icon(Iconsax.play_circle, size: 150,), tag: "logo",),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: wv*7, vertical: hv*2),
                color: themeProvider.isDark ? bgColorDark : bgColor,
                child: Form(
                  key: _signInFormKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          Text("Sign In", style: TextStyle(fontSize: 40, color: themeProvider.isDark ? Colors.grey[400]: Colors.grey[800], fontWeight: FontWeight.w400),),
                          const Spacer()
                        ],
                      ),
                      SizedBox(height: hv*4),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (String? val) => emailRegExp.hasMatch(val.toString()) ? null : "invalid email address..",
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.sms),
                          hintText: "Email address",
                        ),
                      ),
                      SizedBox(height: hv*3,),
                      TextFormField(
                        controller: _passwordController,
                        validator: (String? val) => (val!.length < 6) ? "Password must have at least 6 characters.." : null,
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.lock),
                          hintText: "Password",
                          suffixIcon: IconButton(onPressed: ()=>setState((){_showPassword = !_showPassword;}), icon: Icon(_showPassword ? Iconsax.eye : Iconsax.eye_slash))
                        ),
                      ),
                      SizedBox(height: hv*5,),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          child: Text("Sign In", style: TextStyle(color: themeProvider.isDark ? Colors.grey[800] : whiteColor),),
                          onPressed: () async {
                            if(_signInFormKey.currentState!.validate()){
                              setState(() {_isLoading = true;});
                              try {
                                await FirebaseAuth.instance.signInWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                ).then((credential) async  {
                                  await FirebaseFirestore.instance.collection("USERS").doc(credential.user!.uid).get().then((doc) {
                                    UserModel _userModel = UserModel.fromDocument(doc, doc.data() as Map);
                                    print(_userModel.email);
                                    ToolBox.showMsg(context: context, text: "Account signed in: ${_userModel.email.toString()}");
                                    userProvider.setUserProfile(_userModel);
                                    setState(() {_isLoading = false; });
                                    context.go("/home");
                                  });
                                });
                              } on FirebaseAuthException catch (e) {
                                setState(() {_isLoading = false;});
                                if (e.code == 'weak-password') {
                                  ToolBox.showMsg(context: context, text: "The password provided is too weak.");
                                } else if (e.code == 'email-already-in-use') {
                                  ToolBox.showMsg(context: context, text: "The account already exists for that email.");
                                }
                              } catch (e) {
                                setState(() {_isLoading = false;});
                                ToolBox.showMsg(context: context, text: "Error: $e");
                                print(e);
                              }
                            }
                          }
                        ),
                      ),
                      SizedBox(height: hv*3,),
                      Row(
                        children: [
                          const Spacer(),
                          Text("New in the app? ",),
                          InkWell(
                            onTap: (){context.push('/sign-up');},
                            child: Text("Create an account", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),),
                          ),
                          const Spacer(),
                        ],
                      )
                    ],
                  )
                ),
              )
            ],
          ),
        ),
        ToolBox.getloadingPage(context: context, showPage: _isLoading)
      ],
    );
  }
}