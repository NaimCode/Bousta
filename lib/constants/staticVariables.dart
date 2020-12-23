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
var favoriteAnimated = 'assets/favorite.json';
//Font
var fontprimary = 'Lobster';
var fontsecondary = 'Kaushan';
var fontbody = 'MPLUS';
//  Padding(
//               padding: const EdgeInsets.only(
//                   left: 8.0, right: 8.0, top: 8.0, bottom: 17),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Card(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         children: [
//                           InfoSection(recette: recette),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   IngreSection(recette: recette),
//                 ],
//               ),
//             ),
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     Text(
//                       'Étapes',
//                       style: TextStyle(
//                           color: colorPrimary,
//                           fontFamily: fontprimary,
//                           fontSize: 24),
//                     ),
//                     Divider(color: colorPrimary, thickness: 1.0),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               height: 500.0 * etape,
//               child: FutureBuilder(
//                   future: future,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting)
//                       return SpinKitChasingDots(
//                         color: colorPrimary,
//                         size: 30,
//                       );
//                     return ListView.builder(
//                         physics: NeverScrollableScrollPhysics(),
//                         itemCount: etape,
//                         itemBuilder: (context, index) {
//                           return Padding(
//                               padding: EdgeInsets.only(bottom: 10),
//                               child: Card(
//                                 child: Column(
//                                   children: [
//                                     (etapeI[index] == null)
//                                         ? Container()
//                                         : Container(
//                                             height: 200,
//                                             width: double.infinity,
//                                             child: Image.network(
//                                               etapeI[index],
//                                               fit: BoxFit.cover,
//                                               loadingBuilder: (context, child,
//                                                   loadingProgress) {
//                                                 if (loadingProgress == null)
//                                                   return child;
//                                                 return SpinKitChasingDots(
//                                                   color: colorPrimary,
//                                                   size: 26,
//                                                 );
//                                               },
//                                             ),
//                                           ),
//                                     ListTile(
//                                       leading: CircleAvatar(
//                                         backgroundColor: colorPrimary,
//                                         child: Text(
//                                           '${index + 1}',
//                                           style: TextStyle(color: colorThirdy),
//                                         ),
//                                       ),
//                                       title: Text(
//                                         etapeT[index],
//                                         style: TextStyle(fontFamily: fontbody),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ));
//                         });
//                   }),
//             ),
//             SizedBox(
//               height: 40,
//             ),
