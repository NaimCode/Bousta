import 'package:animated_text_kit/animated_text_kit.dart';
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

import 'favorite.dart';
import 'historique.dart';
import 'recherche.dart';

class Profil extends StatefulWidget {
  final List<Recette> recettes;
  Profil(this.recettes);
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> with TickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  int index = 0;
  bool lastStatus = true;
  bool isShrink = false;
  bool favor = true;
  List<Recette> favlist = [], hislist = [];
  initState() {
    _scrollController.addListener(_scrollListener);
    tab = TabController(length: 2, vsync: this);
    tab.addListener(() {
      print('listening');
      if (tab.index == 0)
        setState(() {
          favor = true;
        });
      else
        setState(() {
          favor = false;
        });
    });
    super.initState();
  }

  getFav(Chef user) {
    List<Recette> recette = [];
    widget.recettes.forEach((element) {
      if (user.favori.contains(element.uid)) recette.add(element);
    });

    return recette;
  }

  getHis(Chef user) {
    List<Recette> recette = [];
    widget.recettes.forEach((element) {
      if (user.historique.contains(element.uid)) recette.add(element);
    });
    print(recette.length.toString());
    return recette;
  }

  _scrollListener() {
    if (_scrollController.offset > 120.0) {
      setState(() {
        isShrink = true;
      });
    } else
      setState(() {
        isShrink = false;
      });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);

    super.dispose();
  }

  TabController tab;

  Chef user;
  @override
  Widget build(BuildContext context) {
    user = context.watch<Chef>();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
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
                  fontSize: 30,
                  letterSpacing: 4,
                  color: colorThirdy,
                  shadows: [
                    Shadow(
                      blurRadius: 6.0,
                      color: Colors.grey.shade700,
                      //offset: Offset(0.0, 0.0),
                    ),
                  ],
                ),
                textAlign: TextAlign.center),
          ), //navBarTitleText('Bousta', colorThirdy),
          centerTitle: true,

          bottom: TabBar(
              indicatorColor: Colors.black,
              controller: tab,
              indicatorWeight: 2,
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.favorite,
                    //  size: 30,
                    color: Colors.black,
                  ),
                  text: 'Favoris',
                ),
                Tab(
                  icon: Icon(
                    Icons.history,
                    //  size: 30,
                    color: Colors.black,
                  ),
                  text: 'Historiques',
                ),
              ]),
        ),
        body: TabBarView(
          controller: tab,
          children: [
            fav(getFav(user)),
            fav(getHis(user)),
          ],
        ),
      ),
    );
  }

  fav(List recettesSearch) {
    return Scrollbar(
      child: ListView.builder(
          shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          itemCount: recettesSearch.length,
          itemBuilder: (context, index) {
            Recette recipe = recettesSearch[index];
            double rating;
            //bool checkFav = getFav(user.favori, recipe.uid);

            (recipe.rater == 0)
                ? rating = 0
                : rating = recipe.rate / recipe.rater;

            return recettesSearch.isEmpty
                ? Center(
                    child: Text('Aucune recette favorite'),
                  )
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
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
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
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
                                                  color: colorPrimary.shade900,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left,
                                            ),
                                            SizedBox(
                                                child:
                                                    Rate(rating, recipe.rater),
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
    );
  }
}
