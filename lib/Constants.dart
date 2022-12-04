import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';

import 'package:flutter/material.dart';

class Constants {
  static Color oldColor = const Color(0xff2daae2);
  static Color mainColor = const Color(0xffffffff);
  static Color theardColor = const Color(0xffb896f7);
  static Color secondColor = const Color(0xff484ce3);
  static Color textColor =const Color(0xff3b3b3b);
  static Color secondTextColor =const Color(0xff89909f);
  static List<Color> statisticsColors = const[
    Color(0xff4cd1bc),
    Color(0xff71b4fb),
    Color(0xfffc9881),
    Color(0xff9ae471),
    Color(0xff585ce4),
    Color(0xfffdd36d),
  ];
  static Color smallTextColor =const Color(0xff89909f);
  // Form Error
  static final RegExp emailValidatorRegExp =
  RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static  String kEmailNullError = LocaleKeys.Please_Enter_your_email.tr();
  static  String kInvalidEmailError = LocaleKeys.PleaseEnteraValidEmail.tr();
  static  String kPassNullError = LocaleKeys.PleaseEnteryourpassword.tr();
  static  String kShortPassError =LocaleKeys.Passwordistooshort.tr();
  static  String kMatchPassError =LocaleKeys.Passwordsdontmatch.tr();
  // static  String kNamelNullError = LocaleKeys.Please_Enter_your_name.tr();
  // static  String kCodeNullError = LocaleKeys.Please_enter_your_code.tr();
  // static  String kCodeValidError = LocaleKeys.Please_enter_a_valid_code.tr();
  // static  String kLastNamelNullError = LocaleKeys.Please_Enter_your_lastname.tr();
  // static  String kPhoneNumberNullError = LocaleKeys.Please_Enter_your_phone_number.tr();
  // static  String kAddressNullError = LocaleKeys.Please_Enter_your_address.tr();
  // static  String kAGenderNullError = LocaleKeys.Please_Select_your_Gender.tr();
  // static  String kABirthdayNullError = LocaleKeys.Please_Select_your_Birthday.tr();
  // static  String kAPromoNullError = LocaleKeys.Please_Input_Promo_code.tr();
  // static  String kAPriceNullError = LocaleKeys.Input_your_package_price.tr();
  // static  String kADescriptionNullError = LocaleKeys.Input_your_package_description.tr();


  static TextStyle headingText = TextStyle(
      fontSize: 25.0,
      color: mainColor,
      fontWeight: FontWeight.bold,
  );
  static TextStyle normalText = TextStyle(
      fontSize: 18.0,
      color: mainColor,
      fontWeight: FontWeight.bold
  );
  static TextStyle smallText = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.normal,
      color: Constants.secondTextColor
  );
  static TextStyle aboutSmallText = TextStyle(fontSize: 15,fontWeight: FontWeight.normal,color: Constants.smallTextColor);
  static TextStyle secondSmallText = TextStyle(
      fontSize: 13.0,
      color: secondColor,
      fontWeight: FontWeight.bold
  );
  static TextStyle regularTextNormal = TextStyle(
      fontSize: 17.0,
      color: textColor,
      fontWeight: FontWeight.normal
  );
  static TextStyle PriceSmallText = TextStyle(
      fontSize: 16.0,
      color: secondColor,
      fontWeight: FontWeight.bold
  );

}