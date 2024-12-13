// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {

  final String? messageSender;
  final String? messageReceiver;
  final bool? fromCurrentUser;
  final String? message;
  final Timestamp? date;

  Message({this.messageSender, this.messageReceiver, this.fromCurrentUser, this.message, this.date});

  Map<String, dynamic> toMap() {
    
    return {
      'messageSender': messageSender,
      'messageReceiver': messageReceiver,
      'fromCurrentUser': fromCurrentUser,
      'message': message,
      'date': date ?? FieldValue.serverTimestamp(),
    };
  }

  Message.fromMap(Map<String, dynamic> map): 
    messageSender = map['messageSender'],
    messageReceiver = map['messageReceiver'],
    fromCurrentUser = map['fromCurrentUser'],
    message = map['message'],
    date = map['date'];


  @override
  String toString() {
    return 'Message(messageSender: $messageSender, messageReceiver: $messageReceiver, fromCurrentUser: $fromCurrentUser, message: $message, date: $date)';
  }
}
