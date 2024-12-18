import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_livechat_app/model/message.dart';
import 'package:flutter_livechat_app/model/speech.dart';
import 'package:flutter_livechat_app/model/user_model.dart';
import 'package:flutter_livechat_app/services/db_base.dart';

class FirestoreDBService implements DBBase {
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(UserModel user) async {
    await _firebaseDB.collection("users").doc(user.userID).set(user.toMap());

    DocumentSnapshot _readUser =
        await _firebaseDB.collection('users').doc(user.userID).get();
    Map<String, dynamic> _readUserInfoMap =
        _readUser.data() as Map<String, dynamic>;
    UserModel _readUserInfo = UserModel.fromMap(_readUserInfoMap);
    print('Read User Info: ${_readUserInfo.toString()}');

    return true;
  }

  @override
  Future<UserModel> readUser(String userID) async {
    DocumentSnapshot _readUser =
        await _firebaseDB.collection('users').doc(userID).get();
    Map<String, dynamic> _readUserMapInfo =
        _readUser.data() as Map<String, dynamic>;

    UserModel _readUserObject = UserModel.fromMap(_readUserMapInfo);
    return _readUserObject;
  }

  @override
  Future<bool> updateUserName(String userID, String newUserName) async {
    var users = await _firebaseDB
        .collection('users')
        .where('userName', isEqualTo: newUserName)
        .get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firebaseDB
          .collection('users')
          .doc(userID)
          .update({'userName': newUserName});
      return true;
    }
  }

  @override
  Future<bool> updateProfilePhoto(String userID, String profilePhotoURL) async {
    await _firebaseDB
        .collection('users')
        .doc(userID)
        .update({'profileURL': profilePhotoURL});
    return true;
  }

  @override
  Stream<List<Message>> getMessages(
      String currentUserID, String conversationUserID) {
    var snapshot = _firebaseDB
        .collection('conversations')
        .doc("$currentUserID--$conversationUserID")
        .collection('messages')
        .orderBy('date', descending: true)
        .limit(1)
        .snapshots();
    return snapshot.map((messageList) => messageList.docs
        .map(
          (message) => Message.fromMap(message.data()),
        )
        .toList());
  }

  @override
  Future<bool> saveMessage(Message toSaveMessage) async {
    var _messageID = _firebaseDB.collection('conversations').doc().id;
    var _currentUserDocumentID =
        '${toSaveMessage.messageSender}--${toSaveMessage.messageReceiver}';
    var _receiverUserDocumentID =
        '${toSaveMessage.messageReceiver}--${toSaveMessage.messageSender}';

    var _toBeSaveMessageMap = toSaveMessage.toMap();

    await _firebaseDB
        .collection('conversations')
        .doc(_currentUserDocumentID)
        .collection('messages')
        .doc(_messageID)
        .set(_toBeSaveMessageMap);

    await _firebaseDB
        .collection('conversations')
        .doc(_currentUserDocumentID)
        .set({
      'speaker': toSaveMessage.messageSender,
      'listener': toSaveMessage.messageReceiver,
      'last_sent_message': toSaveMessage.message,
      'message_seen': false,
      'creation_date': FieldValue.serverTimestamp(),
    });

    _toBeSaveMessageMap.update(
      'fromCurrentUser',
      (value) => false,
    );

    await _firebaseDB
        .collection('conversations')
        .doc(_receiverUserDocumentID)
        .collection('messages')
        .doc(_messageID)
        .set(_toBeSaveMessageMap);

    await _firebaseDB
        .collection('conversations')
        .doc(_receiverUserDocumentID)
        .set({
      'speaker': toSaveMessage.messageReceiver,
      'listener': toSaveMessage.messageSender,
      'last_sent_message': toSaveMessage.message,
      'message_seen': false,
      'creation_date': FieldValue.serverTimestamp(),
    });

    return true;
  }

  @override
  Future<List<Speech>> getAllConversations(String userID) async {
    QuerySnapshot querySnapshot = await _firebaseDB
        .collection('conversations')
        .where('speaker', isEqualTo: userID)
        .orderBy('creation_date', descending: true)
        .get();

    List<Speech> allConvesations = [];

    for(DocumentSnapshot singleChat in querySnapshot.docs){
      Speech _singleChat = Speech.fromMap(singleChat.data() as Map<String, dynamic>);
      allConvesations.add(_singleChat);
    }

    return allConvesations;
  }
  
  @override
  Future<DateTime> showTime(String userID) async{
    await _firebaseDB.collection('server').doc(userID).set({
      'hour': FieldValue.serverTimestamp(),
    });
    var readMap = await _firebaseDB.collection('server').doc(userID).get();
    Timestamp readTime = readMap.data()!['hour'];
    return readTime.toDate();
  }
  
  @override
  Future<List<UserModel>> getUserWithPagination(UserModel? lastFetchedUser, int getNumberOfUsers) async{
    
    QuerySnapshot _querySnapshot;
    List<UserModel> _allUsers = [];
    if (lastFetchedUser == null) {
      _querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('userName')
          .limit(getNumberOfUsers)
          .get();
      
    } else {
      _querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('userName')
          .startAfter([lastFetchedUser.userName])
          .limit(getNumberOfUsers)
          .get();
    }
    for (DocumentSnapshot snap in _querySnapshot.docs) {
      UserModel _oneUser =
          UserModel.fromMap(snap.data() as Map<String, dynamic>);
      _allUsers.add(_oneUser);
    }

    return _allUsers;
  }

  Future<List<Message>> getMessageWithPagination(String currentUserID, String conversationUserID, Message? lastFetchedMessage, int getNumberOfMessage) async{

    QuerySnapshot _querySnapshot;
    List<Message> _allMessages = [];
    if (lastFetchedMessage == null) {
      _querySnapshot = await FirebaseFirestore.instance
          .collection('conversations')
        .doc("$currentUserID--$conversationUserID")
        .collection('messages')
        .orderBy('date', descending: true)
          .limit(getNumberOfMessage)
          .get();
      
    } else {
      _querySnapshot = await FirebaseFirestore.instance
          .collection('conversations')
        .doc("$currentUserID--$conversationUserID")
        .collection('messages')
        .orderBy('date', descending: true)
          .startAfter([lastFetchedMessage.date])
          .limit(getNumberOfMessage)
          .get();
    }
    for (DocumentSnapshot snap in _querySnapshot.docs) {
      Message _oneUser =
          Message.fromMap(snap.data() as Map<String, dynamic>);
      _allMessages.add(_oneUser);
    }

    return _allMessages;

  }
}
