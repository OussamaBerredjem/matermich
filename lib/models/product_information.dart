
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matermich/models/user_information.dart';

class ProductInformation implements Comparable<ProductInformation>{
  String name,desc,categorie,uid,photo,price,tax,expiration;
  
  int quantite,promotion=0;
  UserInformation seller;

  bool empty = false;

  ProductInformation({
    required this.name,
    required this.desc,
    required this.seller,
    required this.categorie,
    required this.price,
    required this.uid,
    this.quantite = 1,
    required this.tax,
    required this.photo,
    required this.expiration
  });

  ProductInformation.Empty():categorie="",price="3000",seller=UserInformation.Empty(),uid = "",tax ="",quantite = 1,photo = "https://th.bing.com/th/id/OIP.cjczDDnaoewzIULGG3OMoQHaFl?rs=1&pid=ImgDetMain",desc="",name="Chicken Burger",empty=true,expiration="22/09/2025";

  ProductInformation.fromFirebase(Map<String,dynamic> data):categorie=data["categorie"],name = data["name"],desc=data["desc"],price=data["price"],uid=data["uid"],quantite=data["quantite"],photo=data["photo"],seller=UserInformation.fromProduct(data),tax = data["tax"],empty=false,promotion=data["promotion"]??0,expiration=data["expiration"]??"22/09/2025";

  Map<String,dynamic> toMap({required String uids}){
    Map<String,dynamic> info = {
      "seller":seller.uid,
      "name":name,
      "desc":desc,
      "categorie":categorie,
      "price":price,
      "uid":uids,
      "quantite":quantite,
      "photo":photo,
      "tax":tax,
      "expiration":expiration,
      "timestamp":Timestamp.now()
    };
    info.addAll(seller.toMap());
    return info;
  }
  
  @override
  int compareTo(ProductInformation other) {
    if(other.uid == uid){
      return 0;
    }else{
      return 1;
    }
  }
}