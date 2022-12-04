import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Launch{
  SnackBar _snackBarError =
  SnackBar(content: Text(("Could not launch the url")));
  launchLink(context,url) async {
    // var uri = Uri.parse(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(_snackBarError);
    }
  }
}