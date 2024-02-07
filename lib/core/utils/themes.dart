 import 'dart:ui';

import 'package:flutter/material.dart';

import 'colors.dart';
 
 ThemeData g4allTheme(BuildContext context, bool isLight) {
  String font = "Brandon-grotesque";
  //Text Theme
  TextTheme _g4allTextTheme(TextTheme base) {
  return isLight ? base.copyWith(
    displayLarge: base.displayLarge?.copyWith(fontFamily: font, fontSize: 30.0, fontWeight: FontWeight.bold, color: textColor),
    displayMedium: base.displayMedium?.copyWith(fontFamily: font, fontSize: 25.0, fontWeight: FontWeight.bold, color: textColor),
    displaySmall: base.displaySmall?.copyWith(fontFamily: font, fontSize: 22.5, fontWeight: FontWeight.bold, color: textColor),
    headlineMedium: base.displayLarge?.copyWith(fontFamily: font, fontSize: 20.0, fontWeight: FontWeight.bold, color: textColor),
    headlineSmall: base.headlineSmall?.copyWith(fontFamily: font, fontSize: 18.0, fontWeight: FontWeight.bold, color: textColor),
    titleLarge: base.headlineSmall?.copyWith(fontFamily: font, fontSize: 16.0, fontWeight: FontWeight.bold, color: textColor),
    bodySmall: base.bodySmall?.copyWith(fontFamily: font, color: textColor),
    bodyLarge: base.bodyLarge?.copyWith(fontFamily: font, color: textColor),
    bodyMedium: base.bodyMedium?.copyWith(fontFamily: font, color: textColor, fontSize: 17),
    titleMedium:base.headlineSmall?.copyWith(fontFamily: font, fontSize: 16.0, color: textColor),
    titleSmall: base.headlineSmall?.copyWith(fontFamily: font, fontSize: 16.0, color: textColor),
    labelLarge: base.labelLarge?.copyWith(color: bgColor)
  )
  : base.copyWith(
    displayLarge: base.displayLarge?.copyWith(fontFamily: font, fontSize: 30.0, fontWeight: FontWeight.bold, color: textColorDark),
    displayMedium: base.displayMedium?.copyWith(fontFamily: font, fontSize: 25.0, fontWeight: FontWeight.bold, color: textColorDark),
    displaySmall: base.displaySmall?.copyWith(fontFamily: font, fontSize: 22.5, fontWeight: FontWeight.bold, color: textColorDark),
    headlineMedium: base.displayLarge?.copyWith(fontFamily: font, fontSize: 20.0, fontWeight: FontWeight.bold, color: textColorDark),
    headlineSmall: base.headlineSmall?.copyWith(fontFamily: font, fontSize: 18.0, fontWeight: FontWeight.bold, color: textColorDark),
    titleLarge: base.headlineSmall?.copyWith(fontFamily: font, fontSize: 16.0, fontWeight: FontWeight.bold, color: textColorDark),
    bodySmall: base.bodySmall?.copyWith(fontFamily: font, color: textColorDark),
    bodyLarge: base.bodyLarge?.copyWith(fontFamily: font, color: textColorDark),
    bodyMedium: base.bodyMedium?.copyWith(fontFamily: font, color: textColorDark, fontSize: 17),
    titleMedium:base.headlineSmall?.copyWith(fontFamily: font, fontSize: 16.0, color: textColorDark),
    titleSmall: base.headlineSmall?.copyWith(fontFamily: font, fontSize: 16.0, color: textColorDark),
  );
  }
  
  //Button Theme
  TextButtonThemeData _g4allTextButtonTheme() {
    return const TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(primaryColor),
        textStyle: MaterialStatePropertyAll(TextStyle(color: whiteColor, fontWeight: FontWeight.w600, fontSize: 18.5)),
        padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 14, horizontal: 15)),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))))
      )
    );
  }
  
  final ThemeData lightTheme = ThemeData.light();
  final ThemeData darkTheme = ThemeData.dark();

  InputBorder defaultInputBorder = UnderlineInputBorder(
    borderSide: BorderSide(width: 1.2, color: Colors.grey[600]!.withOpacity(0.7)),
  );

  InputBorder disabledInputBorder = const UnderlineInputBorder(
    borderSide: BorderSide(width: 1.2, color: Colors.transparent),
  );

  InputBorder errorInputBorder = const UnderlineInputBorder(
    borderSide: BorderSide(width: 1.5, color: Colors.red),
  );
  
  
  return isLight ? lightTheme.copyWith(
    
    textTheme: _g4allTextTheme(lightTheme.textTheme),
    textButtonTheme: _g4allTextButtonTheme(),
    primaryColor: primaryColor,
    indicatorColor: const Color(0xFF807A6B),
    scaffoldBackgroundColor: bgColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    listTileTheme: const ListTileThemeData(),
    appBarTheme: ThemeData.light().appBarTheme.copyWith(
      backgroundColor: bgColor,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(color: Colors.grey[700], fontSize: 20, fontWeight: FontWeight.w500, fontFamily: font),
      iconTheme: IconThemeData(color: Colors.grey[700], size: 30)
    ),
    bottomNavigationBarTheme: ThemeData.light().bottomNavigationBarTheme.copyWith(
      backgroundColor: bgColor
    ),
    tabBarTheme: lightTheme.tabBarTheme.copyWith(
    labelColor: textColor,
    indicatorColor: Colors.grey[700],
    labelStyle: TextStyle(fontFamily: font, fontWeight: FontWeight.w500, fontSize: 16.0, color: textColor),
    unselectedLabelStyle: TextStyle(fontFamily: font, fontWeight: FontWeight.w400, fontSize: 16.0, color: textColor),
    unselectedLabelColor: Colors.grey,
    ),
    
    inputDecorationTheme: ThemeData.light().inputDecorationTheme.copyWith(
      filled: false,
      disabledBorder: disabledInputBorder,
      errorBorder: errorInputBorder,
      focusedErrorBorder: errorInputBorder,
      focusedBorder: defaultInputBorder,
      enabledBorder: defaultInputBorder,
      //contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      errorStyle: TextStyle(color: Colors.red[300]),
      hintStyle: TextStyle(color: Colors.grey, fontSize: 17, fontFamily: font, fontWeight: FontWeight.w400),
                      
    ),
    buttonTheme: lightTheme.buttonTheme.copyWith(buttonColor: textColor),
     bottomAppBarTheme: const BottomAppBarTheme(color: whiteColor), 
     colorScheme: ThemeData.light().colorScheme.copyWith(primary: primaryColor, secondary: primaryColor, tertiary: primaryColor).copyWith(error: Colors.red).copyWith(background: Colors.white),
  )
  : darkTheme.copyWith(
    textSelectionTheme: ThemeData.dark().textSelectionTheme.copyWith(cursorColor: Colors.grey[200]),
    textTheme: _g4allTextTheme(darkTheme.textTheme),
    textButtonTheme: _g4allTextButtonTheme(),
    colorScheme: ThemeData.dark().colorScheme.copyWith(primary: primaryColor, secondary: primaryColor, tertiary: primaryColor),
    appBarTheme: ThemeData.light().appBarTheme.copyWith(
      backgroundColor: bgColorDark,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(color: Colors.grey[100], fontSize: 20, fontWeight: FontWeight.w500, fontFamily: font),
      iconTheme: IconThemeData(color: Colors.grey[100], size: 30)
    ),
    bottomNavigationBarTheme: ThemeData.light().bottomNavigationBarTheme.copyWith(
      backgroundColor: bgColorDark
    ),
    inputDecorationTheme: ThemeData.dark().inputDecorationTheme.copyWith(
      filled: false,
      disabledBorder: disabledInputBorder,
      errorBorder: errorInputBorder,
      focusedErrorBorder: errorInputBorder,
      enabledBorder: defaultInputBorder,
      focusedBorder: defaultInputBorder,
      //contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      errorStyle: const TextStyle(color: bgColor),
      hintStyle: TextStyle(color: Colors.grey, fontSize: 17, fontFamily: font, fontWeight: FontWeight.w600),
    ),
    primaryColor: primaryColor,
    tabBarTheme: darkTheme.tabBarTheme.copyWith(
      indicatorColor: Colors.grey[200],
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: Colors.grey[300],
      labelStyle: TextStyle(fontFamily: font, fontWeight: FontWeight.w500, fontSize: 18.0),
      unselectedLabelStyle: TextStyle(fontFamily: font, fontWeight: FontWeight.w400, fontSize: 16.0, color: Colors.grey),
      //unselectedLabelColor: Colors.grey,
    ),
    scaffoldBackgroundColor: bgColorDark, 
    bottomAppBarTheme: BottomAppBarTheme(color: bgColorDark)
  );

 }
 
 
 /*ThemeData g4allDarkTheme() {
   TextTheme _g4allDarkTextTheme(TextTheme base) {
    return base.copyWith(
      headline1: base.headline1?.copyWith(fontFamily: font, fontSize: 25.0, color: Colors.grey[200]),
      headline2: base.headline2?.copyWith(fontFamily: font, fontSize: 22.0, color: Colors.grey[200]),
      headline3: base.headline3?.copyWith(fontFamily: font, fontSize: 18.0, color: Colors.grey[200]),
      headline4: base.headline1?.copyWith(fontFamily: font, fontSize: 16.0, color: Colors.grey[200]),
      headline5: base.headline5?.copyWith(fontFamily: font, fontSize: 14.0, color: Colors.grey[200]),
      caption: base.caption?.copyWith(fontFamily: font, color: Colors.grey[200]),
      bodyText1: base.bodyText1?.copyWith(fontFamily: font, color: Colors.grey[200]),
      bodyText2: base.bodyText2?.copyWith(fontFamily: font, color: Colors.grey[200], fontSize: 17),
    );
  }
  final ThemeData darkTheme = ThemeData.dark();
  return darkTheme.copyWith(
    textSelectionTheme: ThemeData.dark().textSelectionTheme.copyWith(cursorColor: Colors.grey[200]),
    textTheme: _g4allDarkTextTheme(darkTheme.textTheme),
    colorScheme: ThemeData.dark().colorScheme.copyWith(primary: Colors.grey[200]),
    inputDecorationTheme: ThemeData.dark().inputDecorationTheme.copyWith(
      filled: true,
      fillColor: Colors.grey[700],
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 1, color: textColor.withOpacity(0.0)),
        borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(width: 1, color: bgColor),
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(width: 1, color: bgColor),
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 1, color: textColor.withOpacity(0.0)),
        borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(0.2)),
        borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
      errorStyle: const TextStyle(color: bgColor),
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 17, fontFamily: font, fontWeight: FontWeight.w600),
    ),
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.grey[800]
  );
 }*/