import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';
import 'package:lesrecettesdebousta/constants/color.dart';
import 'package:lesrecettesdebousta/constants/model.dart';
import 'package:lesrecettesdebousta/constants/staticVariables.dart';
import 'package:lesrecettesdebousta/constants/widget.dart';
import 'package:lesrecettesdebousta/service/authentification.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Recherche extends StatefulWidget {
  final List<Recette> recettes;
  Recherche(this.recettes);
  @override
  _RechercheState createState() => _RechercheState();
}

class _RechercheState extends State<Recherche> {
  List<Recette> recettes = [];
  List<Recette> recettesSearch = [];
  Chef user;
  getRecette() async {
    QuerySnapshot qn =
        await FirebaseFirestore.instance.collection('Recette').get();
    qn.docs.forEach((element) {
      recettes.add(Recette.fromDoc(element.data(), element.id));
    });
    setState(() {
      recettesSearch = recettes;
    });

    return 'Complete';
  }

  recherche() {
    List<Recette> filter = [];
    if (searchController.text.isEmpty)
      filter = recettes;
    else {
      recettesSearch.forEach((element) {
        if (element.titre
                .toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
            element.categorie
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
          filter.add(element);
      });
    }
    setState(() {
      recettesSearch = filter;
    });
  }

  @override
  void initState() {
    recettes = widget.recettes;
    recettesSearch = widget.recettes;
    //future = getRecette();
    searchController.addListener(recherche);
    //  recettesSearch = context.watch<List<String>>();
    // TODO: implement initState
    super.initState();
  }

  getFav(List list, String rec) {
    // if (list != null)

    for (var i = 0; i < list.length; i++) {
      if (list[i] == rec) return true;
    }
    return false;
  }
  //list

  //future
  var future;
  //controller
  var searchController = TextEditingController();
  var searchAnimated = 50.0;
  //bool
  var isCharging = false;
  @override
  Widget build(BuildContext context) {
    user = context.watch<Chef>();
    return FutureBuilder(
        // future: future,
        builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting)
        return SpinKitChasingDots(
          color: colorPrimary,
          size: 30,
        );
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
        ),
        // backgroundColor: colorSecondary,
        body: Stack(
          children: [
            recettesSearch.isEmpty
                ? pasDeRecetteTrouvee()
                : ListView.builder(
                    itemCount: recettesSearch.length,
                    itemBuilder: (context, index) {
                      Recette recipe = recettesSearch[index];
                      double rating;
                      bool checkFav = getFav(user.favori, recipe.uid);

                      (recipe.rater == 0)
                          ? rating = 0
                          : rating = recipe.rate / recipe.rater;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 4),
                        child: Card(
                          child: InkWell(
                            onTap: () {
                              Get.toNamed('/recette',
                                  arguments: RecetteDetail(user, recipe));
                            },
                            child: Container(
                              height: 120,
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                          child: Hero(
                                        tag: recipe.uid,
                                        child: Image.network(
                                          recipe.image,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return SpinKitChasingDots(
                                              color: colorPrimary,
                                              size: 26,
                                            );
                                          },
                                        ),
                                      ))),
                                  Expanded(
                                      flex: 3,
                                      child: Stack(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 5, bottom: 0, right: 5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SelectableText(
                                                  recipe.titre,
                                                  style: TextStyle(
                                                      fontFamily: fontbody,
                                                      letterSpacing: 2,
                                                      fontSize: 18,
                                                      color:
                                                          colorPrimary.shade900,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.left,
                                                ),
                                                SizedBox(
                                                    child: Rate(
                                                        rating, recipe.rater),
                                                    height: 20),
                                                PersonTimer(recipe: recipe),
                                                Text(
                                                  recipe.categorie,
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontFamily: fontbody,
                                                      letterSpacing: 2,
                                                      color: Colors.black87),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
            search(),
          ],
        ),
      );
    });
  }

  Center pasDeRecetteTrouvee() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Aucune recette ',
            style: TextStyle(),
          ),
          Text(
            searchController.text,
            style: TextStyle(fontFamily: fontbody, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Row search() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            elevation: 8,
            color: colorThirdy,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              height: 50,
              width: searchAnimated,
              child: searchAnimated == 50.0
                  ? Center(
                      child: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: colorSecondary,
                          ),
                          onPressed: () {
                            setState(() {
                              searchAnimated = Get.width - 10;
                            });
                          }))
                  : Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: TextFormField(
                              style: TextStyle(
                                  color: colorSecondary,
                                  fontFamily: fontbody,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold),
                              controller: searchController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: new InputDecoration(
                                  icon: Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Icon(
                                      Icons.search,
                                      color: colorSecondary,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Colors.white70,
                                      fontFamily: fontbody),
                                  contentPadding: EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                  ),
                                  hintText: 'Recherche'),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: colorSecondary),
                          onPressed: () {
                            setState(() {
                              searchAnimated = 50;
                            });
                          },
                        ),
                      ],
                    ),
            )),
      ],
    );
  }
}

class PersonTimer extends StatelessWidget {
  const PersonTimer({
    Key key,
    @required this.recipe,
  }) : super(key: key);

  final Recette recipe;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Icon(
                  Icons.people_alt_outlined,
                  size: 20,
                  color: Colors.black38,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  recipe.personne,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 20,
                  color: Colors.black38,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  recipe.time,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
