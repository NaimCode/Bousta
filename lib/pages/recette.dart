import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lesrecettesdebousta/constants/color.dart';
import 'package:lesrecettesdebousta/constants/model.dart';
import 'package:lesrecettesdebousta/constants/staticVariables.dart';
import 'package:expandable_card/expandable_card.dart';
import 'package:lesrecettesdebousta/constants/widget.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RecettePage extends StatefulWidget {
  // final Recette recette;
  // RecettePage(this.recette);
  @override
  _RecettePageState createState() => _RecettePageState();
}

var canCom = false.obs;
var userRating = 0.0.obs;

class _RecettePageState extends State<RecettePage> {
  var recette;
  var userChef;
  var future;
  var recetteDetail;
  List etapeT = [];
  List etapeI = [];
  ScrollController _scrollController = ScrollController();

  bool lastStatus = true;
  bool isShrink = false;
  _scrollListener() {
    if (_scrollController.offset > 120.0) {
      setState(() {
        isShrink = true;
      });
    } else
      setState(() {
        isShrink = false;
      });
  }

  TextEditingController messageText = TextEditingController();
  sendMessage() async {
    if (!canCom.value) {
      Get.snackbar('Erreur', 'Veuillez noter avant de commenter');
    } else if (messageText.text.isNotEmpty) {
      var message = {
        'userID': userChef,
        'message': messageText.text,
        'date': Timestamp.now(),
      };
      print('middle');
      await FirebaseFirestore.instance
          .collection('Recipe')
          .doc(recette.uid)
          .collection('Discussion')
          .add(message);
      setState(() {
        messageText.clear();
      });
    }
  }

  int etape = 3;
  getEtape() async {
    var listinit = [];
    var listinitT = [];
    var qn = await FirebaseFirestore.instance
        .collection('Recipe')
        .doc(Get.arguments.recette.uid)
        .collection('Etape')
        .get();

    qn.docs.forEach((element) {
      listinit.add(element.data()['image']);
      listinitT.add(element.data()['description']);
    });

    setState(() {
      etape = qn.docs.length;
      etapeT = listinitT;
      etapeI = listinit;
    });
    return 'Complete';
  }

  setHistorique() async {
    List historique = Get.arguments.user.historique;
    if (historique.length > 20) historique.removeAt(0);
    historique.add(Get.arguments.recette.uid);
    await FirebaseFirestore.instance
        .collection('Chef')
        .doc(Get.arguments.user.uid)
        .update({'historique': historique});
  }

  var streamD;
  @override
  void initState() {
    setHistorique();
    _scrollController.addListener(_scrollListener);
    recette = Get.arguments.recette;
    recetteDetail = Get.arguments;
    userChef = Get.arguments.user.uid;
    future = getEtape();
    // TODO: implement initState
    super.initState();
  }

  Chef user;
  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExpandableCardPage(
        page: recetteBody(context),
        expandableCard: ExpandableCard(
          padding: EdgeInsets.only(top: 0, left: 8, right: 8),
          hasRoundedCorners: true,
          hasHandle: false,
          minHeight: 60,
          maxHeight: 600,
          backgroundColor: colorSecondary,
          children: <Widget>[
            Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/comment.json', height: 35),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Commentaires',
                        style: TextStyle(
                            color: colorThirdy,
                            fontSize: 20,
                            fontFamily: fontsecondary),
                      )
                    ],
                  ),
                ),
                Card(
                  child: Container(
                    height: 60,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: messageText,
                            maxLines: 2,
                            keyboardType: TextInputType.multiline,
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintStyle: TextStyle(
                                    color: Colors.black26,
                                    fontFamily: fontsecondary),
                                contentPadding:
                                    EdgeInsets.only(left: 15, right: 15),
                                hintText: 'Rédigez votre commentaire'),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.send,
                            color: colorPrimary,
                          ),
                          onPressed: sendMessage,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 470,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Recipe')
                          .doc(recette.uid)
                          .collection('Discussion')
                          .orderBy('date', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        var discu = [];
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return chargement();
                        if (snapshot.hasError) {
                          print('${snapshot.hasData}');
                          return Center(child: Text('Aucun commentaire'));
                        }
                        if (snapshot.hasData) {
                          snapshot.data.docs.forEach((element) {
                            print(element.data()['nom']);
                            discu.add(Discussion(
                                date: element.data()['date'],
                                userID: element.data()['userID'],
                                message: element.data()['message']));
                          });
                        }
                        return discu.isEmpty
                            ? Center(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Aucun commentaire'),
                                  Text('Soyez le premier en donner',
                                      style: TextStyle(color: Colors.black38))
                                ],
                              ))
                            : Scrollbar(
                                child: ListView.builder(
                                    //reverse: true,
                                    shrinkWrap: true,
                                    itemCount: discu.length,
                                    itemBuilder: (context, index) {
                                      return FutureBuilder(
                                          future: FirebaseFirestore.instance
                                              .collection('Chef')
                                              .doc(discu[index].userID)
                                              .get(),
                                          builder: (context, snapUser) {
                                            var user;
                                            if (snapUser.connectionState ==
                                                ConnectionState.waiting)
                                              return Container();
                                            if (snapUser.hasData) {
                                              user = snapUser.data;
                                            }
                                            return ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor: colorSecondary,
                                                backgroundImage:
                                                    user['image'] == null
                                                        ? AssetImage(profile)
                                                        : NetworkImage(
                                                            user['image']),
                                              ),
                                              title: user['admin']
                                                  ? Row(
                                                      children: [
                                                        Text(user['nom']),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text('Admin',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black38,
                                                                fontSize: 11))
                                                      ],
                                                    )
                                                  : Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(user['nom']),
                                                        StreamBuilder(
                                                            stream:
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'Chef')
                                                                    .doc(user[
                                                                        'uid'])
                                                                    .collection(
                                                                        'Rating')
                                                                    .doc(recette
                                                                        .uid)
                                                                    .snapshots(),
                                                            builder: (context,
                                                                snapRating) {
                                                              double rating = 0;
                                                              if (snapRating
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .waiting)
                                                                return Container();

                                                              if (snapRating
                                                                  .hasData) {
                                                                var doci =
                                                                    snapRating
                                                                        .data;

                                                                rating = doci[
                                                                    'rate'];
                                                              }
                                                              return SizedBox(
                                                                  child: Rate(
                                                                      rating,
                                                                      0),
                                                                  height: 20);
                                                            }),
                                                      ],
                                                    ),
                                              subtitle: Container(
                                                  decoration: BoxDecoration(
                                                      color: user['admin']
                                                          ? primary
                                                              .withOpacity(0.7)
                                                          : Colors
                                                              .grey.shade200,
                                                      shape: BoxShape.rectangle,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(
                                                                15.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                15.0),
                                                        topLeft:
                                                            Radius.circular(
                                                                0.0),
                                                        topRight:
                                                            Radius.circular(
                                                                15.0),
                                                      )),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      discu[index].message,
                                                      style: TextStyle(
                                                          color: user['admin']
                                                              ? Colors.white
                                                              : null),
                                                    ),
                                                  )),
                                            );
                                          });
                                    }),
                              );
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget recetteBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60.0),
      child: CustomScrollView(controller: _scrollController, slivers: [
        SliverAppBar(
          pinned: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: isShrink ? colorThirdy : colorSecondary),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 8,
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(
              recette.titre, //recette.titre,
              style: TextStyle(
                  color: isShrink ? Colors.black : Colors.white,
                  fontFamily: fontbody,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold),
            ),
            background: Image.network(
              recette.image,
              fit: BoxFit.cover,
            ),
            collapseMode: CollapseMode.pin,
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RateFavorite(recetteDetail),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        InfoSection(recette: recette),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                IngreSection(recette: recette),
                SizedBox(
                  height: 20,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Étapes',
                          style: TextStyle(
                              color: colorPrimary,
                              fontFamily: fontprimary,
                              fontSize: 24),
                        ),
                        Divider(color: colorPrimary, thickness: 1.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return SpinKitChasingDots(
                    color: colorPrimary,
                    size: 30,
                  );
                return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: etape,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Card(
                            child: Column(
                              children: [
                                (etapeI[index] == null)
                                    ? Container()
                                    : Container(
                                        height: 200,
                                        width: double.infinity,
                                        child: Image.network(
                                          etapeI[index],
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return SpinKitChasingDots(
                                              color: colorPrimary,
                                              size: 26,
                                            );
                                          },
                                        ),
                                      ),
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: colorPrimary,
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(color: colorThirdy),
                                    ),
                                  ),
                                  title: SelectableText(
                                    etapeT[index],
                                    style: TextStyle(fontFamily: fontbody),
                                  ),
                                )
                              ],
                            ),
                          ));
                    });
              })
        ]))
      ]),
    );
  }
}

class RateFavorite extends StatefulWidget {
  final RecetteDetail rd;
  //final context;
  RateFavorite(this.rd);
  @override
  _RateFavoriteState createState() => _RateFavoriteState();
}

class _RateFavoriteState extends State<RateFavorite> {
  @override
  void initState() {
    listFav = widget.rd.user.favori;
    recette = widget.rd.recette;
    check = widget.rd.user.favori.contains(widget.rd.recette.uid);

    // TODO: implement initState
    super.initState();
  }

  var recette;
  var rating = 4.0;
  var check;
  List listFav;

  getRating() async {
    try {
      var qn = await FirebaseFirestore.instance
          .collection('Chef')
          .doc(widget.rd.user.uid)
          .collection('Rating')
          .doc(widget.rd.recette.uid)
          .get();
      return qn.data()['rate'];
    } on Exception catch (e) {
      print(e.toString());
      return 0.0;
      // TODO
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getRating(),
        builder: (context, sr) {
          if (sr.connectionState == ConnectionState.waiting)
            return chargement();
          if (sr.hasError) rating = 0.0;
          if (sr.hasData) {
            rating = sr.data;
            canCom.value = true;
          }
          var data;
          return SizedBox(
            height: 70,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Noter la recette',
                          style: TextStyle(
                            color: Colors.black45,
                          )),
                      SmoothStarRating(
                          allowHalfRating: false,
                          onRated: (v) async {
                            canCom.value = true;
                            userRating.value = v;
                            data = {
                              'rate': v,
                            };
                            await FirebaseFirestore.instance
                                .collection('Chef')
                                .doc(widget.rd.user.uid)
                                .collection('Rating')
                                .doc(recette.uid)
                                .set(data);
                            await FirebaseFirestore.instance
                                .collection('Recipe')
                                .doc(recette.uid)
                                .update({
                              'rate': recette.rate + v / recette.rater + 1,
                              'rater': recette.rater + 1
                            });
                            Get.snackbar('Information',
                                'Vous avez noté $v cette recette');
                          },
                          starCount: 5,
                          rating: rating,
                          size: 30.0,
                          isReadOnly: false,
                          // fullRatedIconData: Icons.blur_off,
                          // halfRatedIconData: Icons.blur_on,
                          color: Colors.yellow,
                          borderColor: Colors.yellow,
                          spacing: 0.0)
                    ],
                  ),
                  IconButton(
                    padding: EdgeInsets.all(2),
                    iconSize: 40,
                    tooltip:
                        check ? 'Rétirer des favoris' : 'Ajouter aux favoris',
                    icon: !check
                        ? Icon(Icons.favorite,
                            color: Colors.red.withOpacity(0.5))
                        : Lottie.asset(favoriteAnimated, height: 80),
                    onPressed: () async {
                      var l = listFav;
                      if (check) {
                        l.remove(recette.uid);
                      } else {
                        l.add(recette.uid);
                      }
                      await FirebaseFirestore.instance
                          .collection('Chef')
                          .doc(widget.rd.user.uid)
                          .update({'favori': l});
                      setState(
                        () {
                          check = !check;
                        },
                      );
                    },
                  )
                ]),
          );
        });
  }
}
