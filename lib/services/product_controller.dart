import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:matermich/models/order_information.dart';
import 'package:matermich/models/order_status.dart';
import 'package:matermich/models/product_information.dart';
import 'package:matermich/services/account_controller.dart';
import 'package:matermich/services/send_notification.dart';

class ProductController extends GetxController{
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   final AccountController _accountController = Get.find(tag:"account");


  Future<List<ProductInformation>> getBuyerProduct() async{

    List<ProductInformation> list = [];
    
    try{

    QuerySnapshot<Map<String, dynamic>> colection = await _firestore.collection("products").get();
    for (var value in colection.docs) {
    list.add(ProductInformation.fromFirebase(value.data()));
    }
    }catch(e){
    }
    return list;
  }

  Future<void> addToCart(ProductInformation product) async{
    DocumentReference documentReference = _firestore.collection("users").doc(_accountController.information.value.uid).collection("cart").doc(product.uid);
    
   await documentReference.set(product.toMap(uids: product.uid));
    
    
  }

  Future<void> removeFromCart(ProductInformation p) async{
    DocumentReference documentReference = _firestore.collection("users").doc(_accountController.information.value.uid).collection("cart").doc(p.uid);
    await documentReference.delete();
  }

  Future<void> checkout(OrderInformation order) async{

    Map<String,List<ProductInformation>> sellerProduct = {};

    order.status = OrderStatus.cart;

    for(ProductInformation o in order.products){
    
      sellerProduct[o.seller.uid] = [];
      
     
    }

  int i =1;

    for(ProductInformation o in order.products){

      try {
      sellerProduct[o.seller.uid]!.add(o);

      print("index now is $i");
      i++;
      } catch (e) {
      }
     
    }

  try{
 sellerProduct.forEach((key,value) async{
      OrderInformation inf = OrderInformation(products: value, userInformation: value.first.seller, status: OrderStatus.cart);
      inf.totals();
      DocumentReference documentReference = _firestore.collection("orders").doc();
      inf.id = documentReference.id;
      inf.status = OrderStatus.wait;
      await documentReference.set(inf.toCheckoutMap());
      await SendNotification().sendNotification(uid: value.first.seller.uid, title: "New Order", body: "new order from ${_accountController.information.value.fullname}");


      value.forEach((v) async{
       await documentReference.collection("products").doc(v.uid).set(v.toMap(uids: v.uid));
      });

    });


       await deleteCartCollection();


   
  }catch(e){
  }

  
  }


  Future<void> deleteCartCollection() async {
  CollectionReference collection = _firestore.collection("users").doc(_accountController.information.value.uid).collection("cart");

  try {
    // Get all documents in the collection
    var snapshots = await collection.get();

    // Loop through each document and delete it
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }

  } catch (e) {
  }
}


Stream<List<OrderInformation>> getStatusOrders(String status) {
  String buyerId = _accountController.information.value.uid;
  // Reference to the Firestore 'orders' collection filtered by buyerId and status
  return FirebaseFirestore.instance
      .collection('orders')
      .where('buyerUid', isEqualTo: buyerId)
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





}