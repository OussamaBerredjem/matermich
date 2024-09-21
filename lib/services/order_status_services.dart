import 'package:cloud_firestore/cloud_firestore.dart';

class OrderStatusServices{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> cancellOrder(String id) async{
    try {
     
     DocumentReference documentReference =  _firestore.collection("orders").doc(id);
     await documentReference.delete();
    } catch (e) {

    }
  }

  Future<void> updateStatus(String id,String status) async{
    try {
        await _firestore.collection("orders").doc(id).update({"status":status});
      
    } catch (e) {
      
    }
  }
}