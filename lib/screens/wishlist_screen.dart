import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matermich/models/product_information.dart';
import 'package:matermich/services/account_controller.dart';
import 'package:matermich/widgets/product_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {

  final AccountController _accountController = Get.find(tag:"account");
  List<ProductInformation> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Wishlist",style: GoogleFonts.rubik(fontWeight: FontWeight.bold,color: Colors.black),),
            const Text("list of liked products",style: TextStyle(fontSize: 15,color: Colors.green))
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
        stream: FirebaseFirestore.instance.collection("users").doc(_accountController.information.value.uid).collection("wishlist").snapshots(),
         builder: (context,snapshot){

          

          if(snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.active){
            if(snapshot.data!.docs.isEmpty){
              return const Center(
                child: Text("No Liked Product"),
              );
            }
            list.clear();
            snapshot.data?.docs.forEach((value){
              list.add(ProductInformation.fromFirebase(value.data()));
            });


            return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                padding:EdgeInsets.only(left: MediaQuery.of(context).size.width*0.01,right: MediaQuery.of(context).size.width*0.01,top: 9) ,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.7,mainAxisSpacing: 10),
               itemBuilder: (context,position)=>Container(
                 margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.018),
                 child: ProductWidget(index: Random().nextInt(1000000)+10000,productInformation:list[position],),
               ));
          }
          if(snapshot.connectionState == ConnectionState.waiting){
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 8,
                padding:EdgeInsets.only(left: MediaQuery.of(context).size.width*0.01,right: MediaQuery.of(context).size.width*0.01,top: 9) ,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.7,mainAxisSpacing: 10),
               itemBuilder: (context,position)=>Container(
                 margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.018),
                 child: Skeletonizer(child: ProductWidget(index: Random().nextInt(1000000)+10000,productInformation: ProductInformation.Empty(),)),
               ));
          }if(snapshot.hasError){
          }
         return const Center(
                child: Text("No Liked Product"),
              );
         }
         ),

    );
  }
}