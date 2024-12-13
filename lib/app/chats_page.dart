import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_livechat_app/app/chat_page.dart';
import 'package:flutter_livechat_app/model/user_model.dart';
import 'package:flutter_livechat_app/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    _getConversations();
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: FutureBuilder(
        future: _userViewModel.getAllConversations(_userViewModel.user!.userID),
        builder: (context, speechList) {
          if (!speechList.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            var allConvesations = speechList.data;
            if (allConvesations!.length > 0) {
              return RefreshIndicator(
                onRefresh: _refreshSpeechList,
                child: ListView.builder(
                  itemCount: allConvesations.length,
                  itemBuilder: (context, index) {
                    var currentSpeech = allConvesations[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                          builder: (context) => ChatPage(
                            currentUser: _userViewModel.user!,
                            conversationUser: UserModel.idAndPhoto(
                                userID: currentSpeech.listener!,
                                profileURL:
                                    currentSpeech.listenerUserProfileURL),
                          ),
                        ));
                      },
                      child: ListTile(
                        title: Text(currentSpeech.listenerUserName!),
                        subtitle: Text(currentSpeech.lastSentMessage! +
                            "   " +
                            currentSpeech.timeDifference!),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              currentSpeech.listenerUserProfileURL!),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: _refreshSpeechList,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat,
                            color: Theme.of(context).primaryColor,
                            size: 120,
                          ),
                          Text(
                            'There was no conversation',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 36),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _getConversations() async {
    final _userViewModel = Provider.of<UserViewModel>(context);
    var conversations = await FirebaseFirestore.instance
        .collection('conversations')
        .where('speaker', isEqualTo: _userViewModel.user!.userID)
        .orderBy('creation_date', descending: true)
        .get();

    for (var chat in conversations.docs) {
      print('chat: ${chat.data().toString()}');
    }
  }

  Future<Null> _refreshSpeechList() async {
    setState(() {});
    return null;
  }
}
