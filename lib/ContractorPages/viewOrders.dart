import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:woodwork/DataAccessors/OrderModel.dart';
import 'package:woodwork/DataAccessors/firestoreAccessors.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';

class ViewOrder extends StatefulWidget{
  ViewOrder(this.orderID);
  final String orderID;
  @override
  State<StatefulWidget> createState ()=> new ViewOrderState();
}

class ViewOrderState extends State<ViewOrder>{
  FirestoreAccessors _firestoreAccessors;
  @override
  void initState() {
    _firestoreAccessors = new FirestoreAccessors();
    super.initState();
  }
  Color accentColor = Colors.blueGrey[700];
  OrderModel viewingOrder;
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: _firestoreAccessors.getOrderByID(widget.orderID),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> orderchit){
        if(orderchit.hasData){
          viewingOrder = OrderModel.toObject(widget.orderID, orderchit.data.data);
          return new Scaffold(
            appBar: new AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: new IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: accentColor,
                ),
                onPressed: ()=> Navigator.pop(context),
              ),
              title: new Text(
                widget.orderID,
                style: new TextStyle(
                  color: accentColor,
                ),
              ),
            ),
            body: new ListView(
              children: <Widget>[
                showDates(viewingOrder),
                showOrderStatusTile(viewingOrder),
              ],
            ),
          );
        }else{ 
          return CommonWidgets.pageLoadingScreen(context);
        }
      },
    );
  }
  

  Widget showOrderStatusTile(OrderModel order){
    return new Container(
      child: new ListTile(
        title: new Text("Order Status: " + OrderModel.convertOrderStatusToReadableString(order.status)),
        subtitle: new LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            accentColor
          ),
          backgroundColor: Colors.blueGrey[100],
          value: OrderModel.convertOrderStatusToValue(order.status),
        ),
      ),
    );
  }
  
  Widget showDates(OrderModel order){
    String title;
    String date;
    if(order.status == 0){
      date = order.orderPlaced;
    }else{
      date = order.lastUpdated;
    }
    title = OrderModel.convertOrderStatusToReadableString(order.status) + " on " + date.split('@')[0];
    return new Container(
      child: new ListTile(
        title: new Text(title),
        subtitle: new Text("at " + date.split('@')[1]),
      ),
    );
  }
}