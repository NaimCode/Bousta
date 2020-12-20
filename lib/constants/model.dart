import 'dart:io';

import 'package:flutter/material.dart';

List<TextEditingController> listIngredientController = [
  TextEditingController()
];

class Etape {
  String imageUrl;
  File imageFile;
  Etape({this.imageUrl, this.imageFile});
}

List<TextEditingController> listEtapeController = [TextEditingController()];
File tempFile;
String tempUrl;
Etape temp1 = Etape(imageFile: tempFile, imageUrl: tempUrl);

//class Recette
class Chef {
  String uid;
  String nom;
  String email;
  String password;
  String image;

  bool admin;

  Chef.fromMap(Map<String, dynamic> data) {
    nom = data['nom'];
    uid = data['ville'];
    image = data['image'];
    email = data['email'];
    password = data['password'];

    admin = data['admin'];
  }
  Chef.fromDoc(var data) {
    nom = data['nom'];
    uid = data['ville'];
    image = data['image'];
    email = data['email'];
    password = data['password'];

    admin = data['admin'];
  }
  Chef({this.uid, this.nom, this.password, this.email, this.image, this.admin});
}
