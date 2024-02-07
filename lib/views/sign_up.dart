import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:videohub/components/custom_textbutton.dart';
import 'package:videohub/components/tool_box.dart';
import 'package:videohub/core/models/user_model.dart';
import 'package:videohub/core/providers/user_provider.dart';
import 'package:videohub/core/utils/colors.dart';

import '../core/providers/theme_provider.dart';
import '../core/utils/constants.dart';
import '../core/utils/size_config.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;
  File? _image;
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    UserProvider userProvider  = Provider.of<UserProvider>(context);
    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(icon: Icon(Iconsax.arrow_left_3, size: 30, color: themeProvider.isDark ? Colors.grey[00] : bgColorDark,), onPressed: (){context.pop();},),
          ),
          body: Column(
            children: [
              SizedBox(height: hv*8),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Hero(
                    tag: "logo",
                    child: CircleAvatar(
                      backgroundColor: primaryColor.withOpacity(0.2),
                      backgroundImage: _image != null ? FileImage(_image!) : null,
                      radius: 60,
                      child: _image == null ? const Icon(Iconsax.profile_tick, color: primaryColor, size: 75,) : Container(),
                    ), 
                  ),
                  Positioned(
                    bottom: 0,
                    right: -5,
                    child: IconButton(icon: const Icon(Iconsax.add_circle5, size: 40, color: primaryColor,), onPressed: (){ToolBox.getImageMenu(context: context, getFromGalleryAction: () async => _pickImage(isFromGallery: true), getFromCameraAction: () async => _pickImage(isFromGallery: false));})
                  )
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: wv*7),
                    child: Form(
                      key: _signUpFormKey,
                      child: Column(
                        children: [
                          SizedBox(height: hv*12),
                          Row(
                            children: [
                              const Spacer(),
                              Text("New Account", style: TextStyle(fontSize: 30, color: themeProvider.isDark ? Colors.grey[400]: Colors.grey[700], fontWeight: FontWeight.w400),),
                              const Spacer()
                            ],
                          ),
                          /*Row(
                            children: [
                              const Spacer(),
                              IconButton(onPressed: (){}, icon: Icon(Iconsax.google, color: Colors.blue,)),
                              IconButton(onPressed: (){}, icon: Icon(Icons.facebook_rounded, color: Colors.blue,)),
                              const Spacer(),
                            ],
                          ),*/
                          SizedBox(height: hv*4),
                          TextFormField(
                            controller: _nameController,
                            validator: (String? val) => (val!.isEmpty) ? "This field is required.." : null,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Iconsax.user_cirlce_add),
                              hintText: "User name..",
                            ),
                          ),
                          SizedBox(height: hv*3,),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (String? val) => emailRegExp.hasMatch(val.toString()) ? null : "invalid email address..",
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Iconsax.sms),
                              hintText: "Email Address",
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
                          SizedBox(height: hv*5.7,),
                        ],
                      )
                    ),
                  ),
                ),
              ),
              CustomTextButton(
                text: "Create account", 
                expand: true, 
                padding: EdgeInsets.symmetric(horizontal: wv*7, vertical: 10),
                action: () async {
                  if(_signUpFormKey.currentState!.validate()){
                    UserModel _userModel = UserModel(username: _nameController.text, email: _emailController.text);
                    setState(() {_isLoading = true;});
                    try {
                      await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      ).then((credential) async  {
                        ToolBox.showMsg(context: context, text: "Account created.");
                        if(_image != null){
                          String? fileName = _emailController.text;
                          Reference storageReference = FirebaseStorage.instance.ref().child('photos/profiles/$fileName');
                          final metadata = SettableMetadata(contentType: 'image/jpeg', customMetadata: {'picked-file-path': _image!.path});
                          UploadTask storageUploadTask = (kIsWeb) ? storageReference.putData(_image!.readAsBytesSync(), metadata) : storageReference.putFile(_image!, metadata);
                          //storageUploadTask = storageReference.putFile(imageFileAvatar!);
                          // ignore: body_might_complete_normally_catch_error
                          storageUploadTask.catchError((e){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                          });
                          await storageUploadTask.whenComplete(() async {
                            ToolBox.showMsg(context: context, text: "Profile picture added.");
                            String url = await storageReference.getDownloadURL();
                            _userModel.setPhotoUrl(url);
                            print("download url: $url");
                          });
                        }
                        await FirebaseFirestore.instance.collection("USERS").doc(credential.user!.uid).set({
                          "username" : _userModel.username,
                          "photoUrl": _userModel.photoUrl,
                          "email": _userModel.email,
                          "dateCreated": DateTime.now(),
                        }).then((value) {
                          setState(() {_isLoading = false; });
                          userProvider.setUserProfile(_userModel);
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
                      print(e);
                    }
                  }
                }
              ),
              SizedBox(height: hv*1,),
              Row(
                children: [
                  const Spacer(),
                  Text("Already have an account? ",),
                  InkWell(
                    onTap: (){context.pop();},
                    child: Text("Sign In", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),),
                  ),
                  const Spacer(),
                ],
              ),
              SizedBox(height: hv*2,)
            ],
          ),
        ),
        ToolBox.getloadingPage(context: context, showPage: _isLoading)
      ],
    );
  }
  _pickImage({bool isFromGallery = true}) async {
    final pickedFile = await ImagePicker().pickImage(source: isFromGallery ? ImageSource.gallery : ImageSource.camera, imageQuality: 70);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        //uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }
}