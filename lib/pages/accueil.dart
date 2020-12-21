import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lesrecettesdebousta/constants/color.dart';
import 'package:lesrecettesdebousta/constants/staticVariables.dart';
import 'package:lesrecettesdebousta/constants/widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Accueil extends StatefulWidget {
  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  List<String> recettes;
  getabo() async {
    var ref =
        FirebaseStorage.instance.ref().child('Naim/IMG_20201219_193234.jpg');
    String url = (await ref.getDownloadURL()).toString();

    return url;
  }

  @override
  Widget build(BuildContext context) {
    recettes = context.watch<List<String>>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Lottie.asset(accueilLottie,
                  height: 300, fit: BoxFit.fitWidth)),
          Expanded(
              child: ListView.builder(
                  itemCount: recettes.length,
                  itemBuilder: (context, index) => Center(
                        child: Text(recettes[index]),
                      )))
        ],
      ),
    );
  }
}
