import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matermich/models/distance.dart';
import 'package:matermich/models/user_information.dart';
import 'package:matermich/screens/buyer/buyer_home_screen.dart';
import 'package:matermich/services/image_services.dart';

class AccountController extends GetxController{

  String _errorMessage = 'invalid email or password',_title = "Error";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImageServices _imageServices = ImageServices();


  Future<void> setupMessaging(String uid) async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    if(token!=null){
     await  _firestore.collection("users").doc(uid).update({"notificationID":token});
     await addHandler();
    }

  }

  Future<void> addHandler() async{
    _requestPermission();
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async{

            try{

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {

          try {
                await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'news',
          channelName: 'News Channel',
          channelDescription: 'Channel for news notifications',
          defaultColor: Colors.teal,
          ledColor: Colors.teal,
        ),
      ],
    );

   
          } catch (e) {
          }

  

        
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 9,
          channelKey: 'news',
          title: "${message.notification?.title}",
          body: "${message.notification?.body}",
          largeIcon: "${message.notification?.android?.imageUrl}",
          notificationLayout:message.notification?.android?.imageUrl!=null? NotificationLayout.Inbox:NotificationLayout.Default
      ),
    );
        
      }}catch(e){
      }
   

    });

    try {
        
      } catch (e) {
        
      }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      try{

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {

          try {
               
        

        Get.snackbar(backgroundColor: Colors.black54,colorText: Colors.white,"    ${message.notification?.title}", "    ${message.notification?.body}",icon:message.notification?.android?.imageUrl!=null? Container(
          height: 45,
          width: 45,
          margin: const EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: 
            NetworkImage("${message.notification?.android?.imageUrl}")),

          ),
        ):const Icon(Icons.notifications,color: Colors.white,));
   
    
          } catch (e) {
          }


        
  
        
      }}catch(e){
      }
    });
  }

  void _requestPermission() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

  

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    } else {
    }
  }


  Rx<UserInformation>information = UserInformation.Empty().obs;
  bool isComplete = false;
  bool islogin = false;


  Future<void> Signin(String email,String password) async{
    try {
      
       UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
       DocumentSnapshot<Map<String, dynamic>> data = await _firestore.collection("users").doc(_auth.currentUser?.uid??"").get();
       
       information.value = UserInformation.fromFirebase(userCredential.user!, data.data()!);
       
       if(_auth.currentUser?.email != data.data()?["email"]){
          information.value.email = _auth.currentUser!.email!;
          await _firestore.collection("users").doc(information.value.uid).set(information.value.toMap());
        }

      await setupMessaging(information.value.uid);
      


       if(information.value.location.isEmpty){
        try {
                  Get.offNamed("/location_screen");

        } catch (e) {
        }
      }else{
        _routingHome();
       }
       

    }on FirebaseAuthException {
          _errorMessage = 'invalid email or password';
          _title = "Error";
          _showErrorDialog();
    }
  }

  void _routingHome(){
    if(!information.value.role){
        Get.off(()=>const BuyerHomeScreen());
    }
    else{
        Get.offNamed("home_seller");
    }
  }

  Future<void> updateProfile({required String path,required String number, required String email,required String fullname}) async{
    if(path.isNotEmpty){
          information.value.image = await _imageServices.uploadFile(path: path, storagePath: "user/${information.value.uid}");
    }
    if(email != information.value.email){
        await _auth.signInWithEmailAndPassword(email: information.value.email, password: information.value.password);
        await _auth.currentUser!.verifyBeforeUpdateEmail(email);
        _title = "Verification";
        _errorMessage = "We are Sends a verification email to $email please follow link to complet changing email";
        _showErrorDialog();
    }
  
    information.value.fullname = fullname;
    information.value.number = number;
    await _firestore.collection("users").doc(information.value.uid).set(information.value.toMap());
    update();

  }

  Future<void> initApp() async{
    try {
      if(_auth.currentUser != null){
        DocumentSnapshot<Map<String, dynamic>> data = await _firestore.collection("users").doc(_auth.currentUser?.uid??"").get();
       
        information.value = UserInformation.fromOrder(_auth.currentUser!.uid, data.data()!);

        islogin = true;

        await addHandler();


    }else{
      islogin = false;
    }
    } catch (e) {
      Get.snackbar("Error","error $e",backgroundColor: Colors.redAccent,isDismissible: false);
    }
  
  }

  Future<void> Signup(UserInformation user) async{
    try {
          UserCredential user0 = await _auth.createUserWithEmailAndPassword(email: user.email, password: user.password);
          user.image = await _imageServices.uploadFile(path: user.image, storagePath: "user/${user0.user!.uid}");
          user.uid = user0.user!.uid;
          await _firestore.collection("users").doc(user0.user!.uid).set(user.toMap());
          information.value = user;
          await setupMessaging(information.value.uid);

          Get.offNamed("location_screen");

    } catch (e) {
      _title = "Error";
      _errorMessage = e.toString();
      _showErrorDialog();
    }


  }

 
  void _showErrorDialog() {
    Get.defaultDialog(
      title: _title,
      middleText: _errorMessage,
      textConfirm: "OK",
      onConfirm: () {
        Get.back(); // Close the dialog
      },
    );
  }



  Map<String, double> calculateLatLongRange() {

  int distanceInKm = Distance.distance;
  const double earthRadiusKm = 6371.0; // Earth radius in kilometers

  // 1 degree latitude in kilometers
  double latChange = distanceInKm / 111.32;

  // 1 degree longitude in kilometers depends on latitude
  double lonChange = distanceInKm / (111.32 * cos(_toRadians(information.value.position.latitude)));

  return {
    "minLat": information.value.position.latitude - latChange,
    "maxLat": information.value.position.latitude + latChange,
    "minLon": information.value.position.longitude - lonChange,
    "maxLon": information.value.position.longitude + lonChange,
  };
}

// Helper function to convert degrees to radians
double _toRadians(double degrees) => degrees * pi / 180;


Future<void> openMap(UserInformation u) async {
     await EasyLauncher.openMap(lati: u.position.latitude.toString(), long: u.position.longitude.toString());  
  }

}