import 'package:auto_animated/auto_animated.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lesrecettesdebousta/constants/color.dart';
import 'package:lesrecettesdebousta/constants/staticVariables.dart';
import 'package:provider/provider.dart';

class Recherche extends StatefulWidget {
  @override
  _RechercheState createState() => _RechercheState();
}

class _RechercheState extends State<Recherche> {
  List<String> recettes;
  List<String> recettesSearch;

  var rating = 6.0;

  getRecette() async {
    QuerySnapshot qn =
        await FirebaseFirestore.instance.collection('Recette').get();
    qn.docs.forEach((element) {});
  }

  recherche(String search) {
    List<String> filter = [];
    if (search.isEmpty)
      filter = recettes;
    else {
      recettesSearch.forEach((element) {
        if (element.toLowerCase().contains(searchController.text.toLowerCase()))
          filter.add(element);
      });
    }
    setState(() {
      recettesSearch = filter;
    });
  }

  @override
  void initState() {
    //  recettesSearch = context.watch<List<String>>();
    // TODO: implement initState
    super.initState();
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
    recettes = context.watch<List<String>>();
    if (recettesSearch == null) recettesSearch = recettes;
    return Scaffold(
      backgroundColor: colorSecondary,
      body: Stack(
        children: [
          ListView.builder(
              itemCount: recettesSearch.length,
              itemBuilder: (context, index) => Center(
                    child: Text(recettesSearch[index]),
                  )),
          search(),
          // Center(
          //   child: SmoothStarRating(
          //       allowHalfRating: true,
          //       onRated: (v) {
          //         print('$v');
          //         setState(() {
          //           rating = v;
          //         });
          //       },
          //       starCount: 5,
          //       rating: rating,
          //       size: 40.0,
          //       isReadOnly: false,
          //       color: Colors.green,
          //       borderColor: Colors.green,
          //       spacing: 0.0),
          // )
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
                              onChanged: recherche,
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
