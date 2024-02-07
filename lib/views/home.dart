//import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:videohub/components/tool_box.dart';
import 'package:videohub/core/utils/colors.dart';
import 'package:videohub/views/upload.dart';
import 'package:videohub/views/videos.dart';

import '../core/providers/theme_provider.dart';
import '../core/providers/user_provider.dart';
import '../core/utils/size_config.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    UserProvider userProvider  = Provider.of<UserProvider>(context);
    List<Widget> _pages = <Widget>[
      UploadVideoForm(onSent: () => _onItemTapped(1),),
      const VideoList()
    ];
    List<HomeDrowpDownListItem> dropdownItems = [
      HomeDrowpDownListItem(value: userProvider.getUser != null ? "profile" : "signIn", label: userProvider.getUser != null ? "Profile" : "Se connecter", icon: Iconsax.user, action: userProvider.getUser != null ? (){}: (){context.push('/sign-in');}),
      HomeDrowpDownListItem(value: "darkMode", label: themeProvider.isDark ? "Light Mode" : "Dark Mode", icon: themeProvider.isDark ? Iconsax.sun_1 : Iconsax.moon, action: (){themeProvider.setTheme(!themeProvider.isDark);}),
    ];
    userProvider.getUser != null ? dropdownItems.add(HomeDrowpDownListItem(value: "l", label: "Sign Out", icon: Iconsax.logout, action: () async {await FirebaseAuth.instance.signOut(); userProvider.destroyProfile(); context.go("/sign-in"); ToolBox.showMsg(context: context, text: "User signed out");}),) : print("nope");
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            Hero(
              tag: "logo",
              child: userProvider.getUser?.photoUrl == null ? Icon(Iconsax.video, size: 50,)
                : CircleAvatar(
                  radius: 20,
                  backgroundColor: primaryColor,
                  backgroundImage: FastCachedImageProvider(userProvider.getUser!.photoUrl!)
                )
            ),
            SizedBox(width: wv*1,),
            Text("Video Hub", style: TextStyle(color: themeProvider.isDark ? Colors.grey[200] : Colors.grey[600], fontSize: 20, fontWeight: FontWeight.w500))
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[600]!, width: 1.5),
                shape: BoxShape.circle
              ),
              child: Icon(Iconsax.user, color: Colors.grey[600], size: 28,),
            ),
            itemBuilder: ((context) {
              return dropdownItems.map((HomeDrowpDownListItem item) {
                return PopupMenuItem<String>(
                  value: item.value,
                  child: Row(
                    children: [
                      Icon(item.icon, color:  Colors.grey),
                      const SizedBox(width: 10,),
                      Text(item.label),
                    ],
                  ),
                  onTap: item.action,
                );
              }).toList();
            }),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        elevation: 10,
        //backgroundColor: themeProvider.isDark ? bgColorDark : bgColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Iconsax.send_1, size: 35),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.play_circle, size: 35),
            label: 'Videos',
          )
        ],
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex), //New
      ),
    );
  }
}

class HomeDrowpDownListItem {
  final String value, label;
  final IconData icon;
  final Function() action;

  HomeDrowpDownListItem({required this.value, required this.label, required this.icon, required this.action});
}