import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_livechat_app/model/message.dart';
import 'package:flutter_livechat_app/model/user_model.dart';
import 'package:flutter_livechat_app/viewmodel/user_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final UserModel currentUser;
  final UserModel conversationUser;
  ChatPage(
      {super.key, required this.currentUser, required this.conversationUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    UserModel _currentUser = widget.currentUser;
    UserModel _conversationUser = widget.conversationUser;
    final _userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: _userViewModel.getMessages(
                    _currentUser.userID, _conversationUser.userID),
                builder: (context, streamMessageList) {
                  if (!streamMessageList.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var allMessages = streamMessageList.data;
                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemCount: allMessages!.length,
                    itemBuilder: (context, index) {
                      return _createSpeechBubble(allMessages[index]);
                    },
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 8, left: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      cursorColor: Colors.blueGrey,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Write message',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.navigation,
                        size: 35,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        if (_messageController.text.trim().length > 0) {
                          Message _toSaveMessage = Message(
                            messageSender: _currentUser.userID,
                            messageReceiver: _conversationUser.userID,
                            fromCurrentUser: true,
                            message: _messageController.text,
                          );
                          var result =
                              await _userViewModel.saveMessage(_toSaveMessage);
                          if (result) {
                            _messageController.clear();
                            _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 10), curve: Curves.easeOut);
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createSpeechBubble(Message currentMessage) {
    Color _incomingMessageColor = Colors.blue;
    Color _outgoingMessageColor = Colors.lightGreen;

    var _messageTimeValue = "";
    try {
      _messageTimeValue = _showMessageTime(currentMessage.date ?? Timestamp(1, 1));
    } catch (e) {
      print("Error: ${e.toString()}");
    }

    var _currentUserMessage = currentMessage.fromCurrentUser;
    if (_currentUserMessage!) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: _outgoingMessageColor),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(
                      currentMessage.message!,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(_messageTimeValue),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.conversationUser.profileURL!),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: _incomingMessageColor),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(
                      currentMessage.message!,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(_messageTimeValue),
              ],
            ),
          ],
        ),
      );
    }
  }

  String _showMessageTime(Timestamp date) {
    var _formatter = DateFormat.Hm();
    var _formatDate = _formatter.format(date.toDate());
    return _formatDate;
  }
}
