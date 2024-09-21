

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matermich/services/account_controller.dart';
import 'package:matermich/widgets/chat_widget.dart';

import '../models/chat_model.dart';




class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>{

  bool isVisible = true,isReleased = false;
  final ScrollController _Vertical = ScrollController();
  final AccountController _accountController = Get.find(tag:"account");
  
  List<ChatModel> list = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Chats",style: GoogleFonts.rubik(fontWeight: FontWeight.bold,color: Colors.black),),
            const Text("Discover new messages",style: TextStyle(fontSize: 15,color: Colors.deepPurple))
          ],
        ),
        actions: const [
          
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream:  FirebaseFirestore.instance
                  .collection('users')
                  .doc(_accountController.information.value.uid)
                  .collection('chats').orderBy("timestamp").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text("Loading"),
            );  
          }else if(snapshot.connectionState == ConnectionState.done || snapshot.hasData){
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No chats available'));
            }
             list.clear();
             snapshot.data?.docs.forEach((doc){
              ChatModel chatModel = ChatModel.fromFirebase(doc.data(),doc.id);
              chatModel.user.uid = chatModel.id;
              list.add(chatModel);
              
             });
             list = list.reversed.toList();
            return ListView.builder(
            
            itemCount: list.length,
            itemBuilder: (context,position)=>ChatWidget(chatModel:list[position]),
              );
          }else if(snapshot.hasError){
          }
          return const Center(
              child: Text("Loading"),
            ); 
        }
      ));
  }

}
