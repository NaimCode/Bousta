import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lesrecettesdebousta/constants/model.dart';
import 'package:lesrecettesdebousta/pages/recette.dart';
import 'package:lesrecettesdebousta/constants/staticVariables.dart';
import 'package:lottie/lottie.dart';

import 'package:timeago/timeago.dart' as timeago;
import 'color.dart';

//dialo with return
confirmationDialog(String titre, String desc, var icon, var context) {
  return Get.defaultDialog(title: titre, middleText: desc, actions: [
    OutlineButton(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: () {
          Navigator.pop(context, 'non');
        },
        color: colorPrimary,
        child: Text('annuler',
            style: TextStyle(fontFamily: fontbody, color: colorThirdy))),
    FlatButton.icon(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: () async {
          Navigator.pop(context, 'oui');
        },
        color: colorPrimary,
        icon: Icon(icon, color: colorThirdy),
        label: Text('confirmer',
            style: TextStyle(fontFamily: fontbody, color: colorThirdy)))
  ]);
}

//Loading
class Chargement extends StatelessWidget {
  final Color color1;
  final Color color2;
  Chargement(this.color1, this.color2);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: color1,
        child: SpinKitChasingDots(
          color: color2,
          size: 40,
        ),
      ),
    );
  }
}

chargement() {
  return SpinKitChasingDots(
    color: colorPrimary,
    size: 30,
  );
}

class ChargementLottie extends StatelessWidget {
  final Color color1;

  ChargementLottie(this.color1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: color1,
        child: Center(child: Lottie.asset(loadingLottie, height: 160)),
      ),
    );
  }
}

Container miniChargement(Color color1, Color color2) {
  return Container(
    color: color1,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SpinKitFoldingCube(
          color: color2,
          size: 30,
        ),
        Text(
          'chargement',
          style: TextStyle(fontFamily: fontsecondary, color: color2),
        )
      ],
    ),
  );
}

//Title
Text navBarTitleText(String text, Color color) {
  return Text(
    text,
    style: TextStyle(
        fontFamily: fontprimary, fontSize: 28, letterSpacing: 2, color: color),
  );
}

Text bodyText(String text) {
  return Text(
    text,
    style: TextStyle(fontFamily: fontbody, fontSize: 16),
  );
}

TextFormField textEditingIngredient(TextEditingController controller) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.multiline,
    decoration: new InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        hintStyle: TextStyle(color: Colors.black26, fontFamily: fontsecondary),
        contentPadding: EdgeInsets.only(left: 15, right: 15),
        hintText: 'Saisir l\'ingrédient'),
  );
}

TextFormField textEditingEtape(TextEditingController controller) {
  return TextFormField(
    controller: controller,
    maxLines: 5,
    keyboardType: TextInputType.multiline,
    decoration: new InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        hintStyle: TextStyle(color: Colors.black26, fontFamily: fontsecondary),
        contentPadding: EdgeInsets.only(left: 15, right: 15),
        hintText: 'Saisir l\'étape'),
  );
}

//Splash
class SplashLottie extends StatelessWidget {
  const SplashLottie({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(child: Lottie.asset(splashImage, fit: BoxFit.fitWidth)),
    );
  }
}

class BigTitle extends StatelessWidget {
  const BigTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Center(
          child: Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: Text(
          'Bousta',
          style: TextStyle(
            fontFamily: fontprimary,
            fontSize: 35,
            letterSpacing: 3,
            color: colorThirdy,
            shadows: [
              Shadow(
                blurRadius: 6.0,
                color: Colors.grey.shade700,
                //offset: Offset(0.0, 0.0),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

//rating
class Rate extends StatelessWidget {
  final double rating;
  final rater;
  Rate(this.rating, this.rater);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          bool check = (rating / rater >= index + 1);
          return index == 5
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      rater == 0
                          ? '(0.0)'
                          : '(${(rating / rater).toPrecision(1)})',
                      style: TextStyle(
                        color: Colors.black26,
                        fontSize: 14,
                        letterSpacing: 3,
                      ),
                    ),
                    Text(
                      '$rater',
                      style: TextStyle(color: Colors.black26, fontSize: 12),
                    )
                  ],
                )
              : Icon(
                  Icons.star_rate,
                  color: Colors.yellow.withOpacity(check ? 1 : 0.3),
                  size: 20,
                );
        });
  }
}

rate(bool check) {
  return check
      ? Lottie.asset(rateAnimated, height: 400)
      : Icon(
          Icons.star,
          color: Colors.yellow.withOpacity(0.4),
        );
}

class IngreSection extends StatelessWidget {
  IngreSection({
    Key key,
    @required this.recette,
  }) : super(key: key);

  final recette;
  var recet = [];
  @override
  Widget build(BuildContext context) {
    recette.ingredient.forEach((element) {
      if (element.isNotEmpty) recet.add(element);
    });
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Ingrédients',
              style: TextStyle(
                  color: colorPrimary, fontFamily: fontprimary, fontSize: 24),
            ),
            Divider(color: colorPrimary, thickness: 1.0),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: recet.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colorPrimary,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(color: colorThirdy),
                      ),
                    ),
                    title: Text(
                      recet[index],
                      style: TextStyle(fontFamily: fontbody),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}

class InfoSection extends StatelessWidget {
  const InfoSection({
    Key key,
    @required this.recette,
  }) : super(key: key);

  final recette;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Informations',
          style: TextStyle(
              color: colorPrimary, fontFamily: fontprimary, fontSize: 24),
        ),
        Divider(color: colorPrimary, thickness: 1.0),
        ListTile(
          leading: Icon(Icons.fastfood),
          title: Text(
            recette.categorie,
            style: TextStyle(fontFamily: fontbody),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: ListTile(
                leading: Icon(Icons.people_alt),
                title: Text(
                  recette.personne,
                  style: TextStyle(fontFamily: fontbody),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                leading: Icon(Icons.timer),
                title: Text(
                  recette.time,
                  style: TextStyle(fontFamily: fontbody),
                ),
              ),
            ),
          ],
        ),
        ListTile(
          leading: Icon(Icons.rate_review),
          title: SizedBox(
              child: Obx(() =>
                  Rate(recette.rate + userRating.value, recetteRater.value)),
              height: 20),
        ),
        ListTile(
          leading: Icon(Icons.description),
          title: Text(
            recette.description,
            style: TextStyle(fontFamily: fontbody),
          ),
        ),
      ],
    );
  }
}

//
class UserSection extends StatelessWidget {
  const UserSection(
      {Key key,
      @required this.listMessage,
      @required this.isUser,
      @required this.index})
      : super(key: key);

  final List listMessage;
  final bool isUser;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: 4),
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('Chef')
            .doc(listMessage[index].userID)
            .get(),
        builder: (context, snapUser) {
          var user;

          if (snapUser.hasData) {
            user = snapUser.data;

            return Container(
              child: isUser
                  ? Container(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (user['admin'] == true)
                            Tooltip(
                              message: 'Administrateur',
                              child: Icon(
                                Icons.star_purple500_outlined,
                                color: Colors.amber,
                                size: 20,
                              ),
                            ),
                          Text(
                            user['nom'],
                            style: TextStyle(
                                fontFamily: fontbody,
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: CircleAvatar(
                              backgroundColor: colorSecondary,
                              backgroundImage: user['image'] == null
                                  ? AssetImage(profile)
                                  : NetworkImage(user['image']),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: CircleAvatar(
                            backgroundColor: colorSecondary,
                            backgroundImage: user['image'] == null
                                ? AssetImage(profile)
                                : NetworkImage(user['image']),
                          ),
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          user['nom'],
                          style: TextStyle(
                              fontFamily: fontbody,
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        if (user['admin'] == true)
                          Tooltip(
                            message: 'Administrateur',
                            child: Icon(
                              Icons.star_purple500_outlined,
                              color: Colors.amber,
                              size: 15,
                            ),
                          )
                      ],
                    ),
            );
          } else
            return Container();
        },
      ),
    );
  }
}

class MessageSection extends StatelessWidget {
  const MessageSection({
    Key key,
    @required this.isUser,
    @required this.listMessage,
    @required this.index,
  }) : super(key: key);

  final bool isUser;
  final List listMessage;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: isUser ? EdgeInsets.only(left: 70) : EdgeInsets.only(right: 70),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
              decoration: BoxDecoration(
                  color: !isUser ? Colors.grey.shade200 : colorPrimary.shade200,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                    topLeft:
                        !isUser ? Radius.circular(0.0) : Radius.circular(25.0),
                    topRight:
                        !isUser ? Radius.circular(25.0) : Radius.circular(0.0),
                  )),
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 13),
              child: InkWell(
                onLongPress: () {
                  Get.defaultDialog(
                      title: 'Suppression',
                      middleText: 'Voulez-vous supprimer ce message?',
                      actions: [
                        FlatButton(
                          onPressed: () async {
                            Get.back();
                          },
                          child: Text(
                            'Annuler',
                            style:
                                TextStyle(color: primary, fontFamily: fontbody),
                          ),
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        FlatButton(
                          onPressed: () async {
                            var delete = FirebaseFirestore.instance
                                .collection('Forum')
                                .where('date',
                                    isEqualTo: listMessage[index].date);
                            delete.get().then((value) {
                              value.docs.forEach((element) {
                                element.reference.delete();
                              });
                            });
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Supprimer',
                            style: TextStyle(
                                color: Colors.white, fontFamily: fontbody),
                          ),
                          color: Colors.red,
                        )
                      ]);
                },
                child: Text(
                  listMessage[index].message,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              )),
          (index == 0)
              ? Container(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    child: Text(
                      timeago.format(listMessage[index].date.toDate(),
                          locale: 'fr'),
                      style: TextStyle(
                          fontFamily: 'Ubuntu',
                          color: Colors.black45,
                          fontSize: 10),
                    ),
                  ))
              : (listMessage[index].userID == listMessage[index - 1].userID)
                  ? Container()
                  : Container(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        child: Text(
                          timeago.format(listMessage[index].date.toDate(),
                              locale: 'fr'),
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            color: Colors.black45,
                            fontSize: 10,
                          ),
                        ),
                      ))
        ],
      ),
    );
  }
}
