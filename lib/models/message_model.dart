import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
  String senderUid,recieverUid,message;
 
  Timestamp timestamp;
  MessageModel({
    required this.senderUid,
    required this.recieverUid,
    required this.message,
  }):timestamp = Timestamp.now();

  MessageModel.fromFirebase(Map<String,dynamic> data):senderUid = data["senderUid"],recieverUid=data["recieverUid"],timestamp = data["timestamp"],message=data["message"];

  Map<String,dynamic> toMap()=>{
    "senderUid":senderUid,
    "recieverUid":recieverUid,
    "message":message,
    "timestamp":timestamp
  };
}