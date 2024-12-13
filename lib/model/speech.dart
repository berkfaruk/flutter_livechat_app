// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class Speech {
  final String? speaker;
  final String? listener;
  final bool? messageSeen;
  final Timestamp? creationDate;
  final String? lastSentMessage;
  final Timestamp? seenDate;
  String? listenerUserName;
  String? listenerUserProfileURL;
  DateTime? lastReadTime;
  String? timeDifference;

  Speech(
      {this.speaker,
      this.listener,
      this.messageSeen,
      this.creationDate,
      this.lastSentMessage,
      this.seenDate});

  Map<String, dynamic> toMap() {
    return {
      'speaker': speaker,
      'listener': listener,
      'message_seen': messageSeen,
      'creation_date': creationDate ?? FieldValue.serverTimestamp(),
      'last_sent_message': lastSentMessage,
      'seen_date': seenDate,
    };
  }

  Speech.fromMap(Map<String, dynamic> map)
      : speaker = map['speaker'],
        listener = map['listener'],
        messageSeen = map['message_seen'],
        creationDate = map['creation_date'],
        lastSentMessage = map['last_sent_message'],
        seenDate = map['seen_date'];

  @override
  String toString() {
    return 'Speech(speaker: $speaker, listener: $listener, messageSeen: $messageSeen, creationDate: $creationDate, lastSentMessage: $lastSentMessage, seenDate: $seenDate)';
  }
}
