import 'package:firebase_auth/firebase_auth.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:matermich/models/role.dart';

class UserInformation{
  String fullname,image,location,email,number,password,uid;
  LatLong position;
  bool role = Role.Buyer;

  UserInformation({
    required this.fullname,
    required this.email,
    required this.image,
    required this.number,
    required this.location,
    required this.position,
    required this.role,
    required this.password,
    required this.uid,
  });

  UserInformation.Empty():fullname= "", email= "", image= "", number= "", location= "", position= const LatLong(0, 0), role= false, password= "", uid= "";

  UserInformation.fromFirebase(User user,Map<String,dynamic> data):
    uid=user.uid,
    fullname= data["fullname"] ?? "none",
    email = user.email??"none",
    image= data["image"] ?? "none",
    number= data['number'],
    location= data["location"],
    position= LatLong(data["latitude"], data["longitude"]),
    role = data["role"],
    password = data["password"];

  UserInformation.fromOrder(String uids,Map<String,dynamic> data):
    uid=uids,
    fullname= data["fullname"] ?? "none",
    email = data['email']??"none",
    image= data["image"] ?? "none",
    number= data['number'],
    location= data["location"],
    position= LatLong(data["latitude"], data["longitude"]),
    role = data["role"],
    password = data["password"];

    UserInformation.fromProduct(Map<String,dynamic> data):
    uid = data["seller"],
    fullname= data["fullname"] ?? "none",
    email = data["email"]??"none",
    image= data["image"] ?? "none",
    number= data['number'],
    location= data["location"],
    position= LatLong(data["latitude"], data["longitude"]),
    role = data["role"],
    password = data["password"];

      UserInformation.fromChat(Map<String,dynamic> data):
    uid = data["uid"]??"",
    fullname= data["fullname"] ?? "none",
    email = data["email"]??"none",
    image= data["image"] ?? "none",
    number= data['number'],
    location= data["location"],
    position= LatLong(data["latitude"], data["longitude"]),
    role = data["role"],
    password = data["password"];

   UserInformation.withoutLocation({
    required this.fullname,
    required this.email,
    required this.image,
    required this.number,
    required this.role,
    required this.password,
    required this.uid,
  }):location = "",
    position = const LatLong(0, 0);
  

  Map<String, dynamic> toMap() {
    return {
      'fullname': fullname,
      'email': email,
      'password': password,
      'role':role,
      'number':number,
      'location':location,
      'longitude':position.longitude,
      'latitude':position.latitude,
      'image':image,
    };
  }
}