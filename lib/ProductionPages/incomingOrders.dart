import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';
import 'package:woodwork/DataAccessors/OrderModel.dart';
import 'package:woodwork/DataAccessors/firestoreAccessors.dart';

class IncomingOrders extends StatefulWidget {
  IncomingOrders({this.fontColor, this.accentFontColor, this.accentColor});
  final Color fontColor;
  final Color accentFontColor;
  final Color accentColor;
  @override
  State<StatefulWidget> createState() => IncomingOrdersState();
}

class IncomingOrdersState extends State<IncomingOrders>
    with SingleTickerProviderStateMixin {
  int currIndex = 0;

  TabController _tabController;
  FirestoreAccessors _firestoreAccessors = new FirestoreAccessors();
  @override
  void initState() {
    _tabController =
        new TabController(length: statusType.values.length + 1, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new TabBar(
        labelColor: widget.accentFontColor,
        indicatorColor: widget.accentFontColor,
        isScrollable: true,
        controller: _tabController,
        tabs: <Widget>[
          new Tab(
            text: "All Orders",
          ),
          new Tab(
            text: "Orders Placed",
          ),
          new Tab(text: "Orders recieved"),
          new Tab(text: "Orders Picked up"),
          new Tab(text: "Orders Processing"),
          new Tab(text: "Orders Delivering"),
          new Tab(text: "Orders Completed"),
        ],
      ),
      body: new StreamBuilder(
        stream: _firestoreAccessors.getAllOrders().asStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> orders) {
          if (orders.hasData) {
            return TabBarView(
              controller: _tabController,
              children: <Widget>[
                generateOrdersList(orders.data, -1),
                generateOrdersList(orders.data, 0),
                generateOrdersList(orders.data, 1),
                generateOrdersList(orders.data, 2),
                generateOrdersList(orders.data, 3),
                generateOrdersList(orders.data, 4),
                generateOrdersList(orders.data, 5),
              ],
            );
          } else {
            return CommonWidgets.pageLoadingScreen(context);
          }
        },
      ),
    );
  }

  ListView generateOrdersList(QuerySnapshot orders, int orderStatus) {
    if (orderStatus == -1) {
      return ListView.builder(
        itemCount: orders.documents.length,
        itemBuilder: (BuildContext context, index) {
          OrderModel currOrder = OrderModel.toObject(
              orders.documents[index].documentID, orders.documents[index].data);
          if(currOrder.status == statusType.order_Placed.index){
              return CommonWidgets.showOrderTile(context,currOrder,true,operationToDo: statusType.order_Recieved.index);
            }else{
              return CommonWidgets.showOrderTile(context,currOrder,false);
            }
        }
      );
    } else {
      return ListView.builder(
        itemCount: orders.documents.length,
        itemBuilder: (BuildContext context, index) {
          OrderModel currOrder = OrderModel.toObject(
              orders.documents[index].documentID, orders.documents[index].data);

          if(currOrder.status == orderStatus){
            if(currOrder.status == statusType.order_Placed.index){
              return CommonWidgets.showOrderTile(context,currOrder,true,operationToDo: statusType.order_Recieved.index);
            }else{
              return CommonWidgets.showOrderTile(context,currOrder,false);
            }
          }else{
            return Container();
          }
        },
      );
    }
  }
}
