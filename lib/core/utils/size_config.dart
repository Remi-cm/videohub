import 'dart:math';

import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData?.size.width;
    screenHeight = _mediaQueryData?.size.height;
    orientation = _mediaQueryData?.orientation;
    // On iPhone 11 the defaultSize = 10 almost
    // So if the screen size increase or decrease then our defaultSize also vary
    defaultSize = orientation == Orientation.landscape
        ? screenHeight! * 0.024
        : screenWidth! * 0.024;
  }
}
double getProportionateScreenHeight(double inputHeight) {
  double? screenHeight = SizeConfig.screenHeight;
  // Our designer use iPhone 11, that's why we use 896.0
  return (inputHeight / 896.0) * screenHeight!;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double? screenWidth = SizeConfig.screenWidth;
  // 414 is the layout width that designer use or you can say iPhone 11  width
  return (inputWidth / 414.0) * screenWidth!;
}

// For add free space vertically
class VerticalSpacing extends StatelessWidget {
  const VerticalSpacing({
    Key? key,
    this.of = 20,
  }) : super(key: key);

  final double of;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenWidth(of),
    );
  }
}

// For add free space horizontally
class HorizontalSpacing extends StatelessWidget {
  const HorizontalSpacing({
    Key? key,
    this.of = 20,
  }) : super(key: key);

  final double of;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(of),
    );
  }
}

Size size_ = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
double width_ = size_.width;
double height_ = size_.height;
double wv = width_/100;
double hv = height_/100;

class ScreenSize {
  //static double get _ppi => GetPlatform.isWeb && (defaultTargetPlatform != TargetPlatform.android && defaultTargetPlatform != TargetPlatform.iOS) ? 96 : (GetPlatform.isAndroid || GetPlatform.isIOS) ? 150 : 96;
  static double get _ppi => 150;
  //static bool isLandscape(BuildContext c) => MediaQuery.of(c).orientation == Orientation.landscape;
  //PIXELS
  static Size size() => size_;
  static double width() => width_;
  static double height() => height_;
  static double diagonal() {
    Size s = size();
    return sqrt((s.width * s.width) + (s.height * s.height));
  }
  //INCHES
  static Size inches() {
    Size pxSize = size();
    return Size(pxSize.width / _ppi, pxSize.height/ _ppi);
  }
  static double widthInches() => inches().width;
  static double heightInches() => inches().height;
  static double diagonalInches() => diagonal() / _ppi;
  static bool isSmartphone() => width_ <= 600; // (diagonal()/_ppi) < 7.5;
  static bool isPC() => diagonal() < 10;
  static bool isTablet() => diagonal() >= 7.5 && diagonal() <= 10;
  
  //Layout builder option
  static double diagonalWithParams(num width, num height) {
    return sqrt((width * width) + (height * height));
  }
  static bool isSmartPhoneParams(double width, double height) => (diagonalWithParams(width, height)/_ppi) < 7;
}