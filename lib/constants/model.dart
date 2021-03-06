import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  String uid;
  int rater;
  bool recetteDuJour;
  Recette(
      {this.titre,
      this.image,
      this.video,
      this.ingredient,
      this.rate,
      this.rater,
      this.description,
      this.time,
      this.personne,
      this.categorie,
      this.uid});
  Recette.fromDoc(var data, String id) {
    titre = data['titre'];
    description = data['description'];
    time = data['time'];
    personne = data['personne'];
    ingredient = data['ingredienta'];
    rate = data['rate'];
    rater = data['rater'];
    image = data['image'];
    uid = id;
    recetteDuJour = data['recette du jour'];
    categorie = data['categorie'];
    video = data['video'] ?? null;
  }
}

class Categorie {
  String nom;
  String image;
  Categorie(this.nom, this.image);
}

class Chef {
  String uid;
  String nom;
  String email;
  String password;
  String image;

  bool admin;
  List favori, historique;
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
  Chef.fromDoc(var data) {
    nom = data['nom'];
    uid = data['ville'];
    image = data['image'];
    email = data['email'];
    password = data['password'];
    favori = data['favori'];
    historique = data['historique'];
    admin = data['admin'];
  }
  Chef(
      {this.uid,
      this.nom,
      this.password,
      this.email,
      this.image,
      this.admin,
      this.favori,
      this.historique});
}

class Discussion {
  String userID;
  String message;
  Timestamp date;
  Discussion({this.userID, this.message, this.date});
}

class RecetteDetail {
  Chef user;
  Recette recette;
  RecetteDetail(this.user, this.recette);
}
