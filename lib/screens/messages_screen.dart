import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matermich/models/chat_model.dart';
import 'package:matermich/models/message_model.dart';
import 'package:matermich/services/account_controller.dart';
import 'package:matermich/services/chat_services.dart';

class MessagesScreen extends StatefulWidget {
  ChatModel chatModel;
  MessagesScreen({super.key,required this.chatModel});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> with AutomaticKeepAliveClientMixin<MessagesScreen>{

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  ScrollController scrollController = ScrollController();
  bool loading = true;
  final AccountController _accountController = Get.find(tag: 'account');
  bool taping = false,emoji = false,thisrd=false;
  List<MessageModel> list = [];

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    print("hy i'm the reciever ${widget.chatModel.user.fullname} uid : ${widget.chatModel.user.uid}");

    super.initState();
  }

  ValueNotifier<String> msg = ValueNotifier<String>("");
  ChatServices chatServices = ChatServices();
    ValueNotifier<bool> lod = ValueNotifier<bool>(false);


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: SizedBox(
            height: 40,
            width: 40,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
               widget.chatModel.user.image
                ),
            ),
          ),
          title: Text(
           widget.chatModel.user.fullname,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: GestureDetector(
              onTap:() async{
                await EasyLauncher.call(number: widget.chatModel.user.number);
                },
              child: const Icon(Icons.call)),
          ),
          
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 9,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(_accountController.information.value.uid)
                  .collection('chats')
                  .doc(widget.chatModel.user.uid)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, messageSnapshot) {
                if (messageSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text("Lodaing ..."),);
                }
            
                if (!messageSnapshot.hasData || messageSnapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages available'));
                }
                FirebaseFirestore.instance.collection("users").doc(_accountController.information.value.uid).collection("chats").doc(widget.chatModel.user.uid).update({"vue":true});
                list.clear();
                for (var doc in messageSnapshot.data!.docs) {
                  Map<String,dynamic> h = doc.data();
                  list.add(MessageModel.fromFirebase(h));
                  }

            
                return ListView.builder(
                  reverse: true,
                  controller: scrollController,
                  
                  itemCount: list.length,
                  itemBuilder: (context, position) {
                    return Row(
                      mainAxisAlignment: list[position].recieverUid!=_accountController.information.value.uid?MainAxisAlignment.end:MainAxisAlignment.start,
                      children: [
                        Container(
                                
                          margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                          decoration: BoxDecoration(
                            color: list[position].recieverUid!=_accountController.information.value.uid?Colors.green.shade200.withOpacity(0.4):Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child:Container(
                            constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.75),
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(list[position].message,style: const TextStyle(fontSize: 21),),
                                Text("${list[position].timestamp.toDate().hour}:${list[position].timestamp.toDate().minute}",style: const TextStyle(fontSize: 9,fontWeight: FontWeight.w500),)
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
          ),
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            padding:  const EdgeInsets.symmetric(vertical: 5,horizontal: 10),

            child:ValueListenableBuilder<String>(
                        valueListenable: msg,
                        builder: (context,value,child) {
                return Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding:const EdgeInsets.symmetric(horizontal:15),
                      width: msg.value.isEmpty? MediaQuery.of(context).size.width*0.88: MediaQuery.of(context).size.width*0.74,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                         border: Border.all(
                    width: 0.2,
                    color: Colors.black
                  )
                      ),
                      child: TextField(
                        maxLines: 5,
                        minLines: 1,
                        onChanged: (text){
                          msg.value = text;
                        },
                        style: const TextStyle(fontSize: 23, fontFamily: 'ios'),
                        controller: controller,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Message",
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          hintStyle: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    value.isEmpty?const SizedBox():SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: IconButton(
                                        onPressed: () async{
                                          lod.value = true;
                                          try {
                                              controller.clear();
                                              String m = msg.value;
                                              msg.value = "";

                                             
                                              print("sender uid : ${_accountController.information.value.uid}");
                                              print("sender uid : ${_accountController.information.value.fullname}");

                                              await chatServices.sendMessages(MessageModel(senderUid: _accountController.information.value.uid, recieverUid: widget.chatModel.user.uid, message: m), widget.chatModel);
                                              lod.value = false;
                                              


                                          } catch (e) {
                                          }

                                        },
                                        icon: ValueListenableBuilder(
                                          valueListenable: lod,
                                          builder: (context,value,child) {
                                            return value?const CircularProgressIndicator(color: Colors.white,): const Icon(Icons.send, color: Colors.white);
                                          }
                                        ),
                                        style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade400, shape: const CircleBorder()),
                                      ),)
                
                  ],
                );
              }
            ),
          ),
        ],
      )
      ,

    );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}