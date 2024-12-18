import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_livechat_app/locator.dart';
import 'package:flutter_livechat_app/model/message.dart';
import 'package:flutter_livechat_app/model/user_model.dart';
import 'package:flutter_livechat_app/repository/user_repository.dart';

enum ChatViewState { Idle, Loaded, Busy }

class ChatViewModel with ChangeNotifier {
  late List<Message> _allMessages;
  ChatViewState _state = ChatViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();
  static final messagesPerPage = 15;
  final UserModel currentUser;
  final UserModel conversationUser;
  Message? _lastFetchedMessage;
  Message? _firstMessageAddedToList;
  bool _hasMore = true;
  bool _newMessageListener = false;
  late StreamSubscription _streamSubscription;

  ChatViewModel({required this.currentUser, required this.conversationUser}) {
    _allMessages = [];
    getMessageWithPagination(false);
  }

  List<Message> get messagesList => _allMessages;
  ChatViewState get state => _state;
  bool get hasMoreLoading => _hasMore;

  set state(ChatViewState value) {
    _state = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  Future<bool> saveMessage(Message toSaveMessage) async {
    return await _userRepository.saveMessage(toSaveMessage);
  }

  void getMessageWithPagination(bool gettingNewMessages) async {
    if (_allMessages.length > 0) {
      _lastFetchedMessage = _allMessages.last;
    }

    if (!gettingNewMessages) state = ChatViewState.Busy;

    var fetchedMessages = await _userRepository.getMessageWithPagination(
        currentUser.userID,
        conversationUser.userID,
        _lastFetchedMessage,
        messagesPerPage);

    if (fetchedMessages.length < messagesPerPage) {
      _hasMore = false;
    }

    _allMessages.addAll(fetchedMessages);
    if (_allMessages.isNotEmpty) {
      _firstMessageAddedToList = _allMessages.firstOrNull;
    }

    state = ChatViewState.Loaded;

    if (_newMessageListener == false) {
      _newMessageListener = true;
      assignNewMessageListener();
    }
  }

  Future<void> getMoreMessages() async {
    if (_hasMore) getMessageWithPagination(true);
    await Future.delayed(Duration(seconds: 1));
  }

  void assignNewMessageListener() {
    _streamSubscription = _userRepository
        .getMessages(currentUser.userID, conversationUser.userID)
        .listen(
      (instantData) {
        if (instantData.isNotEmpty) {

          if (instantData[0].date != null) {
            if (_firstMessageAddedToList == null) {
              _allMessages.insert(0, instantData[0]);
            } else if (_firstMessageAddedToList!.date!.millisecondsSinceEpoch !=
                instantData[0].date!.millisecondsSinceEpoch)
              _allMessages.insert(0, instantData[0]);
          }

          state = ChatViewState.Loaded;
        }
      },
    );
  }
}
