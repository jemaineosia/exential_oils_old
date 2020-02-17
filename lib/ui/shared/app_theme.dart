import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  double pixelRatio(BuildContext context) =>
      MediaQuery.of(context).devicePixelRatio;

  static const ExtraLargeTextSize = 15.0;
  static const LargeTextSize = 12.0;
  static const MediumTextSize = 10.0;
  static const SmallTextSize = 8.0;
  static const TinyTextSize = 6.0;
  static const BodyTextSize = 11.0;

  static const Color appBackgroundColor = Colors.white;
  static const Color topBarColor = Colors.white;
  static const Color primaryColor = Colors.greenAccent;
  static const Color secondaryColor = Colors.grey;

  static const greyColor = const Color(0xff484848);
  static const lightGreyColor = const Color(0x99484848);
  static const loginViewBackground = const Color(0xffEBECF1);
  static const greenColor = const Color(0xff4E7C00);

  static const String FontNameDefault = "HelveticaNeue";

  static final ThemeData lightTheme = ThemeData(
    fontFamily: FontNameDefault,
    scaffoldBackgroundColor: AppTheme.appBackgroundColor,
    brightness: Brightness.light,
    textTheme: lightTextTheme,
  );

  static final TextTheme lightTextTheme = TextTheme(
    title: _titleLight,
    subtitle: _subtitleLight,
    button: _buttonLight,
  );

  static final TextStyle _titleLight = TextStyle(
    // fontWeight: FontWeight.w400,
    fontSize: MediumTextSize,
    color: greyColor,
    // letterSpacing: 1,
  );

  static final TextStyle _subtitleLight = TextStyle(
    color: greyColor,
    fontSize: SmallTextSize,
  );

  static final TextStyle _appBarTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: LargeTextSize,
    color: Colors.white,
  );

  static final TextStyle _buttonLight = TextStyle(
    color: Colors.black,
    fontSize: 28,
  );
}
