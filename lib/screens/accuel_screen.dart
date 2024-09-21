import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:matermich/models/product_categorie.dart';
import 'package:matermich/models/product_information.dart';
import 'package:matermich/screens/add_ads_screen.dart';
import 'package:matermich/screens/add_product_screen.dart';
import 'package:matermich/screens/categorie_screen.dart';
import 'package:matermich/services/account_controller.dart';
import 'package:matermich/services/product_controller.dart';
import 'package:matermich/services/seller_product_controller.dart';
import 'package:matermich/widgets/categorie_widget.dart';
import 'package:matermich/widgets/product_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AccuelScreen extends StatefulWidget {
  const AccuelScreen({super.key});

  @override
  State<AccuelScreen> createState() => _AccuelScreenState();
}

class _AccuelScreenState extends State<AccuelScreen> {

  late var state_controller;
  final AccountController _accountController = Get.find(tag:'account');
  

  @override
  void initState() {
    // TODO: implement initState
    try {
      if(_accountController.information.value.role){
     state_controller = Get.find<SellerProductController>(tag:'product');
    }else{
     state_controller = Get.find<ProductController>(tag:'pro');

    }
    } catch (e) {
    }
    
    if(state_controller == null){
    }
    
    super.initState();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  @override
  Widget build(BuildContext context) {
     if(state_controller == null){
    }
    return Scaffold(
        floatingActionButton: Visibility(
          visible: _accountController.information.value.role,
          child: FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: (){
              showModalBottomSheet(context: context,
                                enableDrag: true,
           isDismissible: true,
           isScrollControlled: true,
           
           sheetAnimationStyle: AnimationStyle(curve: Curves.fastOutSlowIn),
               builder:(cont){
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      width: 120,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(12)
                      ),
                    ),
                  const SizedBox(height: 15,),
                
                   ListTile(
                    onTap: (){
                      Navigator.of(cont).pop(); // Close the bottom sheet
              Future.delayed(const Duration(milliseconds: 300), () {
                Get.to(() => AddProductScreen());
              });
                        
                    },
                    leading:  Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                          image: DecorationImage(image: AssetImage("assets/icons/fast.png"),fit: BoxFit.cover),
                        ),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      title: const Text("Product",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      subtitle: const Text("Add your product to our platform"),
                   ),
                    const SizedBox(height: 10,),
                    ListTile(
                      onTap: (){
                        Navigator.of(cont).pop(); // Close the bottom sheet
              Future.delayed(const Duration(milliseconds: 300), () {
                Get.to(() => const AddAdsScreen());});
          
          
                      },
                    leading:  Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                          image: DecorationImage(image: AssetImage("assets/icons/ads.png"),fit: BoxFit.cover),
                        ),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      title: const Text("Promotion",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      subtitle: const Text("Boost your product visibility and Orders"),
                   ),
                    const SizedBox(height: 35,),
                  
                  ],
                );
              });
            },
            child: const Icon(Icons.add,color: Colors.white,),
            ),
        ),
        
        body:GetBuilder<AccountController>(
          tag: "account",
          builder: (hio) {
            return NestedScrollView(
              headerSliverBuilder: (context,expanded)=>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  
                  bottom:  PreferredSize(preferredSize: Size(MediaQuery.of(context).size.width,90), child: Column(
                children: [
                
                  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                      GestureDetector(
                        onTap: (){
                          Get.to(()=>CategorieScreen(categorie: ProductCategorie.sandwich));
                        },
                        child: CategorieWidget(image: "assets/icons/sandwich_icon.png", desc: "Sandwich")),
                        GestureDetector(
                        onTap: (){
                          Get.to(()=>CategorieScreen(categorie: ProductCategorie.cake));
                        },child: CategorieWidget(image: "assets/icons/cake_icon.png", desc: "Cakes")),
                        GestureDetector(
                        onTap: (){
                          Get.to(()=>CategorieScreen(categorie: ProductCategorie.bread));
                        },child: CategorieWidget(image: "assets/icons/breads_icon.png", desc: "Breads")),
                       GestureDetector(
                        onTap: (){
                          Get.to(()=>CategorieScreen(categorie: ProductCategorie.juice));
                        },child: CategorieWidget(image: "assets/icons/juice_icon.png", desc: "Juices")),
                        GestureDetector(
                        onTap: (){
                          Get.to(()=>CategorieScreen(categorie: ProductCategorie.milk));
                        },child: CategorieWidget(image: "assets/icons/milk_icon.png", desc: "Milks")),
                      ],),
                      const SizedBox(height: 15,),
                        const Row(
                    children: [
                      SizedBox(width: 15,),
                      Icon(Ionicons.trending_up_sharp,color: Colors.green,),
                      SizedBox(width: 5,),
            
                      Text("Popular",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),)
                    ],
                  ),
                ],
              ),),
                   
                )
              ],
              body: Padding(padding: const EdgeInsets.only(top: 15),
              child:  _accountController.information.value.role ? 
                GetBuilder<SellerProductController>(
                  tag: "product",
                  builder: (control) {
                    return FutureBuilder<List<ProductInformation>>(
                       future:state_controller.getProducts(_accountController.information.value.uid),
                       builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.done ){
                          List<ProductInformation> list = snapshot.data??[];
                          return GridView.builder(
                            shrinkWrap: true,
                            itemCount: list.length,
                            physics: const NeverScrollableScrollPhysics(),
                            padding:EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.01) ,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.7),
                           itemBuilder: (context,position)=>Padding(
                             padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.018),
                             child: ProductWidget(index: Random().nextInt(Random().nextInt(2340))+10,productInformation: list[position],),
                           ));
                        }else{
                         return Skeletonizer(
                           child: GridView.builder(
                            itemCount: 4,
                            physics: const NeverScrollableScrollPhysics(),
                            padding:EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.01) ,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.7),
                           itemBuilder: (context,position)=>Padding(
                             padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.018),
                             child: ProductWidget(index: Random().nextInt(10),productInformation: ProductInformation.Empty(),),
                           )),
                         );}
                       }
                     );
                  }
                ):FutureBuilder<List<ProductInformation>>(
                   future:state_controller.getBuyerProduct(),
                   builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.done){
                          List<ProductInformation> list = snapshot.data??[];
                          return GridView.builder(
                            shrinkWrap: true,
                            itemCount: list.length,
                            physics: const NeverScrollableScrollPhysics(),
                            padding:EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.01) ,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.7),
                           itemBuilder: (context,position)=>Padding(
                             padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.018),
                             child: ProductWidget(index: Random().nextInt(Random().nextInt(2340))+10,productInformation: list[position],),
                           ));
                        }
                    return GridView.builder(
                      itemCount: 4,
                      padding:EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.01) ,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.7),
                     itemBuilder: (context,position)=>Skeletonizer(
                       
                       child: Skeletonizer(
                         child: Padding(
                           padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.018),
                           child: ProductWidget(index: Random().nextInt(10),productInformation: ProductInformation.Empty(),),
                         ),
                       ),
                     ));
                        
                    
                   }
                 ),),
            );
          }
        )
    );
  }
}