
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matermich/models/product_information.dart';
import 'package:matermich/models/user_information.dart';

class AdsModel extends ProductInformation{
  String cover;


  AdsModel({
    required super.name,
    required super.desc,
    required super.seller,
    required super.categorie,
    required super.price,
    required super.uid,
    super.quantite = 1,
    required super.tax,
    required super.photo,
    required this.cover,
    required super.expiration
  });

  // ignore: non_constant_identifier_names
  AdsModel.Empty(): cover = "https://th.bing.com/th/id/OIP.cjczDDnaoewzIULGG3OMoQHaFl?rs=1&pid=ImgDetMain",
        super(
          expiration: "22/7/2025",
          categorie: "", 
          price: "3000", 
          seller: UserInformation.Empty(), 
          uid: "", 
          tax: "", 
          quantite: 1, 
          photo: "https://th.bing.com/th/id/OIP.cjczDDnaoewzIULGG3OMoQHaFl?rs=1&pid=ImgDetMain", 
          desc: "", 
          name: "Chicken Burger", 
        );

  AdsModel.fromFirebase(super.data):cover=data['cover']?? "https://th.bing.com/th/id/OIP.cjczDDnaoewzIULGG3OMoQHaFl?rs=1&pid=ImgDetMain", super.fromFirebase();

  @override
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
      "cover":cover,
      "expiration":expiration,
      "timestamp":Timestamp.now()
    };
    info.addAll(seller.toMap());
    return info;
  }

  ProductInformation toProduct(){
    return ProductInformation(
      name: name,
      desc: desc,
      seller: seller,
      categorie: categorie,
      price: price,
      uid: uid,
      quantite: quantite,
      tax: tax,
      photo: photo,
      expiration: expiration
    );
  }

  
 
}