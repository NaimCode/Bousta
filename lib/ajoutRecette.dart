import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:file_picker/file_picker.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_pickers/image_pickers.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:lesrecettesdebousta/constants/color.dart';
import 'package:lesrecettesdebousta/constants/staticVariables.dart';
import 'package:lesrecettesdebousta/constants/widget.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:video_compress/video_compress.dart';
import 'constants/model.dart';

class AjoutRecette extends StatefulWidget {
  @override
  _AjoutRecetteState createState() => _AjoutRecetteState();
}

class _AjoutRecetteState extends State<AjoutRecette> {
  //Controller
  TextEditingController titre = TextEditingController();
  TextEditingController categorie = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController personne = TextEditingController();
  TextEditingController time = TextEditingController();
  final fb = FirebaseFirestore.instance;
//  var picker = ImagePicker();
  String imagePricipalUrl;
  var imagePricipal;
  var userA;
  String videoUrl;
  File video;
  //bool
  bool isChargingVideo = false;
  bool isChargingImage = false;
  bool isCharging = false;
  bool isChargingimageP = false;
  void selectImagePricipal() async {
    var result = await ImagePickers.pickerPaths(
      galleryMode: GalleryMode.image,
    );
    if (result != null) {
      setState(() {
        imagePricipal = File(result.first.path);
      });
    }
  }

  void selectImageEtape(int index) async {
    var rui = await ImagePickers.pickerPaths(
      galleryMode: GalleryMode.image,
    );
    if (rui != null) {
      setState(() {
        imageEtape[index].imageFile = File(rui.first.path);
      });
    }
  }

  void selectVideo() async {
    var result = await ImagePickers.pickerPaths(
      galleryMode: GalleryMode.video,
    );

    if (result != null) {
      setState(() {
        isChargingVideo = true;
      });
      print('debut');
      MediaInfo mediaInfo = await VideoCompress.compressVideo(
        result.first.path,
        quality: VideoQuality.DefaultQuality,
        deleteOrigin: false, // It's false by default
      );
      setState(() {
        video = mediaInfo.file;

        isChargingVideo = false;
      });
    }
  }

  uploadRecette() async {
    if (imagePricipal != null &&
        titre.text != '' &&
        categorie.text != '' &&
        description.text != '' &&
        time.text != '' &&
        personne.text != '' &&
        listIngredientController.length >= 1 &&
        listEtapeController.length >= 1) {
      setState(() {
        isCharging = true;
      });
      //supp
      for (var j = 0; j < 10; j++) {
        if (video != null) {
          var videoBasename = basename(video.path);
          var ref = FirebaseStorage.instance
              .ref()
              .child('Recette/$j-${titre.text}/$videoBasename');

          var uploadTask = ref.putFile(video);
          await uploadTask.then((task) async {
            videoUrl = await task.ref.getDownloadURL();
          });
        }
        var imageBasename = basename(imagePricipal.path);
        var ref1 = FirebaseStorage.instance
            .ref()
            .child('Recette/$j-${titre.text}/$imageBasename');
        var uploadTask1 = ref1.putFile(imagePricipal);
        await uploadTask1.then((task) async {
          imagePricipalUrl = await task.ref.getDownloadURL();
        });

        for (var i = 0; i < imageEtape.length; i++) {
          if (imageEtape[i].imageFile != null) {
            var bse = basename(imageEtape[i].imageFile.path);
            var ref = FirebaseStorage.instance
                .ref()
                .child('Recette/$j-${titre.text}/Etape/${i + 1}-$bse');
            var uploadTask = ref.putFile(imageEtape[i].imageFile);
            await uploadTask.then((task) async {
              imageEtape[i].imageUrl = await task.ref.getDownloadURL();
              print(imageEtape[i].imageUrl);
            });
          }
        }
        var listIng = [];
        listIngredientController.forEach((element) {
          listIng.add(element.text);
        });
        var recette = {
          'rater': 0,
          'rate': 0.0,
          'video': videoUrl,
          'titre': titre.text,
          'image': imagePricipalUrl,
          'description': description.text,
          'personne': personne.text,
          'time': time.text,
          'categorie': categorie.text,
          'ingredienta': listIng,
        };

        await FirebaseFirestore.instance
            .collection('Recette')
            .doc('${j + 1}-${titre.text}')
            .set(recette);
        for (var i = 0; i < listEtapeController.length; i++) {
          var etape = {
            'description': listEtapeController[i].text,
            'image': imageEtape[i].imageUrl,
          };
          await FirebaseFirestore.instance
              .collection('Recette')
              .doc('${j + 1}-${titre.text}')
              .collection('Etape')
              .doc('${i + 1}')
              .set(etape);
        }
      }
      setState(() {
        listIngredientController.forEach((element) {
          element.clear();
        });
        listEtapeController.forEach((element) {
          element.clear();
        });
        imageEtape = imageEtapeInit;
        etape = etapInit;
        ingredient = ingredientInit;
        titre.clear();
        categorie.clear();
        time.clear();
        personne.clear();
        description.clear();
        video = null;
        videoUrl = null;
        imagePricipalUrl = null;
        imagePricipal = null;
        isCharging = false;
      });
      Get.rawSnackbar(
          title: 'Recette',
          message: 'Votre recette a été bien mise en ligne',
          icon: Icon(Icons.verified, color: Colors.white));
    } else {
      Get.rawSnackbar(
          title: 'Recette',
          message: 'Veuillez remplir tous les champs',
          icon: Icon(Icons.error, color: Colors.red));
    }
  }
//  TextEditingController controller = TextEditingController();

  List<TextFormField> ingredient = [
    textEditingIngredient(listIngredientController[0])
  ];

  List<Etape> imageEtape = [temp1];
  List<TextFormField> etape = [textEditingEtape(listEtapeController[0])];
  var etapInit = [textEditingEtape(listEtapeController[0])];
  var imageEtapeInit = [temp2];
  var ingredientInit = [textEditingIngredient(listIngredientController[0])];
  @override
  Widget build(BuildContext context) {
    //print('${listIngredientController[1].text}');
    // double heighAnimatedIngredient = 53.0 * ingredientCounter;
    return isCharging
        ? ChargementLottie(colorPrimary)
        : Scaffold(
            backgroundColor: colorSecondary,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: colorPrimary,
              title: Hero(
                  tag: 'addIcon',
                  child: navBarTitleText('Ajout d\'une recette', colorThirdy)),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    image(),
                    Center(
                        child: navBarTitleText('Informations', colorPrimary)),
                    name(context),
                    type(context),
                    personTime(context),
                    desc(context),
                    SizedBox(
                      height: 10,
                    ),
                    videoFunctio(),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: navBarTitleText('Ingrédients', colorPrimary),
                    ),

                    SizedBox(
                      height: 8,
                    ),
                    ingredientListViez(),
                    addIngredient(),
                    SizedBox(
                      height: 10,
                    ),
                    Center(child: navBarTitleText('Etapes', colorPrimary)),
                    SizedBox(
                      height: 8,
                    ),
                    etapetListViez(),
                    addEtape(),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton.icon(
                        color: colorPrimary,
                        onPressed: () async {
                          var check = await confirmationDialog(
                              'Publication',
                              'Confirmez votre décision',
                              Icons.cloud_download,
                              context);
                          if (check == 'oui') {
                            uploadRecette();
                          }
                          // uploadRecette,
                        },
                        icon: Icon(Icons.add),
                        label: Text(
                          'Ajouter la recette',
                          style: TextStyle(fontSize: 18),
                        ))
                    // ListView.builder(itemBuilder: null)
                  ],
                ),
              ),
            ),
          );
  }

  Center addIngredient() {
    return Center(
      child: OutlineButton.icon(
          onPressed: () {
            TextEditingController controller = TextEditingController();
            setState(() {
              listIngredientController.add(controller);
              ingredient.add(textEditingIngredient(controller));
            });
          },
          color: colorPrimary,
          icon: Icon(Icons.add),
          label: Text('Ajouter un ingédient')),
    );
  }

  Center addEtape() {
    return Center(
      child: OutlineButton.icon(
          onPressed: () {
            TextEditingController controller = TextEditingController();
            setState(() {
              listEtapeController.add(controller);
              etape.add(textEditingEtape(controller));
              imageEtape.add(Etape(imageFile: tempFile, imageUrl: tempUrl));
            });
          },
          color: colorPrimary,
          icon: Icon(Icons.add),
          label: Text('Ajouter une étape')),
    );
  }

  Flexible ingredientListViez() {
    return Flexible(
      fit: FlexFit.loose,
      child: AnimatedContainer(
        height: 65.0 * ingredient.length,
        duration: Duration(milliseconds: 100),
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: ingredient.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    //                    <--- top side
                    color: colorPrimary,
                    width: 2.0,
                  ),
                ),
                child: ListTile(
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        ingredient.remove(ingredient[index]);
                        print('${listIngredientController[index].text}');
                        listIngredientController
                            .remove(listIngredientController[index]);
                      });
                    },
                  ),
                  leading: CircleAvatar(
                    backgroundColor: colorPrimary,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  title: ingredient[index],
                ),
              );
            }),
      ),
    );
  }

  Flexible etapetListViez() {
    return Flexible(
      fit: FlexFit.loose,
      child: AnimatedContainer(
        height: 338.0 * etape.length,
        duration: Duration(milliseconds: 100),
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: etape.length,
            itemBuilder: (context, index) {
              var imageEtapeInlist;
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    //                    <--- top side
                    color: colorPrimary,
                    width: 2.0,
                  ),
                ),
                margin: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        selectImageEtape(index);
                      },
                      child: Card(
                        child: Container(
                          decoration: (imageEtape[index].imageFile == null)
                              ? BoxDecoration(color: colorSecondary)
                              : BoxDecoration(
                                  color: colorSecondary,
                                  image: DecorationImage(
                                      image: FileImage(
                                        imageEtape[index].imageFile,
                                      ),
                                      fit: BoxFit.fitWidth)),
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: colorPrimary,
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.remove_circle,
                                          color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          etape.remove(etape[index]);
                                          print(
                                              '${listEtapeController[index].text}');
                                          listEtapeController.remove(
                                              listEtapeController[index]);
                                          imageEtape.remove(imageEtape[index]);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                (imageEtape[index].imageFile == null)
                                    ? Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.add_photo_alternate,
                                                color: Colors.black26),
                                            Text(
                                              'Ajouter l\'image de l\'étape',
                                              style: TextStyle(
                                                  fontFamily: fontbody,
                                                  color: Colors.black26),
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 110,
                      child: etape[index],
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }

  Container image() {
    return Container(
      height: 230,
      width: double.infinity,
      child: Card(
        elevation: 5,
        child: InkWell(
          onTap: selectImagePricipal,
          child: isChargingimageP
              ? miniChargement(colorSecondary, colorPrimary)
              : Container(
                  child: (imagePricipal != null)
                      ? Image.file(
                          imagePricipal,
                          fit: BoxFit.cover,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate,
                                color: Colors.black26),
                            Text(
                              'Ajouter l\'image principale',
                              style: TextStyle(
                                  fontFamily: fontbody, color: Colors.black26),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                ),
        ),
      ),
    );
  }

  Container videoFunctio() {
    return Container(
      height: 200,
      width: double.infinity,
      child: Card(
        elevation: 5,
        child: InkWell(
          onTap: selectVideo,
          child: isChargingVideo
              ? ChargementLottie(colorPrimary)
              : Container(
                  child: (video != null)
                      ? AspectRatio(
                          aspectRatio: 16 / 9,
                          child: BetterPlayer.file(
                            video.path,
                            betterPlayerConfiguration:
                                BetterPlayerConfiguration(
                              aspectRatio: 16 / 9,
                            ),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.video_library, color: Colors.black26),
                            Text(
                              'Ajouter une vidéo',
                              style: TextStyle(
                                  fontFamily: fontbody, color: Colors.black26),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                ),
        ),
      ),
    );
  }

  Container name(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: titre,
        keyboardType: TextInputType.text,
        cursorColor: Theme.of(context).cursorColor,
        decoration: InputDecoration(
          icon: Icon(Icons.fastfood),
          labelStyle: TextStyle(fontFamily: fontsecondary),
          labelText: 'Nom de la recette',
        ),
        style: TextStyle(fontFamily: fontbody),
      ),
    );
  }

  Container type(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: categorie,
        keyboardType: TextInputType.text,
        cursorColor: Theme.of(context).cursorColor,
        decoration: InputDecoration(
            icon: Icon(Icons.food_bank),
            labelStyle: TextStyle(fontFamily: fontsecondary),
            labelText: 'Catégorie',
            helperStyle: TextStyle(color: Colors.black26),
            helperText: 'exemple: Dessert, Soupe,etc'),
        style: TextStyle(fontFamily: fontbody),
      ),
    );
  }

  Container personTime(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: personne,
              keyboardType: TextInputType.number,
              cursorColor: Theme.of(context).cursorColor,
              decoration: InputDecoration(
                  icon: Icon(Icons.people),
                  labelStyle: TextStyle(fontFamily: fontsecondary),
                  labelText: 'Personnes',
                  helperStyle: TextStyle(color: Colors.black26),
                  helperText: 'exemple: 4'),
              style: TextStyle(fontFamily: fontbody),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: time,
              cursorColor: Theme.of(context).cursorColor,
              decoration: InputDecoration(
                  icon: Icon(Icons.timer),
                  labelStyle: TextStyle(fontFamily: fontsecondary),
                  labelText: 'Temps',
                  helperStyle: TextStyle(color: Colors.black26),
                  helperText: 'exemple: 2h15'),
              style: TextStyle(fontFamily: fontbody),
            ),
          ),
        ],
      ),
    );
  }

  Container desc(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: description,
        keyboardType: TextInputType.multiline,
        maxLines: 4,
        cursorColor: Theme.of(context).cursorColor,
        decoration: InputDecoration(
          icon: Icon(Icons.description),
          labelStyle: TextStyle(fontFamily: fontsecondary),
          labelText: 'Description',
        ),
        style: TextStyle(fontFamily: fontbody),
      ),
    );
  }
}
