//Log in console with same pretty output
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);
var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);
//image
var loadingLottie = 'assets/loadingCasserol.json';
var placeholder = 'assets/placeholder.png';
var profile = 'assets/profile.png';
var splashImage = 'assets/cookFemmeDebout.json';
var accueilLottie = 'assets/cooking.json';
//Font
var fontprimary = 'Lobster';
var fontsecondary = 'Kaushan';
var fontbody = 'MPLUS';
