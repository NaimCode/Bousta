import 'package:auto_animated/auto_animated.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lesrecettesdebousta/constants/color.dart';
import 'package:lesrecettesdebousta/constants/staticVariables.dart';
import 'package:lesrecettesdebousta/constants/widget.dart';

class Recherche extends StatefulWidget {
  @override
  _RechercheState createState() => _RechercheState();
}

class _RechercheState extends State<Recherche> {
  final options = LiveOptions(
    // Start animation after (default zero)
    delay: Duration(seconds: 1),

    // Show each item through (default 250)
    showItemInterval: Duration(milliseconds: 500),

    // Animation duration (default 250)
    showItemDuration: Duration(seconds: 1),

    // Animations starts at 0.05 visible
    // item fraction in sight (default 0.025)
    visibleFraction: 0.05,

    // Repeat the animation of the appearance
    // when scrolling in the opposite direction (default false)
    // To get the effect as in a showcase for ListView, set true
    reAnimateOnVisibility: false,
  );
  Widget buildAnimatedItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) =>
      // For example wrap with fade transition
      FadeTransition(
        opacity: Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animation),
        // And slide transition
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, -0.1),
            end: Offset.zero,
          ).animate(animation),
          // Paste you Widget
          //child: YouWidgetHere(),
        ),
      );
  getRecette() async {
    QuerySnapshot qn =
        await FirebaseFirestore.instance.collection('Recette').get();
    qn.docs.forEach((element) {});
  }

  //list
  List listRecetteInit = [];
  List listRecette = [];
  //future
  var future;
  //controller
  var searchController = TextEditingController();
  var searchAnimated = 50.0;
  //bool
  var isCharging = false;
  @override
  Widget build(BuildContext context) {
    return isCharging
        ? ChargementLottie(colorSecondary, colorSecondary)
        : FutureBuilder(
            future: null,
            builder: (context, snapshot) {
              return Scaffold(
                backgroundColor: colorSecondary,
                body: Stack(
                  children: [
                    LiveGrid.options(
                      options: options,

                      // Like GridView.builder, but also includes animation property
                      itemBuilder: buildAnimatedItem,

                      // Other properties correspond to the `ListView.builder` / `ListView.separated` widget
                      itemCount: 0,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                    ),
// Or raw

                    search(),
                  ],
                ),
              );
            });
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
                  : Container(
                      child: TextFormField(
                        controller: searchController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: new InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.close, color: colorSecondary),
                              onPressed: () {
                                setState(() {
                                  searchAnimated = 50;
                                });
                              },
                            ),
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
                                color: Colors.white70, fontFamily: fontbody),
                            contentPadding:
                                EdgeInsets.only(left: 15, right: 15, top: 10),
                            hintText: 'Recherche'),
                      ),
                    ),
            )),
      ],
    );
  }
}
