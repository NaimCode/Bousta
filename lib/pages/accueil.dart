import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lesrecettesdebousta/constants/color.dart';
import 'package:lesrecettesdebousta/constants/widget.dart';
import 'package:lottie/lottie.dart';

class Accueil extends StatefulWidget {
  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  getabo() async {
    var ref =
        FirebaseStorage.instance.ref().child('Naim/IMG_20201219_193234.jpg');
    String url = (await ref.getDownloadURL()).toString();

    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Lottie.network(
            'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json',
            height: 200),
      ),
    );
  }
}
