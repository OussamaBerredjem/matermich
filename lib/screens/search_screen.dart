import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matermich/models/product_information.dart';
import 'package:matermich/services/account_controller.dart';
import 'package:matermich/widgets/product_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController controller = TextEditingController();
  final AccountController _accountController = Get.find(tag: "account");
  List<ProductInformation> list = [],filtred = [];
  ValueNotifier<String> query = ValueNotifier("");

  FocusNode focus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        actions: const [
          //IconButton(onPressed:(){}, icon: Icon(BootstrapIcons.sliders,size: 20,))
        ],
        title: Hero(
          tag: "search",
          child: Material(
            child:TextField(
                  controller: controller,
                  
                  focusNode: focus,
                  onChanged: (value){
                   
                    
                   if( value.isNotEmpty){
                    print("i search for $value");
                
                     filtred.clear();
                     for (var val in list) {
                      if(val.name.toLowerCase().contains(value.toLowerCase())){
                        filtred.add(val);
                      }
                     }
                   }else{
                    filtred.clear();
                    filtred.addAll(list);
                   }
                   query.value = value;
                
                  },
                  decoration: const InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.only(left: 15),
                           border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                        width: 0.5,
                      ),
                    
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                      focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                        width: 0.5,
                      ),
                    
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                  ),
                )
          ),
        ),
       
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: _accountController.information.value.role?FirebaseFirestore.instance.collection("products").where("seller",isEqualTo: _accountController.information.value.uid).get() :FirebaseFirestore.instance.collection("products").get(), 
          builder:(context,snapshot){
            
           
                       if(snapshot.connectionState == ConnectionState.done){
                        
                        list.clear();
                        filtred.clear();
                        snapshot.data?.docs.forEach((value){
                          list.add(ProductInformation.fromFirebase(value.data()));
                          filtred.add(ProductInformation.fromFirebase(value.data()));
    
                        });
                        if(list.isNotEmpty){
                          focus.requestFocus();
                        }
                        return ValueListenableBuilder<String>(
                          valueListenable: query,
                          builder: (context,val,child) {
                            return filtred.isNotEmpty? GridView.builder(
                              shrinkWrap: true,
                              itemCount: filtred.length,
                              physics: const NeverScrollableScrollPhysics(),
                              padding:EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.01) ,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.7),
                             itemBuilder: (context,position)=>Padding(
                               padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.018),
                               child: ProductWidget(index: Random().nextInt(Random().nextInt(2340))+10,productInformation: filtred[position],),
                             )):const Center(child:Text("There is no Product"));
                          }
                        );
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
          ),
      ),
    );
  }
}