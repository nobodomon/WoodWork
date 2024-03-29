import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:woodwork/DataAccessors/OrderModel.dart';
import 'package:woodwork/DataAccessors/firestoreAccessors.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';

class Orders extends StatefulWidget {
  final Color accentFontColor;
  final Color accentColor;
  final Color fontColor;

  const Orders({Key key, this.accentFontColor, this.accentColor, this.fontColor});
  @override
  State<StatefulWidget> createState() => new OrdersState();
}

class OrdersState extends State<Orders> {
  FirestoreAccessors _firestoreAccessors;
  bool searchVisible = false;
  TextEditingController controller = new TextEditingController();
  List<Color> currSearchGrad;
  List<List<Color>> searchGradient = [
    [Colors.blueGrey[700], Colors.blueGrey[400]],
    [Colors.red[700], Colors.red[400]],
  ];
  String filter = "";

  @override
  void initState() {
    super.initState();
    _firestoreAccessors = new FirestoreAccessors();
    controller.addListener(() {
      setState(() {
        currSearchGrad = searchGradient[0];
        filter = controller.text;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: _firestoreAccessors.getAllOrdersForCurrUser().asStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> orders){
        if(orders.hasData){
          orders.data.documents.reversed;
          return Scaffold(
            backgroundColor: widget.accentColor,
            floatingActionButton: new Container(
              child: new IconButton(
                icon: new Icon(Icons.search, color: Colors.white),
                onPressed: () => setState(() {
                  if (searchVisible) {
                    searchVisible = false;
                    filter = "";
                    controller.clear();
                    currSearchGrad = searchGradient[0];
                  } else {
                    searchVisible = true;
                    currSearchGrad = searchGradient[1];
                  }
                }),
              ),
              width: 45,
              height: 45,
              decoration: new BoxDecoration(
                color: widget.accentFontColor,
                shape: BoxShape.circle,
                boxShadow: [
                  new BoxShadow(
                      color: Colors.black87, spreadRadius: 0.75, blurRadius: 1)
                ],
              ),
            ),
            body: Column(
              children: <Widget>[
                showSearchBar(context),
                Expanded(
                  child: new ListView.builder(
                      itemCount: orders.data.documents.length,
                      itemBuilder: (context, index) {
                        OrderModel currOrder = OrderModel.toObject(
                            orders.data.documents.reversed.toList()[index].documentID,
                            orders.data.documents.reversed.toList()[index].data);
                        if (filter == null || filter.isEmpty) {
                          return CommonWidgets.showOrderTile(context,currOrder,false,fontColor: widget.fontColor,accentFontColor: widget.accentFontColor, accentColor: widget.accentColor,);
                        } else if (currOrder.orderID
                            .toLowerCase()
                            .contains(filter.toLowerCase())) {
                          return CommonWidgets.showOrderTile(context,currOrder,false,fontColor: widget.fontColor,accentFontColor: widget.accentFontColor, accentColor: widget.accentColor,);
                        } else {
                          return Container();
                        }
                      }),
                ),
              ],
            ),
          );
        } else {
          return CommonWidgets.pageLoadingScreen(context);
        }
      },
    );
  }

  Visibility showSearchBar(BuildContext context) {
    return new Visibility(
      visible: searchVisible,
      child: Container(
        margin: EdgeInsets.all(4.5),
        color: Colors.white,
        child: ListTile(
          title: new TextFormField(
            autofocus: searchVisible,
            controller: controller,
            decoration: new InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: widget.accentFontColor, width: 2.0)),
                hintText: "Search..."),
          ),
          leading: new Icon(Icons.search),
        ),
      ),
    );
  }
}
