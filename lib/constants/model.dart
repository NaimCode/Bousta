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
Etape temp2 = Etape(imageFile: tempFile, imageUrl: tempUrl);

//class Recette
class Recette {
  String titre;
  String description;
  String time;
  String personne;
  List ingredient;
  String categorie;
  String image;
  String video;
  double rate;
  int rater;

  Recette.fromDoc(var data) {
    titre = data['titre'];
    description = data['description'];
    time = data['time'];
    personne = data['personne'];
    ingredient = data['ingredienta'];
    rate = data['rate'];
    rater = data['rater'];
    image = data['image'];
    categorie = data['categorie'];
    video = data['video'] ?? null;
  }
}

class Chef {
  String uid;
  String nom;
  String email;
  String password;
  String image;

  bool admin;
  List<String> favori, historique;
  Chef.fromMap(Map<String, dynamic> data) {
    nom = data['nom'];
    uid = data['ville'];
    image = data['image'];
    email = data['email'];
    password = data['password'];
    favori = data['favori'];
    historique = data['historique'];
    admin = data['admin'];
  }

  Chef({this.uid, this.nom, this.password, this.email, this.image, this.admin});
}
