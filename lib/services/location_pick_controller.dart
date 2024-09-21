import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:matermich/models/role.dart';
import 'package:matermich/services/account_controller.dart';

class LocationPickController extends GetxController{
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AccountController _accountController = Get.find(tag:"account");

  var location = "".obs;
  var position = const LatLong(0, 0).obs;


  @override
  void onInit() {
    // TODO: implement onInit
    location.value = _accountController.information.value.location;
    position.value =  _accountController.information.value.position;
    super.onInit();
  }

  void updateUi({required String slocation,required LatLong sposition}){
    location.value = slocation;
    position.value = sposition;
    update();
    Get.back();
  }


   Future<void> updateLocation({bool change = false}) async{
     try {
          _accountController.information.value.position = position.value;
          _accountController.information.value.location = location.value;
          
         


          await _firestore.collection("users").doc(_accountController.information.value.uid).set(_accountController.information.value.toMap()).then((value){
             
          if(!change){
            if(_accountController.information.value.role == Role.Buyer){
              Get.toNamed("home_seller");
            }
          else{
            Get.toNamed("home_seller");
          }
          }else{
            update();
            _accountController.update();
            Get.back();
          }

          });
        
        
          
    } catch (e) {
     
    Get.defaultDialog(
      title: "Error",
      middleText: e.toString(),
      textConfirm: "OK",
      onConfirm: () {
        Get.back(); // Close the dialog
      },
    );
    }
  }

 void _routingHome(){
    if(_accountController.information.value.role == Role.Buyer){
        Get.offNamed("home_seller");
    }
    else{
        Get.offNamed("home_seller");
    }
  }
}