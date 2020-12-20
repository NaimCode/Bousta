import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

class _HomeState extends State<Home> {
  int currentIndex = 1;

  var tab = [Accueil(), Recherche(), Favoris(), Profil()];
  @override
  void initState() {
    //  userCurrent = user;
    // TODO: implement initState
    super.initState();
  }

  Chef user;
  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    user = context.watch<Chef>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
        title: SizedBox(
          width: 250.0,
          child: RotateAnimatedTextKit(
              stopPauseOnTap: true,
              repeatForever: true,
              onTap: () {
                print("Tap Event");
              },
              text: ['Bousta'],
              textStyle: TextStyle(
                  fontFamily: fontprimary,
                  fontSize: 28,
                  letterSpacing: 2,
                  color: colorThirdy),
              textAlign: TextAlign.center),
        ), //navBarTitleText('Bousta', colorThirdy),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await Authentification(FirebaseAuth.instance).deconnection();
              }),
        ],
      ),
      body: tab[currentIndex],
      floatingActionButton: user.admin
          ? FloatingActionButton(
              heroTag: 'addIcon',
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        currentIndex: currentIndex, backgroundColor: colorSecondary,
        onTap: changePage,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 8,
        fabLocation: BubbleBottomBarFabLocation.end, //new
        hasNotch: true, //new
        hasInk: true, //new, gives a cute ink effect
        inkColor: Colors.black12, //optional, uses theme color if not specified
        items: [
          BubbleBottomBarItem(
              backgroundColor: Colors.deepPurple,
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.home,
                color: Colors.deepPurple,
              ),
              title: Text("Accueil")),
          BubbleBottomBarItem(
              backgroundColor: Colors.greenAccent,
              icon: Icon(
                Icons.food_bank,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.food_bank,
                color: Colors.greenAccent,
              ),
              title: Text("Recettes")),
          BubbleBottomBarItem(
              backgroundColor: Colors.red[900],
              icon: Icon(
                Icons.favorite,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.favorite,
                color: Colors.red[900],
              ),
              title: Text("Favoris")),
          BubbleBottomBarItem(
              backgroundColor: Colors.indigo,
              icon: Icon(Icons.info, color: Colors.black),
              activeIcon: Icon(Icons.info, color: Colors.indigo),
              title: Text("Information"))
        ],
      ),
    );
  }
}
