import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:matermich/models/chat_model.dart';
import 'package:matermich/models/message_model.dart';
import 'package:matermich/services/account_controller.dart';
import 'package:matermich/services/send_notification.dart';

class ChatServices{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AccountController _accountController = Get.find(tag:"account");

 

  Future<void> sendMessages(MessageModel message,ChatModel chat) async{
    print("reciever uid : ${message.recieverUid}");
    await _firestore.collection("users").doc(message.recieverUid).collection("chats").doc(message.senderUid).collection("messages").add(message.toMap());
    await _firestore.collection("users").doc(message.senderUid).collection("chats").doc(message.recieverUid).collection("messages").add(message.toMap());

try {
  await _firestore.collection("users").doc(message.senderUid).collection("chats").doc(message.recieverUid).set({
       "user":chat.user.toMap(),
       "message":message.message,
       "timestamp":message.timestamp,
       "id":message.recieverUid,
       "vue":true,
       "iam":true
    });
    await _firestore.collection("users").doc(message.recieverUid).collection("chats").doc(message.senderUid).set({
      "user":_accountController.information.value.toMap(),
      "message":message.message,
      "timestamp":message.timestamp,
      "id":message.senderUid,
      "vue":false,
      "iam":false

    });


    await SendNotification().sendNotification(uid: message.recieverUid, title: chat.user.fullname, body: message.message,isMessage: true,imageUrl: _accountController.information.value.image);
} catch (e) {
}
    

  }
}