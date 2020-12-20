import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lesrecettesdebousta/constants/staticVariables.dart';
import 'package:lottie/lottie.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpinKitFoldingCube(
              color: color2,
              size: 40,
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
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
