import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lesrecettesdebousta/constants/model.dart';
import 'package:lesrecettesdebousta/constants/widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class Forum extends StatefulWidget {
  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  List listMessage = [];
  Chef user;
  TextEditingController messageText = TextEditingController();
  bool sending = false;
  sendMessage(String utilisateurID) async {
    if (messageText.text.isNotEmpty) {
      var message = {
        'userID': utilisateurID,
        'message': messageText.text,
        'date': Timestamp.now(),
      };

      try {
        await FirebaseFirestore.instance.collection('Forum').add(message);
        setState(() {
          messageText.clear();
        });
      } on Exception catch (e) {}
    }
  }

  initState() {
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    super.initState();
  }

  Color themeColor = null;
  @override
  Widget build(BuildContext context) {
    user = context.watch<Chef>();
    //initializeDateFormatting();
    return Scaffold(
      appBar: AppBar(
        title: Lottie.asset('assets/Chat.json', height: 10),
      ),
      backgroundColor: themeColor,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Forum')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapMess) {
                  if (snapMess.connectionState == ConnectionState.waiting)
                    return chargement();
                  if (snapMess.connectionState == ConnectionState.none)
                    return Center(
                      child: Text('Pas de connexion'),
                    );
                  if (snapMess.hasError) print('erreur');
                  if (!snapMess.hasData) {
                    print(snapMess.data);
                    print('pas de message');
                    return Center(
                      child: Text('Aucun message'),
                    );
                  } else {
                    print('debut message');
                    listMessage.clear();
                    snapMess.data.docs.forEach((element) {
                      listMessage.add(Discussion(
                          date: element.data()['date'],
                          userID: element.data()['userID'],
                          message: element.data()['message']));
                    });
                    return listMessage.isEmpty
                        ? Center(
                            child: Text('Aucun message'),
                          )
                        : Scrollbar(
                            child: ListView.builder(
                              reverse: true,
                              itemCount: listMessage.length,
                              itemBuilder: (context, index) {
                                bool isUser =
                                    (listMessage[index].userID == user.uid);

                                return (index == listMessage.length - 1)
                                    ? ListTile(
                                        subtitle: MessageSection(
                                          isUser: isUser,
                                          listMessage: listMessage,
                                          index: index,
                                        ),
                                        title: UserSection(
                                            listMessage: listMessage,
                                            isUser: isUser,
                                            index: index))
                                    : (listMessage[index].userID ==
                                            listMessage[index + 1].userID)
                                        ? ListTile(
                                            title: MessageSection(
                                              isUser: isUser,
                                              listMessage: listMessage,
                                              index: index,
                                            ),
                                          )
                                        : ListTile(
                                            subtitle: MessageSection(
                                              isUser: isUser,
                                              listMessage: listMessage,
                                              index: index,
                                            ),
                                            title: UserSection(
                                                listMessage: listMessage,
                                                isUser: isUser,
                                                index: index),
                                          );
                              },
                            ),
                          );
                  }
                }),
          ),
          inputMessage()
        ],
      ),
    );
  }

  Widget inputMessage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 8.0,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  controller: messageText,
                  onSubmitted: (v) {
                    sendMessage(user.uid);
                  },
                  keyboardType: TextInputType.text,
                  // maxLines: 2,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 16, top: 11, right: 15),
                      hintText: 'Message...'),
                ),
              ),
            ),
            sending
                ? chargement()
                : IconButton(
                    alignment: Alignment.center,
                    tooltip: 'Envoyer',
                    icon: Icon(Icons.send),
                    onPressed: () {
                      sendMessage(user.uid);
                    })
          ],
        ),
      ),
    );
  }
}
