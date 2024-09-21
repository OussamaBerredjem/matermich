import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matermich/services/account_controller.dart';
import 'package:matermich/widgets/product_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/product_information.dart';

class CategorieScreen extends StatefulWidget {
  String categorie;
  CategorieScreen({super.key,required this.categorie});

  @override
  State<CategorieScreen> createState() => _CategorieScreenState();
}

class _CategorieScreenState extends State<CategorieScreen> {

  List<ProductInformation> list = [];
  final AccountController _accountController = Get.find(tag:"account");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categorie,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _accountController.information.value.role? FutureBuilder<QuerySnapshot<Map<String,dynamic>>>(
        future: FirebaseFirestore.instance.collection("products").where("categorie",isEqualTo: widget.categorie).where("seller",isEqualTo: _accountController.information.value.uid).get(),
         builder: (context,snapshot){

          

          if(snapshot.connectionState == ConnectionState.done){
           
            if(snapshot.data!.docs.isEmpty){
              return Center(
                child: Text("No Product in ${widget.categorie} Categorie"),
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
         return Center(
                child: Text("No Product in ${widget.categorie} Categorie"),
              );
         }
         ):FutureBuilder<QuerySnapshot<Map<String,dynamic>>>(
        future:  FirebaseFirestore.instance.collection("products").where("categorie",isEqualTo: widget.categorie).get(),
         builder: (context,snapshot){

          

          if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
            if(snapshot.data!.docs.isEmpty){
              return const Center(
                child: Text("No Product"),
              );
            }
            list.clear();
            snapshot.data?.docs.forEach((value){
              list.add(ProductInformation.fromFirebase(value.data()));
            });


            return list.isEmpty? Center(
                child: Text("No Product in ${widget.categorie} Categorie"),
              ):GridView.builder(
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
         return Center(
                child: Text("No Product in ${widget.categorie} Categorie"),
              );
         }
         ),

    );
  }
}