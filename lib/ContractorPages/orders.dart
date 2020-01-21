import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:woodwork/AdminPages/DataAccessors/OrderModel.dart';
import 'package:woodwork/AdminPages/DataAccessors/firestoreAccessors.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';
import 'package:woodwork/ContractorPages/viewOrders.dart';

class Orders extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => new OrdersState();
  
}

class OrdersState extends State<Orders>{
  FirestoreAccessors _firestoreAccessors;
  bool searchVisible = false;
  TextEditingController controller = new TextEditingController();
  List<Color> currSearchGrad;
  List<List<Color>> searchGradient = [
    [Colors.blueGrey[700],Colors.blueGrey[400]],
    [Colors.red[700],Colors.red[400]],
  ];
  String filter = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firestoreAccessors = new FirestoreAccessors();
    controller.addListener((){
      setState(() {
        currSearchGrad = searchGradient[0];
        filter = controller.text;
      });
    });
  }
  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new StreamBuilder(
      stream: _firestoreAccessors.getAllOrders().asStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> orders){
        if(orders.hasData){
          return Scaffold(
            floatingActionButton: new Container(
              child: new IconButton(
                icon: new Icon(Icons.search, color: Colors.white),
                onPressed: ()=>setState(() {
                  if(searchVisible){
                    searchVisible = false;
                    currSearchGrad = searchGradient[0];
                  }else{
                    searchVisible = true;
                    currSearchGrad = searchGradient[1];
                  }
                }),
              ),
              width: 45,
              height: 45,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black87,
                    spreadRadius: 0.75,
                    blurRadius: 1
                  )
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
                      OrderModel currOrder = OrderModel.toObject(orders.data.documents[index].documentID, orders.data.documents[index].data);
                      if(filter == null || filter.isEmpty){
                        return showOrderTile(currOrder);
                      }else if(currOrder.orderID.toLowerCase().contains(filter.toLowerCase())){
                        return showOrderTile(currOrder);
                      }else{
                        return Container();
                      }
                    }
                  ),
                ),
              ],
            ),
          );
        }else{
          return CommonWidgets.pageLoadingScreen(context);
        }
      },
    );
  }

  Visibility showSearchBar(BuildContext context){
    return new Visibility(
      visible: searchVisible,
      child: Container(
        margin: EdgeInsets.all(4.5),
        color: Colors.white,
        child: ListTile(
          title: new TextFormField(
            autofocus: true,
            controller: controller,
            decoration: new InputDecoration(
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey[600], width: 2.0)),
              hintText: "Search..."
            ),
          ),
          leading: new Icon(Icons.search),
        ),
      ),
    );
  }

  Widget showOrderTile(OrderModel order){
    return new Container(
      child: new ListTile(
        title: new Text("ID: " + order.orderID),
        subtitle: new Text("Order Placed: " + order.orderPlaced.split('@')[0]),
        trailing: new IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: ()=> Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewOrder(order.orderID)
            )
          ),
        ),
      ),
    );
  }
}
