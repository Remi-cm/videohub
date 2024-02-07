import 'dart:developer';
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:videohub/core/models/video_model.dart';
import 'package:videohub/core/services/algorithms.dart';
import 'package:videohub/views/video.dart';

import '../../components/custom_textbutton.dart';
import '../../components/custom_textfield.dart';
import '../../components/tool_box.dart';
import '../../core/models/orphanage_model.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/providers/visit_provider.dart';
import '../../core/utils/colors.dart';
import '../../core/utils/size_config.dart';

class UploadVideoForm extends StatefulWidget {
  final Function()? onSent;
  const UploadVideoForm({Key? key, this.onSent}) : super(key: key);

  @override
  State<UploadVideoForm> createState() => _UploadVideoFormState();
}

class _UploadVideoFormState extends State<UploadVideoForm> {
  
  VideoPlayerController videoController = VideoPlayerController.networkUrl(Uri.parse("//"));
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _authorNameController = TextEditingController();

  List _authorNames = [];

  Visit? _visit;
  Orphanage? _orph;
  bool _isLoading = false;
  bool _edit = true;
  
  String? _mediaType;
  String? _mediaUrl;

  File? videoFile;
  Uint8List? thumbnail;
  String? thumbnailUrl;
  String? thumbnailPath;

  @override
  void initState() {
    super.initState();
  }

  Future<Uint8List?> generateThumbnail(File file) async {
    final thumbnail = await VideoThumbnail.thumbnailData(
      video: file.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 320,
      quality: 50
    );
    return thumbnail;
  }

  

  Future<String?> generateThumbnailFromUrl(String url) async {
    debugPrint("Medial url: $url");
    final thumbnail = await VideoThumbnail.thumbnailFile(
      video: url,
      imageFormat: ImageFormat.WEBP,
      maxWidth: 75,
      quality: 75
    );
    return thumbnail;
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    bool isDark = themeProvider.isDark;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("Upload Video"),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            
                            SizedBox(height: hv*3,),
                              
                            SizedBox(height: _edit ? hv*2 : 5,),

                            CustomTextField(
                              hintText: "Title",
                              enable: _edit,
                              icon: Iconsax.gift,
                              controller: _nameController, 
                              keyboardType: TextInputType.name,
                              onChanged: (val)=>setState((){}),
                              suffixAction: (){}
                            ),
                            const SizedBox(height: 20,),
                            CustomTextField(
                              hintText: "Description",
                              minLines: 1,
                              maxLines: 3,
                              enable: _edit,
                              icon: Iconsax.gift,
                              controller: _descriptionController, 
                              keyboardType: TextInputType.text,
                              onChanged: (val)=>setState((){}),
                              suffixAction: (){}
                            ),
                            const SizedBox(height: 30,),

                            ToolBox.getUploadMediaTile(
                              context: context,
                              url: _mediaUrl,
                              type: _mediaType,
                              file: videoFile,
                              isDark: isDark,
                              thumbnail: thumbnail,
                              thumbnailPath: thumbnailPath,
                              copyAction: () async => _mediaUrl != null ? () async {
                                await Clipboard.setData(ClipboardData(text: _mediaUrl!));
                                setState(() {_isLoading = true;});
                                debugPrint("Loading video from link");
                                String? filePath = await generateThumbnailFromUrl(_mediaUrl!);
                                if(filePath != null){
                                  setState(() {videoFile = File(filePath);});
                                } else {
                                  ToolBox.showMsg(context: context, text: "Sorry, link source incompatible");
                                }
                                setState(() {_isLoading = false;});
                              } 
                              : ToolBox.showMsg(context: context, text: "No Link to copy"), 
                              pasteAction: _getClipboardText, 
                              uploadAction: () async {
                                videoFile = await Algorithms.getImage(context: context);
                                if(videoFile != null){
                                  thumbnailPath = await generateThumbnailFromUrl(videoFile!.path);
                                }
                                setState(() {});
                              }
                            ),
                            SizedBox(height: hv*5,),
                            
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CustomTextButton(
                text: "Confirm",
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                expand: true,
                isVisible: _edit,
                enable: _nameController.text.isNotEmpty && (videoFile != null || _mediaUrl != null),
                action: () async {
                  if(_authorNames.isEmpty && _authorNameController.text.isNotEmpty){_authorNames.add(_authorNameController.text);}
                  setState(() {_isLoading = true;});
                  try {
                    DocumentReference docRef = FirebaseFirestore.instance.collection("VIDEOS").doc();
                    if (videoFile != null) {
                      String? fileName = "Video_${DateTime.now().toString()}";
                      Reference storageReference = FirebaseStorage.instance.ref().child('Videos/${docRef.id}/$fileName');
                      debugPrint("Video path: ${videoFile?.path}");
                      final metadata = SettableMetadata(contentType: "video/mp4", customMetadata: {'picked-file-path': videoFile!.path});
                      UploadTask storageUploadTask = (kIsWeb) ? storageReference.putData(videoFile!.readAsBytesSync(), metadata) : storageReference.putFile(videoFile!, metadata);
                      storageUploadTask.catchError((e){
                        setState(() {_isLoading = false;});
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                        return e;
                      });
                      await storageUploadTask.whenComplete(() async {
                        ToolBox.showMsg(context: context, text: "Video added!");
                        _mediaUrl = await storageReference.getDownloadURL();
                        setState(() {_isLoading = false;});
                        debugPrint("download url: $_mediaUrl");
                      });
                    }

                    if(thumbnail != null || thumbnailPath != null){
                      debugPrint("Uploading thumbnail path: $thumbnailPath");
                      String? fileName = "Thumbnail_${DateTime.now().toString()}";
                      File tf = thumbnail != null ? File.fromRawPath(thumbnail!) : File(thumbnailPath!);
                      debugPrint("Thumbnail File: ${tf.path}");
                      setState(() {_isLoading = true;});
                      Reference storageReference1 = FirebaseStorage.instance.ref().child('Videos/${docRef.id}/$fileName');
                      final metadata = SettableMetadata(contentType: "image/jpeg", customMetadata: {'picked-file-path': tf.path});
                      UploadTask storageUploadTask = (kIsWeb) ? storageReference1.putData(tf.readAsBytesSync(), metadata) : storageReference1.putFile(tf, metadata);
                      storageUploadTask.catchError((e){
                        setState(() {_isLoading = false;});
                        debugPrint("Thumbnail upload error: $e");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                        return e;
                      });
                      await storageUploadTask.whenComplete(() async {
                        thumbnailUrl = await storageReference1.getDownloadURL();
                        setState(() {_isLoading = false;});
                        debugPrint("thumb download url: $thumbnailUrl");
                      });
                    }

                    debugPrint("Thumbnail uploaded");

                    docRef.set({
                      "id": docRef.id,
                      "url": _mediaUrl,
                      "dateCreated": DateTime.now(),
                      "name": _nameController.text,
                      "description": _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
                      "thumbnailUrl": thumbnailUrl,
                    }).then((v) {
                      widget.onSent!();
                    });
                  }
                  catch(e){
                    setState(() {_isLoading = false;});
                    ToolBox.showMsg(context: context, text: "Error: $e");
                    debugPrint("$e");
                    return e;
                  }
                }
              )
            ],
          ),
        ),
        ToolBox.getloadingPage(context: context, showPage: _isLoading)
      ],
    );
  }

  void _getClipboardText() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    setState(() {
      
    });
    if(clipboardData?.text != null){
      bool isValid = await _checkIfUrlIsValid(url: clipboardData!.text!);
      if(isValid){
        setState(() {
          _mediaUrl = clipboardData.text!;
        });
        // Algorithms.showCustomBottomSheet(context: context, maxHeight: hv*70, child: VideoView(video: VideoModel(name: _nameController.text, url: _mediaUrl)));
        setState(() {_isLoading = true;});
        debugPrint("Loading video from link");
        String? filePath = await generateThumbnailFromUrl(clipboardData.text!);
        if(filePath != null){
          setState(() {thumbnailPath = filePath; videoFile = null; _mediaUrl = clipboardData.text!;});
        } else {
          ToolBox.showMsg(context: context, text: "Sorry, link source incompatible");
        }
        setState(() {_isLoading = false;});      

        // videoController = VideoPlayerController.networkUrl(Uri.parse(clipboardData.text!))
        // ..initialize().then((_) {
        //   // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        //   setState(() {});
        // });               
      }
      else {
        ToolBox.showMsg(context: context, text: "Not a valid Url");
      }
    }
    else {ToolBox.showMsg(context: context, text: "Text is not a valid URL");}
  }

  Future<bool> _checkIfUrlIsValid({required String url}) async {
    Uri? uri = Uri.tryParse(url);
     String pattern = r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)';
     RegExp regExp = RegExp(pattern);
    debugPrint("Testing validity of: $url");
    if(uri != null){
      if (regExp.hasMatch(url)) {
        return true;
      }
      else {
        debugPrint("can't launch");
        inspect(uri);
      }
      return false;
    }
    else {
      debugPrint("Uri not parsed");
      return false;
    }
  }


}