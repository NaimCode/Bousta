import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firestoreinstance = FirebaseFirestore.instance;

//final facebookSignIn = FacebookLoginWeb();

class Authentification {
  FirebaseAuth _firebaseAuth;
  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();
  Authentification(this._firebaseAuth);
  deconnection() async {
    await _firebaseAuth.signOut();
  }

  signInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'Fluse': 'wfluse@gmail.com'});

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithPopup(googleProvider).then((value) {
      print(value.user.displayName);
      var user = value.user;
      print(user.displayName);
      FirebaseFirestore.instance
          .collection('Utilisateur')
          .doc(user.uid)
          .get()
          .then((value) async {
        if (!value.exists) {
          print('enregistrement');

          var utilisateurs = {
            'nom': user.displayName,
            'email': user.email,
            'password': null,
            'image': user.photoURL,
            'universite': null,
            'semestre': null,
            'filiere': null,
            'admin': false,
            'uid': user.uid,
          };

          await firestoreinstance
              .collection('Utilisateur')
              .doc(user.uid)
              .set(utilisateurs);
        }
      });
    });

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }

  signInWithFacebook() async {
    //final FacebookLoginResult result =
    //   await facebookSignIn.logIn(['email', 'public_profile']);

    FacebookAuthProvider facebookProvider = FacebookAuthProvider();

    facebookProvider.addScope('email');

    facebookProvider.setCustomParameters({
      'display': 'popup',
    });

    // Once signed in, return the UserCredential
    FirebaseAuth.instance.signInWithPopup(facebookProvider).then((value) {
      var user = value.user;
      print(user.displayName);
      FirebaseFirestore.instance
          .collection('Utilisateur')
          .doc(user.uid)
          .get()
          .then((value) async {
        if (!value.exists) {
          print('enregistrement');

          var utilisateurs = {
            'nom': user.displayName,
            'email': user.email,
            'password': null,
            //'image': profile,
            'universite': null,
            'semestre': null,
            'filiere': null,
            'admin': false,
            'uid': user.uid,
          };

          await firestoreinstance
              .collection('Utilisateur')
              .doc(user.uid)
              .set(utilisateurs);
        }
      });
    });

    // switch (result.status) {
    //   case FacebookLoginStatus.loggedIn:
    //     final FacebookAccessToken accessToken = result.accessToken;

    //     print('$accessToken');
    //     print(result.accessToken.userId);

    //     facebookSignIn.testApi();
    //     break;
    //   case FacebookLoginStatus.cancelledByUser:
    //     print('annuler');
    //     break;
    //   case FacebookLoginStatus.error:
    //     print('erreur');
    //     break;
    // }
  }

  enregistrementAuth(String mail, String password, String nom) async {
    try {
      var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mail,
        password: password,
      );
      try {
        await user.user.sendEmailVerification();
        String image;
        bool admin = false;
        var utilisateurs = {
          'nom': nom,
          'email': user.user.email,
          'password': password,
          'image': image,
          'admin': admin,
          'uid': user.user.uid,
        };

        await firestoreinstance
            .collection('Chef')
            .doc(user.user.uid)
            .set(utilisateurs);
        return 'Enregistrement réussi, bienvenue à vous';
      } catch (e) {
        return 'L\'Email est invalide';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'Le mot de passe est trop faible, minimum 6 caratères';
      } else if (e.code == 'email-already-in-use') {
        return 'Email existe déjà';
      }
    } catch (e) {
      print(e);
      return 'erreur';
    }
  }

  connection(String mail, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: mail, password: password);
      return 'Connexion réussi, ravis de vous revoir';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'L\'Email est incorrect';
      } else if (e.code == 'wrong-password') {
        return 'Le mot de passe est incorrect';
      }
    }
  }
}
