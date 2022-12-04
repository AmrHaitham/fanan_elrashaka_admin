import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_admin/widgets/MainContainer.dart';
import 'package:fanan_elrashaka_admin/widgets/SignInForm.dart';

import 'package:flutter/material.dart';
class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return MainContainer(
        patternColor: Constants.mainColor,
        backIcon: false,
        title: LocaleKeys.Login.tr(),
        child: Padding(
          padding: const EdgeInsets.only(left: 25,right: 25),
          child: SignForm(),
        )
    );
  }
}