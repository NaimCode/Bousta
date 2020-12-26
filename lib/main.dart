import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lesrecettesdebousta/pages/recette.dart';
import 'package:provider/provider.dart';

import 'Splash.dart';
import 'ajoutRecette.dart';
import 'constants/color.dart';
import 'constants/model.dart';
import 'constants/staticVariables.dart';
import 'constants/widget.dart';
import 'home.dart';
import 'pages/accueil.dart';
import 'pages/favoris.dart';
import 'pages/profil.dart';
import 'pages/recherche.dart';
import 'service/authentification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  //await Authentification(FirebaseAuth.instance).deconnection();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Authentification>(
          create: (_) => Authentification(FirebaseAuth.instance),
        ),
        StreamProvider(
            create: (conext) =>
                context.read<Authentification>().authStateChanges),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bousta',
        theme: ThemeData(
          primarySwatch: colorPrimary,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => Bousta()),
          GetPage(
            name: '/add',
            page: () => AjoutRecette(),
          ),
          GetPage(
            name: '/recette',
            page: () => RecettePage(),
          ),
        ],
      ),
    );
  }
}

class Bousta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<Authentification>();

    return StreamBuilder<User>(
      stream: firebaseUser.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Chargement(colorPrimary, colorSecondary);
        if (!snapshot.hasData)
          return Splash();
        else {
          print(snapshot.data.uid);
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Chef')
                  .doc(snapshot.data.uid)
                  .snapshots(),
              builder: (context, doc) {
                if (doc.connectionState == ConnectionState.waiting)
                  return Chargement(colorPrimary, colorSecondary);
                if (doc.hasError) {
                  Get.rawSnackbar(
                      title: 'Erreur',
                      message: '',
                      icon: Icon(
                        Icons.error_sharp,
                        color: Colors.red,
                      ));
                  Authentification(FirebaseAuth.instance).deconnection();
                }
                if (doc.hasData) {
                  var user = doc.data;

                  // String imageurl = user['image'] ?? profile;

                  return ProxyProvider0(
                      update: (_, __) => Chef(
                          nom: user['nom'],
                          image: user['image'],
                          email: user['email'],
                          password: user['password'],
                          admin: user['admin'],
                          historique: user['historique'],
                          favori: user['favori'],
                          uid: user['uid']),
                      child: Home());
                } else
                  return Chargement(colorPrimary, colorSecondary);
              });
        }
      },
    );
  }
}
