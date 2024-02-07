import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:videohub/core/models/video_model.dart';
import 'package:videohub/core/services/algorithms.dart';
import 'package:videohub/views/video.dart';

import '../core/models/actor_model.dart';
import '../core/models/full_screen_image_model.dart';
import '../core/models/orphanage_model.dart';
import '../core/providers/theme_provider.dart';
import '../core/utils/colors.dart';
import '../core/utils/size_config.dart';
import 'custom_textbutton.dart';

class ToolBox {

  static void showMsg({required BuildContext context, required String text, int? duration}){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), duration: Duration(seconds: duration ?? 5),));
  }

  static Widget countryPickerDialog({required Function(Country) onPicked, required BuildContext context}){
    return SizedBox(
      width: ScreenSize.isSmartphone() ? wv*100 : 500,
      child: CountryPickerDialog(
        titlePadding: const EdgeInsets.all(15.0),
        searchCursorColor: Theme.of(context).primaryColor,
        searchInputDecoration: const InputDecoration(
            hintText: "Search",
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0)
        ),
        isSearchable: true,
        title: const Text("Select_Country"),
        onValuePicked: onPicked,
        priorityList: [
          CountryPickerUtils.getCountryByPhoneCode('237'),
          CountryPickerUtils.getCountryByPhoneCode('225'),
          CountryPickerUtils.getCountryByPhoneCode('234'),
        ],
        itemBuilder: buildCountryDialogItem
      ),
    );
  }

  static Widget buildCountryDialogItem(Country country) {
    return Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        const SizedBox(width: 8.0),
        Text("+${country.phoneCode}", style: const TextStyle()),
        const SizedBox(width: 8.0),
        Flexible(child: Text(country.name, style: const TextStyle(),))
      ],
    );
  }

  static void getImageMenu({required BuildContext context, required Function() getFromGalleryAction, required Function() getFromCameraAction}){
    showModalBottomSheet(
      context: context, 
      builder: (BuildContext bc){
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Gallery"),
                  onTap: () {
                    getFromGalleryAction();
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text("Camera"),
                onTap: () {
                  getFromCameraAction();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    );
  }

  static Widget getloadingPage({required BuildContext context, bool showPage = false}){
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return showPage ? BackdropFilter(
      filter:  ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        color: themeProvider.isDark ? Colors.grey[800]!.withOpacity(0.5) : whiteColor.withOpacity(0.5),
        width: wv*100,
        height: hv*100,
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 6,),
        ),
      ),
    ) 
    : 
    Container();
  }

  static Widget getTestimonyCard({required Testimony testimony, bool enable = true, Function()? onCancelAction}){
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        Container(
          height: 140,
          padding: EdgeInsets.symmetric(horizontal: wv*2, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(15)
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: testimony.photoFile != null || testimony.photoUrl != null ? 
                    CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      backgroundImage: testimony.photoFile != null ? FileImage(testimony.photoFile!) : FastCachedImageProvider(testimony.photoUrl!) as ImageProvider, radius: 25) 
                    : const Icon(Iconsax.profile_circle5, size: 50, color: primaryColor,),
                ),                    
                SizedBox(width: wv*2,),
                Container(
                  constraints: BoxConstraints(maxWidth: wv*50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Name: ${testimony.name}"),
                      Text("Grade: ${testimony.grade}"),
                      Text("Age: ${testimony.age}"),
                      const Text("Difficulties:"),
                      testimony.difficulties!.isNotEmpty ? bulletList(
                        children: testimony.difficulties!
                      ) : const Text("None"),
                      /*difficulties.isNotEmpty ? Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.only(right: 0, top: 0, bottom: 0),
                            visualDensity: VisualDensity(horizontal: -4, vertical: -3),
                            leading: Icon(Iconsax.direct_right5, size: 17,),
                            title: Text(difficulties[0]),
                          )
                          ],
                      ) : Container()*/
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        enable ? IconButton(onPressed: onCancelAction, icon: const Icon(Iconsax.close_circle)) : Container(),
      ],
    );
  }
  static Widget getContactCard({required String name, required String number, bool enable = true, required String role, Function()? onCancelAction}){
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: wv*2, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(15)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Icon(Iconsax.user_tag, size: 45, color: Colors.grey,),
              ),
              SizedBox(width: wv*2,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Name: $name"),
                  Text("Number: $number"),
                  Text("Role: $role")
                ],
              )
            ],
          ),
        ),
        enable ? IconButton(onPressed: onCancelAction, icon: const Icon(Iconsax.close_circle)) : Container(),
      ],
    );
  }

  static Widget bulletList({required List children}){
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children.map((str) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '\u2022',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.55,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    str,
                    textAlign: TextAlign.left,
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.55,
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  static Widget getMiniCustomListTile({required String title, bool enable = true, bool underline = false, required Function() action}){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Icon(Iconsax.arrow_circle_right, color: primaryColor, size: enable ? 28 : 22,),
              const SizedBox(width: 10,),
              Expanded(child: Text(title)),
              enable ? IconButton(onPressed: action, icon: Icon(Iconsax.close_square, size: 17, color: Colors.grey[600],), padding: EdgeInsets.zero, constraints: BoxConstraints.loose(const Size(20,20)),) : Container()
            ],
          ),
        ),
        underline ? Divider(height: 0, color:Colors.grey[400]) : Container()
      ],
    );
  }

  static Widget getPersonTile({required bool isDark, required Actor person, bool showButton = true, bool buttonIsLoading = false, Color color = primaryColor, IconData? icon, String? buttonText, required Function() buttonAction, bool alternate = false, Function()? alternativeAction, required Function() action}){
    return Column(
      children: [
        InkWell(
          onTap: action,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                  backgroundImage:  person.photoUrl == null ? null : FastCachedImageProvider(person.photoUrl!),
                  child: person.photoUrl == null ? Icon(Iconsax.user, color: Colors.grey[100],) : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(person.name.toString(), style: const TextStyle(fontWeight: FontWeight.w600),),
                      Text(person.email ?? (person.fullPhoneNumber ?? person.id.toString()), style: const TextStyle(fontSize: 14, color: Colors.grey),),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                showButton ? CustomIconTextButton(text: buttonText ?? (alternate ? "Remove" : "Add to Visit"), isLite: true, isLoading: buttonIsLoading, color: alternate ? Colors.redAccent : color, icon: icon ?? (alternate ? Iconsax.close_circle : Iconsax.add_circle), action: alternate ? alternativeAction : buttonAction,) : Container()
              ],
            ),
          ),
        ),
        const Divider(height: 0,)
      ],
    );
  }

  static Widget getGEPTile({required BuildContext context, required Orphanage orphanage, required int lastIndex, bool ongoing = false, required int index, required Function() editAction, required Function() promoteAction, required Function() action}){
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.only(bottom: lastIndex == index ? hv * 7 : 0),
      child: InkWell(
        onTap: action,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: themeProvider.isDark ? Colors.grey[700]! : Colors.grey)
          ),
          child: Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              GestureDetector(
                onTap: orphanage.photos!.isNotEmpty ? ()=>context.pushNamed('image', extra: FullScreenImageModel(hero: orphanage.photos![0], url: orphanage.photos![0], title: "${orphanage.name} - Photo")) : null,
                child: Stack(
                  children: [
                    Container(
                      width: wv*100,
                      height: 170,
                      decoration: BoxDecoration(
                        image: orphanage.photos!.isNotEmpty ? DecorationImage(image: FastCachedImageProvider(orphanage.photos![0]), fit: BoxFit.cover)  : null, 
                        color: bgColorDark.withOpacity(0.4),
                        borderRadius: const BorderRadius.all(Radius.circular(8))
                      ),
                      child: orphanage.photos!.isNotEmpty ? null : Padding(
                        padding: const EdgeInsets.only(bottom: 35),
                        child: Icon(Iconsax.gallery_slash, color: themeProvider.isDark ? Colors.grey[600] : Colors.grey[600], size: 85,),
                      ),
                    ),
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: BackdropFilter(
                        filter:  ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                        child: Container(
                          width: wv*100,
                          height: 170,
                          decoration: BoxDecoration(
                            color: bgColorDark.withOpacity(0.4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            child: Text(["", null].contains(orphanage.name) ? "Unnamed Project" : orphanage.name!.toUpperCase(), style: TextStyle(color: themeProvider.isDark ? Colors.grey[300] : Colors.grey[100], fontSize: 16, fontWeight: FontWeight.w400),),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: 0),
                decoration: BoxDecoration(
                  color: themeProvider.isDark ? bgColorDark : bgColor,
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))
                ),
                width: wv*100,
                child: Row(
                  children: [
                    const Spacer(),
                    ElevatedButton(
                      onPressed: promoteAction,
                      style: const ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.only(left: 15, right: 5)),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))))
                      ),
                      child: Row(
                        children: [
                          Text(ongoing ? "Review visits" : "Promote", style: TextStyle(color: themeProvider.isDark ? Colors.grey[800] : whiteColor),),
                          const SizedBox(width: 5,),
                          Icon(Iconsax.arrow_right_3, color: themeProvider.isDark ? Colors.grey[800] : whiteColor)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FloatingActionButton.small(child: const Icon(Iconsax.eye), heroTag: "eye_${orphanage.id}", onPressed: action),
                    FloatingActionButton.small(child: const Icon(Iconsax.edit_2, color: primaryColor,), heroTag: "edit_${orphanage.id}", onPressed: editAction, backgroundColor: themeProvider.isDark ? bgColorDark : bgColor,),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  static Widget getLearningMaterialTile({required BuildContext context, bool isCompact = false, required Resource resource, bool isSingle = false, required String visit, required Function() action, required Function() editAction}){
    bool isDark = Provider.of<ThemeProvider>(context).isDark;
    List photos = resource.photos ?? [];
    int qty = resource.qty ?? 1;
    String? type = resource.mediaType;
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        Center(
          child: InkWell(
            onTap: action,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: isSingle ? 10 : 0),
              height: 130,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800]! : null,
                borderRadius: BorderRadius.circular(15),
                border: isDark ? null : Border.all(color: Colors.grey)
              ),
              child: Row(
                children: [
                  Container(
                    width: wv*35,
                    height: 130,
                    decoration: BoxDecoration(
                      image: photos.isNotEmpty ? DecorationImage(image: FastCachedImageProvider(photos[photos.length-1]), fit: BoxFit.cover) : null,
                      color: isDark ? null : Colors.grey[400],
                      border: isDark ? Border.all(color: Colors.grey[700]!.withOpacity(0.5)) : null,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: photos.isEmpty ? Icon(type == "VIDEO" ? Iconsax.video_circle : (type == "AUDIO" ? Iconsax.audio_square : (type == "PHOTO" ? Iconsax.gallery : Iconsax.document_text)), color: isDark ? Colors.grey[700] : whiteColor.withOpacity(0.3), size: 100,) : null,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 10, top: 10, right: 8),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${resource.name}", style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 19),),
                            ["VIDEO", "AUDIO", "FILE", "PHOTO"].contains(resource.mediaType) ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Format: ${resource.mediaType}"),
                                Text("${resource.learningMaterialType}"),
                                Text("Author: ${resource.authors != null && resource.authors != [] ? resource.authors![0] : "-/-"}"),
                              ],
                            ) 
                            
                            : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Quantity: ${qty.getStringCustomized()}"),
                                Text("Unit Price: ${resource.cost?.getStringCustomized() ?? 0}"),
                                Text("Total: ${(qty*(resource.cost ?? 0)).getStringCustomized()}"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5)
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: wv*30),
          child: FloatingActionButton.small(onPressed: editAction, child: const Icon(Iconsax.edit_2), heroTag: "LM_${resource.id}",),
        )
      ],
    );
  }

  static Widget getIconTextPlaceHolder({required String text, required IconData icon}){
    return Center(child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 200, color: Colors.grey,),
          Text(text, style: TextStyle(color: Colors.grey, fontSize: 18), textAlign: TextAlign.center,),
        ],
      ),
    ));
  }

  static Widget getSpace({bool isCompact = false}){
    return Column(
      children: [
        SizedBox(height: isCompact ? hv*2 : 5,),
        isCompact ? Container() : Divider(height: 0, color:Colors.grey[400]),
      ],
    );
  }

  static Widget getDefaultTitle({required String title, double? paddingBottom, double? paddingTop}){
    return Column(
      children: [
        SizedBox(height: paddingTop ?? 0,),
        Row(
          children: [
            const SizedBox(width: 15,),
            Text(title),
            const Spacer(),
          ],
        ),
        SizedBox(height: paddingBottom ?? 0,),
      ],
    );
  }

  static Widget getDropdownButton({String? value, required String hint, bool edit = true, required Function(String?) onChanged, required List<DropdownItemModel> items}){
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButton<String>(
          value: value,
          icon: const Icon(Iconsax.arrow_down_1),
          underline: edit ? Container(height: 1.2, color: Colors.grey[600]!.withOpacity(0.6)) : Container(),
          isExpanded: true,
          hint: Text(hint),
          items: items.map((item) {
            return DropdownMenuItem(child: Text(item.name, style: const TextStyle(fontSize: 20),), value: item.value,);
          }).toList(),
          onChanged: !edit ? null : (value) => onChanged(value),
      ),
    );
  }

  static Widget getUploadMediaTile({required BuildContext context, String? url, String? type, String? thumbnailPath, File? file, Uint8List? thumbnail, bool isDark = false, required Function() copyAction, required Function() pasteAction, required Function() uploadAction}){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        border: isDark ? null : Border.all(color: Colors.grey.withOpacity(0.7), width: 0.5),
        color: isDark ? Colors.grey[700]!.withOpacity(0.3) : Colors.grey[300]!.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: url != null || file != null ? ()=>Algorithms.showCustomBottomSheet(context: context, maxHeight: hv*60, child: VideoView(video: VideoModel(url: url), videoFile: file,)) : null,
            child: Icon(file != null || url != null ? Iconsax.video_circle5 : Iconsax.video_circle, color: file != null || url != null ? primaryColor : Colors.grey[600]!.withOpacity(0.8), size: 65,),
          ),
          const SizedBox(width: 5,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    CustomTextButton(text: "Paste Link", padding: EdgeInsets.zero, textColor: primaryColor, color: primaryColor.withOpacity(0.3), isLite: true, action: pasteAction),
                    const SizedBox(width: 5,),
                    CustomTextButton(text: "Take Video", padding: EdgeInsets.zero, isLite: true, action: uploadAction),
                    const SizedBox(width: 3,)
                  ],
                ),
                file != null ? Container() : const SizedBox(height: 5,),
                file != null ? Container() : Text((url ?? "Source: No Resource Added"), style: TextStyle(fontSize: 14, color: url != null ? Colors.grey : null, decoration: url != null ? TextDecoration.underline : null),),
                const SizedBox(height: 5,),
                if (thumbnail != null ||thumbnailPath != null)
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: url != null || file != null ? ()=>Algorithms.showCustomBottomSheet(context: context, maxHeight: hv*60, child: VideoView(video: VideoModel(url: url), videoFile: file,)) : null,
                      child: Container(
                        width: 150,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                          image: DecorationImage(image: thumbnail != null ? MemoryImage(thumbnail) : FileImage(File(thumbnailPath!)) as ImageProvider, fit: BoxFit.cover)
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget getCheckBoxListTile({required bool edit, required String title, bool? value, required Function(bool?) onChanged, Function(bool?)? action}){
    bool? val;
    return  ListTile(
      onTap: !edit ? null : (){val = value != null ? !value : true; onChanged(val);},
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      title: Text(title, textAlign: TextAlign.left,),
      trailing: Checkbox(
        tristate: true,
        value: value,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        activeColor: value == null ? Colors.grey : primaryColor,
        onChanged: !edit ? null : onChanged,
      ),
    );
  }


  static Widget getTabBarHeader({required IconData icon, required String text}) => Row(children: [Icon(icon, size: 32,), const SizedBox(width: 10),Text(text)], mainAxisAlignment: MainAxisAlignment.center,);

  static Widget getUnderlineDropdown () => Container(height: 1.2, color: Colors.grey[600]!.withOpacity(0.6));
}

class DropdownItemModel {
  final String value, name;
  DropdownItemModel(this.value, this.name);
}