import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_information.dart';

class ChatModel{
   UserInformation user;
   String message,id;
   Timestamp timestamp;
   bool vue,iam;



   ChatModel({
    required this.user,
    required this.message,
    required this.id,
    required this.vue,
    required this.iam
   }):timestamp = Timestamp.now();

   ChatModel.fromOrder({required this.user}):message = "",id="",timestamp = Timestamp.now(),vue=true,iam=true;

   ChatModel.fromFirebase(Map<String,dynamic> data,String idc):message=data["message"],timestamp=data["timestamp"],user = UserInformation.fromChat(data["user"]),id=idc,vue=data["vue"]??true,iam=data["iam"]??false;
   
}