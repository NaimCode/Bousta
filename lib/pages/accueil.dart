import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lesrecettesdebousta/constants/color.dart';
import 'package:lesrecettesdebousta/constants/model.dart';
import 'package:lesrecettesdebousta/constants/staticVariables.dart';
import 'package:lesrecettesdebousta/constants/widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class Accueil extends StatefulWidget {
  final recette;
  Accueil(this.recette);
  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  List<Recette> recettes;
  List<Categorie> categorie;
  List<Recette> mieuxNote;
  initState() {
    recettes = widget.recette;
    categorie = getCategorie();
    mieuxNote = getMieuxNote();
    super.initState();
  }

  getMieuxNote() {
    List<Recette> list = recettes;
    list.sort((a, b) => a.rate.compareTo(b.rate));
    return list.reversed.toList();
  }

  getCategorie() {
    List listNom = [];

    List<Categorie> listC = [];
    recettes.forEach((element) {
      listNom.add(element.categorie);
    });
    listNom.toSet().toList().forEach((elementA) {
      var list = [];
      recettes.forEach((element) {
        if (element.categorie == elementA) list.add(element.image);
      });
      final random = Random();
      listC.add(Categorie(elementA, list[random.nextInt(list.length)]));
    });
    return listC;
  }

  Chef user;
  @override
  Widget build(BuildContext context) {
    user = context.watch<Chef>();
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Scrollbar(
        child: ListView(
          children: [
            Center(
              child: Text(
                'Recettes du jour',
                style: TextStyle(
                    color: colorPrimary, fontFamily: fontprimary, fontSize: 24),
              ),
            ),
            Divider(color: colorPrimary, thickness: 1.0),
            Container(
              height: 180,
              child: Swiper(
                //autoplay: true,
                itemBuilder: (BuildContext context, int index) {
                  return
                      //  GFCard(
                      //   boxFit: BoxFit.cover,
                      //   imageOverlay: NetworkImage('http://via.placeholder.com/288x188'),
                      //   title: GFListTile(
                      //     title: Text('Card Title'),
                      //   ),
                      //   content: Text(
                      //       "GFCards has three types of cards i.e, basic, with avataras and with overlay image"),
                      //   //  buttonBar: GFButtonBar(
                      //   //  alignment: MainAxisAlignment.center,
                      //   //  children: <Widget>[
                      //   //  GFButton(
                      //   //    onPressed: () {},
                      //   //    text: 'View',
                      //   //    )
                      //   //   ],
                      //   //  ),
                      // );
                      Card(
                    elevation: 6,
                    // height: 300,
                    child: new Image.network(
                      "http://via.placeholder.com/288x188",
                      fit: BoxFit.fill,
                    ),
                  );
                },
                itemCount: 10,
                viewportFraction: 0.8,
                scale: 0.9,
                pagination: new SwiperPagination(),
                //control: new SwiperControl(),
              ),
            ),
            Center(
              child: Text(
                'Catégories',
                style: TextStyle(
                    color: colorPrimary, fontFamily: fontprimary, fontSize: 24),
              ),
            ),
            Divider(color: colorPrimary, thickness: 1.0),
            Container(
              height: 100,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: categorie.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage:
                                  NetworkImage(categorie[index].image),
                            ),
                            Text(categorie[index].nom,
                                style: TextStyle(
                                    fontFamily: fontbody, letterSpacing: 2))
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Center(
              child: Text(
                'Nouvelles recettes',
                style: TextStyle(
                    color: colorPrimary, fontFamily: fontprimary, fontSize: 24),
              ),
            ),
            Divider(color: colorPrimary, thickness: 1.0),
            Container(
              height: 140,
              child: Swiper(
                //autoplay: true,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 6,
                    // height: 300,
                    child: new Image.network(
                      "http://via.placeholder.com/288x188",
                      fit: BoxFit.fill,
                    ),
                  );
                },
                itemCount: 10,
                viewportFraction: 0.8,
                scale: 0.9,
                pagination: new SwiperPagination(),
                //control: new SwiperControl(),
              ),
            ),
            Center(
              child: Text(
                'Mieux notées',
                style: TextStyle(
                    color: colorPrimary, fontFamily: fontprimary, fontSize: 24),
              ),
            ),
            Divider(color: colorPrimary, thickness: 1.0),
            Container(
              height: 160,
              child: Swiper(
                onTap: (index) {
                  Get.toNamed('/recette',
                      arguments: RecetteDetail(user, mieuxNote[index]));
                },
                //autoplay: true,
                itemBuilder: (BuildContext context, int index) {
                  return GFCard(
                      boxFit: BoxFit.cover,
                      imageOverlay: NetworkImage(mieuxNote[index].image),
                      title: GFListTile(
                        title: Text(
                          mieuxNote[index].titre,
                          style: TextStyle(
                            color: colorSecondary,
                            fontSize: 18,
                            fontFamily: fontbody,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black,
                                //offset: Offset(0.0, 0.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      content: GFRating(
                        margin: EdgeInsets.zero,
                        value: mieuxNote[index].rater == 0
                            ? 0.0
                            : mieuxNote[index].rate / mieuxNote[index].rater,
                      ));
                },
                itemCount: 5,
                viewportFraction: 0.8,
                scale: 0.9,
                pagination: new SwiperPagination(),
                //control: new SwiperControl(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
