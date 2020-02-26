import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:woodwork/DataAccessors/OrderModel.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';

class FirestoreAccessors {
  final _fStoreInstance = Firestore.instance;

  Future<void> createOrder() async {
    String timeNow = CommonWidgets.timeStampToString(Timestamp.now());
    String orderID = CommonWidgets.createOrderID(Timestamp.now());
    return Auth().getFireBaseCurrentuser().then((FirebaseUser user) {
      return _fStoreInstance.collection("Orders").document(orderID).setData({
        'orderedBy': user.email,
        'orderStatus': statusType.order_Placed.index,
        'orderPlaced': timeNow
      });
    });
  }

  Future<QuerySnapshot> getAllOrders() async {
    return Auth().getFireBaseCurrentuser().then((FirebaseUser user) {
      return _fStoreInstance
          .collection("Orders")
          .getDocuments();
    });
  }
  
  Future<QuerySnapshot> getAllOrdersForRecieve() async {
    return Auth().getFireBaseCurrentuser().then((FirebaseUser user) {
      return _fStoreInstance
          .collection("Orders")
          .getDocuments().then((QuerySnapshot orders){
            orders.documents.retainWhere((searchItems) => searchItems.data['orderStatus'] == statusType.order_Placed.index);
            return orders;
          });
    });
  }

  Future<QuerySnapshot> getAllOrdersForPickUp() async {
    return Auth().getFireBaseCurrentuser().then((FirebaseUser user) {
      return _fStoreInstance
          .collection("Orders")
          .getDocuments().then((QuerySnapshot orders){
            orders.documents.retainWhere((searchItems) => searchItems.data['orderStatus'] == statusType.order_Recieved.index);
            return orders;
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
  
  Future<QuerySnapshot> getAllOrdersForDelivery() async {
    return Auth().getFireBaseCurrentuser().then((FirebaseUser user) {
      return _fStoreInstance
          .collection("Orders")
          .getDocuments().then((QuerySnapshot orders){
            orders.documents.retainWhere((searchItems) => searchItems.data['orderStatus'] == statusType.order_Processing.index);
            return orders;
          });
    });
  }

  Future<QuerySnapshot> getAllOrdersForCompletion() async {
    return Auth().getFireBaseCurrentuser().then((FirebaseUser user) {
      return _fStoreInstance
          .collection("Orders")
          .getDocuments().then((QuerySnapshot orders){
            orders.documents.retainWhere((searchItems) => searchItems.data['orderStatus'] == statusType.order_Delivering.index);
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

  Future<OverviewResult> getOverViewNumbers() async {
    int total;
    int complete;
    List<DocumentSnapshot> completeOrders = [];
    DocumentSnapshot lastCompleteOrder;
    int incomplete;
    List<DocumentSnapshot> incompleteOrders = [];
    DocumentSnapshot lastIncompleteOrder;
    return getAllOrdersForCurrUser().then((QuerySnapshot orders) {
      total = orders.documents.length;
      completeOrders.addAll(orders.documents.reversed);
      completeOrders.retainWhere((items) =>
          items.data['orderStatus'] == statusType.order_Complete.index);
      try{
        lastCompleteOrder = completeOrders.last;
      }catch(e){
        lastCompleteOrder = null;
      }
      incompleteOrders.addAll(orders.documents.reversed);
      incompleteOrders.retainWhere((items) =>
          items.data['orderStatus'] != statusType.order_Complete.index);
      try{
        lastIncompleteOrder = incompleteOrders.last;
      }catch(e){
        lastIncompleteOrder = null;
      }
      
      complete = completeOrders.length;
      incomplete = incompleteOrders.length;

      OverviewResult result = OverviewResult(complete, incomplete, lastCompleteOrder: lastCompleteOrder, lastIncompleteOrder: lastIncompleteOrder);
      return result;
    });
  }

  Future<UpdateResult> cancelOrder(String orderID) {
    String timeNow = CommonWidgets.timeStampToString(Timestamp.now());
    return _fStoreInstance.collection("Orders").document(orderID).setData(
        {'orderStatus': 6, 'lastUpdated': timeNow},
        merge: true).then((x) {
      return new UpdateResult(
          pass: true, remarks: "Status Updated Successfully!");
    }).catchError((error) {
      return new UpdateResult(pass: false, remarks: error.toString());
    });
  }
}

class OverviewResult{
  OverviewResult(this.completeOrders, this.incompleteOrders, {this.lastIncompleteOrder, this.lastCompleteOrder});
  final int completeOrders;
  final DocumentSnapshot lastCompleteOrder;
  final int incompleteOrders;
  final DocumentSnapshot lastIncompleteOrder;

}

class UpdateResult {
  UpdateResult({this.pass, this.remarks});
  bool pass;
  String remarks;
}
