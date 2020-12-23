import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lesrecettesdebousta/constants/color.dart';
import 'package:lesrecettesdebousta/constants/model.dart';
import 'package:lesrecettesdebousta/constants/staticVariables.dart';
import 'package:expandable_card/expandable_card.dart';
import 'package:lottie/lottie.dart';

class RecettePage extends StatefulWidget {
  // final Recette recette;
  // RecettePage(this.recette);
  @override
  _RecettePageState createState() => _RecettePageState();
}

class _RecettePageState extends State<RecettePage> {
  var recette;
  var future;
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

  int etape = 3;
  getEtape() async {
    var listinit = [];
    var listinitT = [];
    var qn = await FirebaseFirestore.instance
        .collection('Recette')
        .doc(Get.arguments.uid)
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

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    recette = Get.arguments;
    future = getEtape();
    // TODO: implement initState
    super.initState();
  }

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
          padding: EdgeInsets.only(top: 0, left: 20, right: 20),
          hasRoundedCorners: true,
          hasHandle: false,
          minHeight: 60,
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
                Divider(
                  thickness: 1.0,
                  color: colorPrimary,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  CustomScrollView recetteBody(BuildContext context) {
    return CustomScrollView(controller: _scrollController, slivers: [
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
          delegate: SliverChildBuilderDelegate((context, index) {
        return Container(
          child: Text('cco'),
        );
      }, childCount: 2))
    ]);
  }
}

class IngreSection extends StatelessWidget {
  const IngreSection({
    Key key,
    @required this.recette,
  }) : super(key: key);

  final recette;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Ingrédients',
              style: TextStyle(
                  color: colorPrimary, fontFamily: fontprimary, fontSize: 24),
            ),
            Divider(color: colorPrimary, thickness: 1.0),
            Container(
              height: 62.0 * recette.ingredient.length,
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: recette.ingredient.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colorPrimary,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(color: colorThirdy),
                        ),
                      ),
                      title: Text(
                        recette.ingredient[index],
                        style: TextStyle(fontFamily: fontbody),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class InfoSection extends StatelessWidget {
  const InfoSection({
    Key key,
    @required this.recette,
  }) : super(key: key);

  final recette;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Informations',
          style: TextStyle(
              color: colorPrimary, fontFamily: fontprimary, fontSize: 24),
        ),
        Divider(color: colorPrimary, thickness: 1.0),
        ListTile(
          leading: Icon(Icons.description),
          title: Text(
            recette.description,
            style: TextStyle(fontFamily: fontbody),
          ),
        ),
        ListTile(
          leading: Icon(Icons.fastfood),
          title: Text(
            recette.categorie,
            style: TextStyle(fontFamily: fontbody),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: ListTile(
                leading: Icon(Icons.people_alt),
                title: Text(
                  recette.personne,
                  style: TextStyle(fontFamily: fontbody),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                leading: Icon(Icons.timer),
                title: Text(
                  recette.time,
                  style: TextStyle(fontFamily: fontbody),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
