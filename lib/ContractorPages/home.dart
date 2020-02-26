import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:woodwork/ContractorPages/viewOrders.dart';
import 'package:woodwork/DataAccessors/OrderModel.dart';
import 'package:woodwork/DataAccessors/firestoreAccessors.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/Authentication/UserProfile.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';

class CHome extends StatefulWidget {
  final Color accentFontColor;
  final Color accentColor;
  final Color fontColor;
  CHome({this.auth, this.accentFontColor, this.accentColor, this.fontColor});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() => CHomeState();
}

class CHomeState extends State<CHome> with SingleTickerProviderStateMixin {
  FirestoreAccessors _firestoreAccessors;
  TabController controller;
  @override
  void initState() {
    _firestoreAccessors = new FirestoreAccessors();
    controller = new TabController(length: 2, vsync: this);
    super.initState();
  }

  double scaffoldHeight;
  @override
  Widget build(BuildContext context) {
    scaffoldHeight = MediaQuery.of(context).size.height;
    return new FutureBuilder(
        future: Auth().getCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<UserProfile> user) {
          if (!user.hasData) {
            return CommonWidgets.pageLoadingScreen(context);
          } else {
            return new Scaffold(
                backgroundColor: widget.accentColor,
                body: ListView(
                  children: <Widget>[
                    ListTile(
                        title: Text(
                      "Welcome " + user.data.fsUser.data['Name'],
                      style: TextStyle(color: widget.fontColor),
                    )),
                    TabBar(
                      controller: controller,
                      isScrollable: true,
                      tabs: <Widget>[
                        Tab(
                          text: "Complete Orders",
                        ),
                        Tab(
                          text: "Incomplete Orders",
                        ),
                      ],
                    ),
                    
                    Container(
                      height: scaffoldHeight / 3,
                      decoration: BoxDecoration(
                        gradient: CommonWidgets.mainGradient,
                      ),
                      child: 
                        ordersOverView(),
                    ),
                  ],
                ));
          }
        });
  }

  Widget ordersOverView() {
    return FutureBuilder(
      future: _firestoreAccessors.getOverViewNumbers(),
      builder: (BuildContext context, AsyncSnapshot<OverviewResult> numbers) {
        if (numbers.hasData) {
          return Container(
            height: scaffoldHeight / 3,
            child: new TabBarView(
              controller: controller,
              children: <Widget>[
                overviewPanel("Complete Orders", numbers.data.completeOrders,
                    lastOrder: numbers.data.lastCompleteOrder,),
                overviewPanel(
                    "Incomplete Orders", numbers.data.incompleteOrders,
                    lastOrder: numbers.data.lastIncompleteOrder,),
              ],
            ),
          );
        } else {
          return Container(
            height: scaffoldHeight/3,
            alignment: Alignment.center,
            child: Center(
              child: CircularProgressIndicator()
            )
          );
        }
      },
    );
  }

  Widget overviewPanel(String orderStatus, int orderCount,
      {DocumentSnapshot lastOrder}) {
    if (lastOrder != null || orderCount > 0) {
      return Container(
        decoration: BoxDecoration(
            gradient: CommonWidgets.mainGradient,
            borderRadius: BorderRadius.circular(30),
            border: new Border.all(color: widget.accentFontColor, width: 2),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: widget.accentFontColor, blurRadius: 7, spreadRadius: 1)
            ]),
        margin: EdgeInsets.all(15),
        height: scaffoldHeight / 8,
        width: double.maxFinite,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(15),
              height: scaffoldHeight / 8,
              child: ListTile(
                title: Text(
                  orderStatus,
                  style: TextStyle(fontSize: 42, color: widget.fontColor),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical:15.0),
                  child: Text(
                    "Latest Order",
                    style: TextStyle(color: widget.fontColor),
                  ),
                ),
                trailing: Text(orderCount.toString() + " Orders",
                    style: TextStyle(color: widget.fontColor)),
              ),
            ),
            Divider(),
            orderOverview(orderCount, lastOrder),
          ],
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
            gradient: CommonWidgets.mainGradient,
            borderRadius: BorderRadius.circular(30),
            border: new Border.all(color:  widget.accentFontColor, width: 2),
            boxShadow: <BoxShadow>[
              BoxShadow(color:  widget.accentFontColor, blurRadius: 7, spreadRadius: 1)
            ]),
        margin: EdgeInsets.all(15),
        height: scaffoldHeight / 8,
        width: double.maxFinite,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(15),
              height: scaffoldHeight / 8,
              child: ListTile(
                title: Text(
                  orderStatus,
                  style: TextStyle(fontSize: 42, color: widget.fontColor),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Latest Order",
                    style: TextStyle(color: widget.fontColor),
                  ),
                ),
                trailing: Text(orderCount.toString() + " Orders",
                    style: TextStyle(color: widget.fontColor)),
              ),
            ),
            Divider(),
            orderOverview(orderCount, lastOrder, panelColor:  widget.accentFontColor),
          ],
        ),
      );
    }
  }

  Widget orderOverview(int orderCount, DocumentSnapshot lastOrder,
      {Color panelColor}) {
    if (orderCount > 0) {
      OrderModel currOrder =
          OrderModel.toObject(lastOrder.documentID, lastOrder.data);
      return Container(
        padding: EdgeInsets.all(15),
        height: scaffoldHeight / 8,
        child: ListTile(
          subtitle: Text("Status: " + OrderModel.convertOrderStatusToReadableString(currOrder.status),
              style: TextStyle(color: widget.fontColor)),
          title: new Text(lastOrder.documentID,
              style: TextStyle(color: widget.fontColor)),
          leading: new Container(
            alignment: Alignment.center,
            width: 45,
            height: 45,
            decoration: new BoxDecoration(
                border: new Border.all(color: widget.accentFontColor, width: 2),
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  new BoxShadow(
                      color: Colors.black87, spreadRadius: 0.75, blurRadius: 1)
                ]),
            child: OrderModel.convertOrderStatusToIcon(currOrder.status, widget.accentColor)
          ),
          trailing: new IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: widget.accentFontColor,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewOrder(
                              currOrder.orderID,
                              false,
                              fontColor: widget.fontColor,
                              accentFontColor: widget.accentFontColor,
                              accentColor: widget.accentColor,
                            )));
              }),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewOrder(
                          currOrder.orderID,
                          false,
                          fontColor: widget.fontColor,
                          accentFontColor: widget.accentFontColor,
                          accentColor: widget.accentColor,
                        )));
          },
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(15),
        height: scaffoldHeight / 8,
        child: ListTile(
          title: new Text(
            "No orders yet!",
            style: TextStyle(color: widget.fontColor),
          ),
          leading: new Container(
            alignment: Alignment.center,
            width: 45,
            height: 45,
            decoration: new BoxDecoration(
                border: new Border.all(color: panelColor, width: 2),
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  new BoxShadow(
                      color: Colors.black87, spreadRadius: 0.75, blurRadius: 1)
                ]),
            child: new Text(
              "?",
              style: new TextStyle(fontSize: 21),
            ),
          ),
        ),
      );
    }
  }
}
