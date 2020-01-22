import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:woodwork/DataAccessors/OrderModel.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';

class FirestoreAccessors {
  final _fStoreInstance = Firestore.instance;

  Future<DocumentReference> createOrder() async {
    String timeNow = CommonWidgets.timeStampToString(Timestamp.now());

    return Auth().getFireBaseCurrentuser().then((FirebaseUser user) {
      return _fStoreInstance.collection("Orders").add({
        'orderedBy': user.email,
        'orderStatus': statusType.order_Placed.index,
        'orderPlaced': timeNow
      });
    });
  }

  
  Future<QuerySnapshot> getAllOrdersForProduction() async {
    return Auth().getFireBaseCurrentuser().then((FirebaseUser user) {
      return _fStoreInstance
          .collection("Orders")
          .getDocuments().then((QuerySnapshot orders){
            orders.documents.retainWhere((searchItems) => searchItems.data['orderStatus'] == statusType.order_Picked_Up.index);
            return orders;
          });
    });
  }

  Future<QuerySnapshot> getAllOrdersForCurrUser() async {
    return Auth().getFireBaseCurrentuser().then((FirebaseUser user) {
      return _fStoreInstance
          .collection("Orders")
          .getDocuments()
          .then((QuerySnapshot orders) {
        orders.documents.retainWhere(
            (searchItems) => searchItems.data['orderedBy'] == user.email);
        return orders;
      });
    });
  }

  Future<DocumentSnapshot> getOrderByID(String orderID) async {
    return _fStoreInstance.collection("Orders").document(orderID).get();
  }

  Future<UpdateResult> updateOrderStatus(String orderID, int statusChange) {
    String timeNow = CommonWidgets.timeStampToString(Timestamp.now());
    return _fStoreInstance.collection("Orders").document(orderID).setData(
        {'orderStatus': statusChange, 'lastUpdated': timeNow},
        merge: true).then((x) {
      return new UpdateResult(
          pass: true, remarks: "Status Updated Successfully!");
    }).catchError((error) {
      return new UpdateResult(pass: false, remarks: error.toString());
    });
  }

  Future<List<int>> getOverViewNumbers() async {
    int total;
    int complete;
    int incomplete;
    return getAllOrdersForCurrUser().then((QuerySnapshot orders) {
      total = orders.documents.length;
      orders.documents.retainWhere((items) =>
          items.data['orderStatus'] == statusType.order_Complete.index);
      complete = orders.documents.length;
      incomplete = total - complete;
      List<int> overviewNumbers = [complete, incomplete, total];
      return overviewNumbers;
    });
  }
}

class UpdateResult {
  UpdateResult({this.pass, this.remarks});
  bool pass;
  String remarks;
}
