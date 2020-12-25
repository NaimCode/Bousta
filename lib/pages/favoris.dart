import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:lesrecettesdebousta/constants/color.dart';
import 'package:lesrecettesdebousta/constants/model.dart';
import 'package:lesrecettesdebousta/constants/staticVariables.dart';
import 'package:lesrecettesdebousta/constants/widget.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:slimy_card/slimy_card.dart';
import 'package:get/get.dart';

class Favoris extends StatefulWidget {
  @override
  _FavorisState createState() => _FavorisState();
}

class _FavorisState extends State<Favoris> {
  Chef user;
  var isCharging = false.obs;
  var nameController = TextEditingController();
  changeName(BuildContext context) async {
    if (nameController.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('Chef')
          .doc(user.uid)
          .update({'nom': nameController.text});
    }
    Navigator.pop(context);
  }

  changeImage() async {
    var url;
    var result = await ImagePickers.pickerPaths(
      galleryMode: GalleryMode.image,
    );
    if (result != null) {
      isCharging.value = true;

      var file = File(result.first.path);
      var filepath = basename(file.path);
      var ref =
          FirebaseStorage.instance.ref().child('Chef/${user.uid}$filepath');
      var uploadTask = ref.putFile(file);
      await uploadTask.then((task) async {
        url = await task.ref.getDownloadURL();
      });
      await FirebaseFirestore.instance
          .collection('Chef')
          .doc(user.uid)
          .update({'image': url});
      isCharging.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    user = context.watch<Chef>();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SlimyCard(
            color: colorPrimary,
            width: Get.width,
            topCardHeight: Get.height / 2,
            bottomCardHeight: 100,
            borderRadius: 20,
            topCardWidget: Padding(
              padding: EdgeInsets.only(bottom: 30.0),
              child: Container(
                child: Column(
                  children: [
                    Expanded(
                        child: Obx(
                      () => isCharging.value
                          ? Chargement(colorPrimary, colorThirdy)
                          : CircleAvatar(
                              radius: Get.height / 6,
                              backgroundColor: Colors.white,
                              backgroundImage: user.image == null
                                  ? AssetImage(profile)
                                  : NetworkImage(user.image),
                            ),
                    )),
                    Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          user.nom,
                          style: TextStyle(
                              color: colorThirdy,
                              fontSize: 18,
                              fontFamily: fontbody,
                              letterSpacing: 2),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.mail),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          user.email,
                          style: TextStyle(
                              color: colorThirdy,
                              fontSize: 18,
                              fontFamily: fontbody,
                              letterSpacing: 2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottomCardWidget: Container(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          'Changer de photo?',
                          style: TextStyle(
                              fontFamily: fontbody, color: Colors.black38),
                        ),
                        FloatingActionButton(
                            heroTag: null,
                            elevation: 6,
                            backgroundColor: colorSecondary,
                            child:
                                Icon(Icons.add_a_photo, color: Colors.black38),
                            onPressed: changeImage)
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          'Changer de nom?',
                          style: TextStyle(
                              fontFamily: fontbody, color: Colors.black38),
                        ),
                        FloatingActionButton(
                            heroTag: null,
                            elevation: 6,
                            backgroundColor: colorSecondary,
                            child: Icon(Icons.edit, color: Colors.black38),
                            onPressed: () {
                              Get.defaultDialog(
                                  title: 'Changer votre nom',
                                  content: Card(
                                    elevation: 6,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    color: colorSecondary,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            onFieldSubmitted: (v) {
                                              changeName(context);
                                            },
                                            controller: nameController,
                                            keyboardType: TextInputType.text,
                                            decoration: new InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                hintStyle: TextStyle(
                                                    color: Colors.black26,
                                                    fontFamily: fontbody),
                                                contentPadding: EdgeInsets.only(
                                                    left: 15, right: 15),
                                                hintText: user.nom),
                                          ),
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.black87,
                                            ),
                                            onPressed: () {
                                              changeName(context);
                                            })
                                      ],
                                    ),
                                  ));
                            })
                      ],
                    ),
                  )
                ],
              ),
            ),
            slimeEnabled: true,
          ),
        ),
      ),
    );
  }
}
