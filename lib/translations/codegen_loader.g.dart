// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> ar = {
  "Login": "تسجيل الدخول",
  "Login_to_your_account": "سجل دخول الي حسابك",
  "hello_there_sign_in_to_account": "اهلا بك سجل دخول الي حسابك للأستكمال",
  "Email": "الحساب",
  "Password": "كلمه السر",
  "Enter_your_password": "ادخل كلمه السر الخاصه بك",
  "Enter_your_email": "ادخل الحساب الخاص بك",
  "Please_Enter_your_email": "رجاءا أدخل بريدك الإلكتروني",
  "PleaseEnteraValidEmail": "يرجى إدخال البريد الإلكتروني الصحيح",
  "PleaseEnteryourpassword": "من فضلك أدخل رقمك السري",
  "Passwordistooshort": "كلمة المرور قصيرة جدا",
  "Passwordsdontmatch": "كلمات المرور لا تتطابق",
  "More": "المزيد",
  "ClinicsPackages": "باقات العيادات",
  "ClinicsSchedule": "جداول العيادات",
  "PromoCodes": "الكوبونات",
  "AllPatients": "كل المرضى",
  "Users": "المستخدمون",
  "Logout": "تسجيل الخروج"
};
static const Map<String,dynamic> en = {
  "Login": "Login",
  "Login_to_your_account": "Login to your account",
  "hello_there_sign_in_to_account": "hello there sign in to account",
  "Email": "Email",
  "Password": "Password",
  "Enter_your_password": "Enter your password",
  "Enter_your_email": "Enter your email",
  "Please_Enter_your_email": "Please Enter your email",
  "PleaseEnteraValidEmail": "Please Enter a Valid Email",
  "PleaseEnteryourpassword": "Please Enter your password",
  "Passwordistooshort": "Password is too short",
  "Passwordsdontmatch": "Passwords don't match",
  "More": "More",
  "ClinicsPackages": "Clinics Packages",
  "ClinicsSchedule": "Clinics Schedules",
  "PromoCodes": "Promo Codes",
  "AllPatients": "All Patients",
  "Users": "Users",
  "Logout": "Logout"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"ar": ar, "en": en};
}
