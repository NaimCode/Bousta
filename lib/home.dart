import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lesrecettesdebousta/pages/discussion.dart';
import 'package:lesrecettesdebousta/pages/favoris.dart';
import 'package:lesrecettesdebousta/pages/profil.dart';

import 'constants/color.dart';
import 'constants/model.dart';
import 'constants/staticVariables.dart';
import 'constants/widget.dart';
import 'pages/accueil.dart';
import 'pages/recherche.dart';
import 'package:provider/provider.dart';

import 'service/authentification.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

var fb = FirebaseFirestore.instance;

class _HomeState extends State<Home> {
  int currentIndex = 4;
  var future;
  List<Recette> recettes = [];

  getBody(int index, List<Recette> v) {
    switch (index) {
      case 0:
        return Accueil();
        break;
      case 1:
        return Recherche(v);
        break;
      case 2:
        return Profil(v);
        break;
      case 4:
        return Favoris();
        break;
      case 3:
        return Forum();
        break;
      default:
    }
  }

  @override
  void initState() {
    future = getRecette();
    // TODO: implement initState
    super.initState();
  }

  Chef user;
  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  getRecette() async {
    List<Recette> list = [];
    var qn = await fb.collection('Recipe').get();
    qn.docs.forEach((element) {
      list.add(Recette.fromDoc(element.data(), element.id));
      // var r = Recette(
      //     titre: element.data()['titre'],
      //     image: element.data()['image'],
      //     video: element.data()['video'],
      //     time: element.data()['time'],
      //     personne: element.data()['personne'],
      //     ingredient: element.data()['ingredienta'],
      //     uid: element.id,
      //     rate: element.data()['rate'],
      //     rater: element.data()['rater'],
      //     description: element.data()['description'],
      //     categorie: element.data()['categorie']);
      // list.add(r);
    });

    return list;
  }

  List<Color> colorList = [Color(0xff684188), Colors.white, Colors.white];
  @override
  Widget build(BuildContext context) {
    user = context.watch<Chef>();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: colorSecondary, // navigation bar color
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light // status bar color
        ));
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Chargement(colorPrimary, colorSecondary);
          if (snapshot.hasData) {
            snapshot.data.toString().printInfo();
          }
          return Scaffold(
            backgroundColor: Colors.white, //colorList[currentIndex],

            body: getBody(currentIndex, snapshot.data),

            floatingActionButton: user.admin
                ? FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      Get.toNamed('/add');
                    },
                    child: Icon(Icons.add),
                    backgroundColor: Colors.amber,
                  )
                : FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      //Get.toNamed('/add');
                    },
                    child: Icon(Icons.share),
                    backgroundColor: Colors.amber,
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            bottomNavigationBar: BubbleBottomBar(
              opacity: .2,
              currentIndex: currentIndex, backgroundColor: colorSecondary,
              onTap: changePage,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              elevation: 8,
              fabLocation: BubbleBottomBarFabLocation.end, //new
              hasNotch: true, //new
              hasInk: true, //new, gives a cute ink effect
              inkColor:
                  Colors.black12, //optional, uses theme color if not specified
              items: [
                BubbleBottomBarItem(
                    backgroundColor: Colors.amber[900],
                    icon: Icon(
                      Icons.home,
                      color: Colors.black,
                    ),
                    activeIcon: Icon(
                      Icons.home,
                      color: Colors.amber[900],
                    ),
                    title: Text("Accueil")),
                BubbleBottomBarItem(
                    backgroundColor: Colors.red[900],
                    icon: Icon(
                      Icons.food_bank,
                      color: Colors.black,
                    ),
                    activeIcon: Icon(
                      Icons.food_bank,
                      color: Colors.red[900],
                    ),
                    title: Text("Recettes")),
                BubbleBottomBarItem(
                    backgroundColor: Colors.indigo,
                    icon: Icon(Icons.bookmarks, color: Colors.black),
                    activeIcon: Icon(Icons.bookmarks, color: Colors.indigo),
                    title: Text("Activités")),
                BubbleBottomBarItem(
                    backgroundColor: Colors.amber[900],
                    icon: Icon(
                      Icons.forum,
                      color: Colors.black,
                    ),
                    activeIcon: Icon(
                      Icons.forum,
                      color: Colors.amber[900],
                    ),
                    title: Text("Forum")),
                BubbleBottomBarItem(
                    backgroundColor: Colors.red[900],
                    icon: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: user.image == null
                          ? AssetImage(profile)
                          : NetworkImage(user.image),
                    ),
                    activeIcon: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: user.image == null
                          ? AssetImage(profile)
                          : NetworkImage(user.image),
                    ),
                    title: Text(
                      user.nom,
                      overflow: TextOverflow.ellipsis,
                    )),
              ],
            ),
          );
        });
  }
}
