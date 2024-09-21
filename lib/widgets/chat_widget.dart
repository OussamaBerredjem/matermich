import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matermich/models/chat_model.dart';
import 'package:matermich/screens/messages_screen.dart';

class ChatWidget extends StatelessWidget {
  ChatModel chatModel;
  ChatWidget({super.key,required this.chatModel});

  @override
  Widget build(BuildContext context) {
    return  CupertinoContextMenu(
                                  actions: const [
                                    CupertinoContextMenuAction(child: Row(
                                      children: [
                                        Icon(BootstrapIcons.arrow_90deg_left,size: 15,),
                                        SizedBox(width: 14,),
                                        Text("Reponder"),
                                      ],
                                    )),
                                    CupertinoContextMenuAction(child: Row(
                                      children: [
                                         Icon(Icons.delete_forever,color: Colors.redAccent,),
                                        SizedBox(width: 7,),
                                       Text("Remove",style: TextStyle(color: Colors.redAccent),),
                                      ],
                                    )),
                                   
                                  ],
                                  child: Material(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(color: Colors.white.withOpacity(.2)),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context).size.width * 0.95,
                                            maxHeight: 73
                                        ),
                                        height: 69,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.only(bottom: 7),
                                        child: ListTile(
                                          onTap: () {
                                            Get.to(MessagesScreen(chatModel: chatModel));
                                          },
                                          leading: Container(
                                            margin: const EdgeInsets.only(left: 5),
                                            height: 55,
                                            width: 55,
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(chatModel.user.image),
                                            ),
                                          ),
                                          title: Text(chatModel.user.fullname, style: const TextStyle(fontWeight: FontWeight.bold)),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("${chatModel.iam?'you: ':''}${chatModel.message}",style: chatModel.vue?null:const TextStyle(fontWeight: FontWeight.bold),),
                                                Text("${chatModel.timestamp.toDate().hour}:${chatModel.timestamp.toDate().minute}")
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                            
  }
}