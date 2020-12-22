import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';
import 'package:lesrecettesdebousta/constants/color.dart';
import 'package:lesrecettesdebousta/constants/staticVariables.dart';
import 'package:lesrecettesdebousta/constants/widget.dart';
import 'package:lottie/lottie.dart';

import 'package:provider/provider.dart';
import 'service/authentification.dart';

import 'service/authentification.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  // TabController tabController = TabController(length: 3, vsync: this);
  var tabIndex = 0;
  tabLogSign(int index) {
    switch (index) {
      case 0:
        return logSign();
        break;
      case 1:
        return log();
        break;
      case 2:
        return sign();
        break;
      default:
    }
  }

  TextEditingController mail = TextEditingController();
  TextEditingController password = TextEditingController();
  bool erreurPassword = false;
  bool erreurMail = false;
  bool connectable = true;
  connexionVerif() async {
    setState(() {
      isCharging = true;
    });
    if (!mail.text.isEmail) {
      setState(() {
        erreurMail = true;
      });
    } else {
      var check = await context
          .read<Authentification>()
          .connection(mail.text.trim(), password.text.trim());
      Get.rawSnackbar(
          title: 'Connexion',
          message: check,
          icon: (check == 'Connexion réussi, ravis de vous revoir')
              ? Icon(Icons.verified, color: Colors.white)
              : Icon(
                  Icons.error_sharp,
                  color: Colors.red,
                ));
      switch (check) {
        case 'Connexion réussie, ravis de vous revoir':
          //go home
          break;
        case 'L\'Email est incorrect':
          setState(() {
            erreurMail = true;
          });
          break;
        case 'Le mot de passe est incorrect':
          setState(() {
            erreurPassword = true;
            erreurMail = false;
          });
          break;
        default:
      }
    }
    setState(() {
      isCharging = false;
    });
  }

  /////////////////
  /////////////////Section enregistrement
  TextEditingController mailE = TextEditingController();
  TextEditingController passwordE = TextEditingController();
  TextEditingController nomE = TextEditingController();
  bool erreurPasswordE = false;
  bool erreurMailE = false;
  bool erreurNomE = false;
  bool connectableE = true;
  enregistrementVerif() async {
    setState(() {
      isCharging = true;
    });
    if (!mailE.text.isEmail) {
      Get.rawSnackbar(
          title: 'Enregistrement',
          message: 'L\'Email est incorrect',
          icon: Icon(
            Icons.error_sharp,
            color: Colors.red,
          ));
      setState(() {
        erreurMailE = true;
      });
    } else {
      var check = await context.read<Authentification>().enregistrementAuth(
          mailE.text.trim(), passwordE.text.trim(), nomE.text.trim());
      Get.rawSnackbar(
          title: 'Enregistrement',
          message: check,
          icon: (check == 'Enregistrement réussi, bienvenue à vous')
              ? Icon(Icons.verified, color: Colors.white)
              : Icon(
                  Icons.error_sharp,
                  color: Colors.red,
                ));

      switch (check) {
        case 'Enregistrement réussi, bienvenue à vous':

          //go home
          break;
        case 'Email existe déjà':
          setState(() {
            erreurMailE = true;
          });
          setState(() {
            isCharging = false;
          });
          break;
        case 'Le mot de passe est trop faible, minimum 6 caratères':
          setState(() {
            erreurPasswordE = true;
            erreurMailE = false;
          });
          setState(() {
            isCharging = false;
          });
          break;
        case 'L\'Email est invalide':
          setState(() {
            erreurMailE = true;
          });
          setState(() {
            isCharging = false;
          });
          break;
        default:
      }
    }
  }

//bool
  var isCharging = false;
  var isShowing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorSecondary,
      body: Container(
        child: Column(
          children: [
            BigTitle(),
            SplashLottie(),
            Expanded(
              child: Column(
                children: [
                  Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: colorPrimary,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            //offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                      child: tabIndex == 0
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.arrow_back_ios,
                                        color: colorThirdy),
                                    onPressed: () {
                                      setState(() {
                                        tabIndex = 0;
                                      });
                                    }),
                                RaisedButton(
                                    color: (tabIndex == 1)
                                        ? colorSecondary
                                        : colorPrimary,
                                    elevation: (tabIndex == 1) ? 3 : 0,
                                    onPressed: () {
                                      setState(() {
                                        tabIndex = 1;
                                      });
                                    },
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Text(
                                      'connexion',
                                      style: TextStyle(
                                          fontFamily: fontsecondary,
                                          fontSize: 15),
                                    )),
                                RaisedButton(
                                    elevation: (tabIndex == 2) ? 3 : 0,
                                    color: (tabIndex == 2)
                                        ? colorSecondary
                                        : colorPrimary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    onPressed: () {
                                      setState(() {
                                        tabIndex = 2;
                                      });
                                    },
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      'enregistrement',
                                      style: TextStyle(
                                          fontFamily: fontsecondary,
                                          fontSize: 15),
                                    ))
                              ],
                            )),
                  Expanded(
                      child: Container(
                    color: colorPrimary,
                    child: tabLogSign(tabIndex),
                  ) //logSign(),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  log() {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // SizedBox(height: 20),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: colorSecondary,
                child: TextFormField(
                  controller: mail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: new InputDecoration(
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.mail),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintStyle: TextStyle(
                          color: Colors.black26, fontFamily: fontbody),
                      contentPadding: EdgeInsets.only(left: 15, right: 15),
                      hintText: 'Email'),
                ),
              ),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: colorSecondary,
                child: TextFormField(
                  controller: password,
                  obscureText: isShowing ? false : true,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(!isShowing
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            isShowing = !isShowing;
                          });
                        },
                      ),
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.lock),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintStyle: TextStyle(
                          color: Colors.black26, fontFamily: fontbody),
                      contentPadding:
                          EdgeInsets.only(left: 15, right: 15, top: 10),
                      hintText: 'Mot de passe'),
                ),
              ),
              SizedBox(),
              Text(
                  'Si vous n\'avez pas encore un compte, veuilez-vous s\'enregistrer',
                  style: TextStyle(
                      fontFamily: fontbody, color: colorThirdy, fontSize: 13),
                  textAlign: TextAlign.center),
              SizedBox(
                height: 20,
              ),
              isCharging
                  ? Container()
                  : FloatingActionButton(
                      backgroundColor: colorThirdy,
                      elevation: 10,
                      onPressed: connexionVerif,
                      child: Icon(Icons.navigate_next, color: colorSecondary),
                    )
            ],
          )),
    );
  }

  sign() {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // SizedBox(height: 20),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: colorSecondary,
                child: TextFormField(
                  controller: nomE,
                  keyboardType: TextInputType.emailAddress,
                  decoration: new InputDecoration(
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.person),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintStyle: TextStyle(
                          color: Colors.black26, fontFamily: fontbody),
                      contentPadding: EdgeInsets.only(left: 15, right: 15),
                      hintText: 'Nom'),
                ),
              ),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: colorSecondary,
                child: TextFormField(
                  controller: mailE,
                  keyboardType: TextInputType.emailAddress,
                  decoration: new InputDecoration(
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.mail),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintStyle: TextStyle(
                          color: Colors.black26, fontFamily: fontbody),
                      contentPadding: EdgeInsets.only(left: 15, right: 15),
                      hintText: 'Email'),
                ),
              ),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: colorSecondary,
                child: TextFormField(
                  controller: passwordE,
                  obscureText: isShowing ? false : true,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(!isShowing
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            isShowing = !isShowing;
                          });
                        },
                      ),
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.lock),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintStyle: TextStyle(
                          color: Colors.black26, fontFamily: fontbody),
                      contentPadding:
                          EdgeInsets.only(left: 15, right: 15, top: 10),
                      hintText: 'Mot de passe'),
                ),
              ),

              SizedBox(),
              Text('Si vous avez déjà un compte, veuilez-vous connecter',
                  style: TextStyle(
                      fontFamily: fontbody, color: colorThirdy, fontSize: 13),
                  textAlign: TextAlign.center),
              SizedBox(
                height: 20,
              ),
              isCharging
                  ? Container()
                  : FloatingActionButton(
                      backgroundColor: colorThirdy,
                      elevation: 10,
                      onPressed: enregistrementVerif,
                      child: Icon(Icons.navigate_next, color: colorSecondary),
                    )
            ],
          )),
    );
  }

  Widget logSign() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SignInButton(Buttons.FacebookNew,
                text: "Continuer avec Facebook",
                onPressed: () {},
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            SignInButton(Buttons.Google,
                text: "Continuer avec Google",
                onPressed: () {},
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            SignInButton(Buttons.Email, text: "Continuer avec un email",
                onPressed: () {
              setState(() {
                tabIndex = 1;
              });
            },
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            Expanded(
              child: Center(
                child: IconButton(
                    icon: Icon(
                      Icons.info,
                      color: colorSecondary,
                    ),
                    onPressed: () {}),
              ),
            )
          ],
        ),
      ),
    );
  }
}
