import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matermich/models/ads_model.dart';
import 'package:matermich/models/product_information.dart';
import 'package:matermich/services/account_controller.dart';
import 'package:matermich/services/image_services.dart';
import 'package:matermich/services/send_notification.dart';
import 'package:matermich/services/update_product.dart';

import '../models/order_information.dart';

class SellerProductController extends GetxController{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImageServices _imageServices = ImageServices();
  final AccountController _accountController = Get.find(tag:"account");

  Future<void> addProduct(ProductInformation product,{bool edit = false,changedImage = false}) async{
    if(edit){
      try {

      UpdateProduct updateProduct = Get.find<UpdateProduct>(tag: "updateproduct");
      DocumentReference documentReference = _firestore.collection("products").doc(product.uid);
      if(changedImage){
          product.photo = await _imageServices.uploadFile(path: product.photo, storagePath: "product/${product.uid}");

      }
      await documentReference.set(product.toMap(uids:product.uid));
      updateProduct.SetUpdate(product);
      } catch (e) {
      }
     

      Get.snackbar("Success","product edit success",backgroundColor: Colors.green,colorText: Colors.white,icon: const Icon(Icons.check,color: Colors.white,));
    }else{
      DocumentReference documentReference = _firestore.collection("products").doc();
      product.photo = await _imageServices.uploadFile(path: product.photo, storagePath: "product/${documentReference.id}");
      await documentReference.set(product.toMap(uids: documentReference.id));


      QuerySnapshot<Map<String, dynamic>> query = await  _firestore.collection("users").where("latitude",isLessThanOrEqualTo: _accountController.calculateLatLongRange()["maxLat"],isGreaterThanOrEqualTo: _accountController.calculateLatLongRange()["minLat"]).where("longitude",isLessThanOrEqualTo: _accountController.calculateLatLongRange()["maxLon"],isGreaterThanOrEqualTo: _accountController.calculateLatLongRange()["minLon"]).where("role",isEqualTo: false).get();
      int i = 1;
      query.docs.forEach((doc) async{
        i++;
        await SendNotification().sendNotification(uid: doc.id, title: "New Proximity Product", body: product.name,imageUrl: product.photo);
      });

      Get.snackbar("Success","product add success",backgroundColor: Colors.green,colorText: Colors.white,icon: const Icon(Icons.check,color: Colors.white,) );
    }
      update();
      Get.back();
  }

  Future<List<ProductInformation>> getProducts(String sellerUid) async{
    List<ProductInformation> list = [];
    QuerySnapshot<Map<String, dynamic>> colection = await _firestore.collection("products").where("seller",isEqualTo: sellerUid).get();
    for (var value in colection.docs) {
    list.add(ProductInformation.fromFirebase(value.data()));
    }
    return list;
  }

  Future<void> addDiscount() async{

  }

  Future<void> addPromotion(int promotion,ProductInformation product) async{

    
    String p = "0";
    
    if(promotion > product.promotion){
      p = (double.parse(product.price) - double.parse(product.price)*(promotion - product.promotion)/100).toString();
    }else{
      p = (double.parse(product.price) + double.parse(product.price)*(product.promotion - promotion)/100).toString();

    }

     await _firestore.collection("products").doc(product.uid).update({
      "promotion" : promotion,
      "price":p.split('.').first
    });

    print("old price = ${product.price}");
    print("old promotion = ${product.promotion}");
    product.price = p.split('.').first;
    product.promotion = promotion;
    

    
    update();
  }

  Future<int> getPromotion(ProductInformation product) async{
   return 0;
  }

  
Stream<List<OrderInformation>> getStatusOrders(String status) {
  String sellerUid = _accountController.information.value.uid;
  // Reference to the Firestore 'orders' collection filtered by buyerId and status
  
  return FirebaseFirestore.instance
      .collection('orders')
      .where('sellerUid', isEqualTo: sellerUid)
      .where('status', isEqualTo: status)
      .snapshots()
      .asyncMap((snapshot) async {
        List<OrderInformation> waitingOrders = [];

        for (var doc in snapshot.docs) {
          // Convert the order document data to an OrderInformation object
          OrderInformation order = OrderInformation.fromFirestore(doc.data());

          // Fetch the products subcollection for this specific order
          var productsSnapshot = await FirebaseFirestore.instance
              .collection('orders')
              .doc(doc.id)
              .collection('products')
              .get();

          // Convert each product document to a ProductInformation object
          List<ProductInformation> products = productsSnapshot.docs.map((productDoc) {
            return ProductInformation.fromFirebase(productDoc.data());
          }).toList();

          // Add the products to the order object
          order.products = products;

          // Add the order to the list of waiting orders
          waitingOrders.add(order);
        }

        return waitingOrders;
      });
}

  Future<void> addAds(AdsModel ads) async{
      DocumentReference documentReference = _firestore.collection("ads").doc();
      ads.photo = await _imageServices.uploadFile(path: ads.photo, storagePath: "product/${documentReference.id}");
      ads.cover = await _imageServices.uploadFile(path: ads.cover, storagePath: "product/${documentReference.id}");
      
      await documentReference.set(ads.toMap(uids: documentReference.id));

      Get.snackbar("Success","ads add success tax : ${ads.tax}",backgroundColor: Colors.black54);
     
      
  }

  Future<void> removeProduct(ProductInformation product) async{
    DocumentReference doc = _firestore.collection("products").doc(product.uid);
    await doc.delete();
    update();
    Get.back();
    Get.back();
  }

  Future<void> removeAds(AdsModel ads) async{
    DocumentReference doc = _firestore.collection("ads").doc(ads.uid);
    await doc.delete();
    Get.back();
  }

  
}

