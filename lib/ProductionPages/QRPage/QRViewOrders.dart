import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:woodwork/DataAccessors/OrderModel.dart';
import 'package:woodwork/DataAccessors/firestoreAccessors.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';

class QRViewOrder extends StatefulWidget{
  QRViewOrder(this.orderID, this.isProduction, );
  final String orderID;
  final bool isProduction;
  @override
  State<StatefulWidget> createState ()=> new QRViewOrderState();
}

class QRViewOrderState extends State<QRViewOrder>{
  FirestoreAccessors _firestoreAccessors;
  @override
  void initState() {
    _firestoreAccessors = new FirestoreAccessors();
    super.initState();
  }
  bool isLoading;
  Color accentColor = Colors.blueGrey[700];
  
  bool successPopped = false;
  String successMsg = "";
  bool errorPopped = false;
  String errorMsg = "";
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
            body: Stack(
              children: <Widget>[
                new ListView(
                  children: <Widget>[
                    showSuccessMessage(context),
                    showErrorMessage(context),
                    showOrderPlaced(viewingOrder),
                    showDates(viewingOrder),
                    showOrderStatusTile(viewingOrder),
                    orderProcessingButton(context),
                  ],
                ),
                showLoading(context)
              ],
            ),
          );
        }else{ 
          return CommonWidgets.pageLoadingScreen(context);
        }
      },
    );
  }
  
  Container showSuccessMessage(BuildContext context){
    return Container(
      color: Colors.greenAccent,
      child: new Visibility(
        visible: successPopped,
        child: new ListTile(
          title: new Text(successMsg),
          trailing: new IconButton(
            icon: Icon(Icons.highlight_off),
            onPressed:()=> setState(() {
              successPopped = false;
              successMsg = "";
            }),
          )
        ),
      ),
    );
  }

  Container showErrorMessage(BuildContext context){
    return Container(
      color: Colors.red,
      child: new Visibility(
        visible: errorPopped,
        child: new ListTile(
          title: new Text(errorMsg),
          trailing: new IconButton(
            icon: Icon(Icons.highlight_off),
            onPressed:()=> setState(() {
              errorPopped = false;
              errorMsg = "";
            }),
          )
        ),
      ),
    );
  }

  Widget showLoading(BuildContext context){
    return Visibility(
      visible: isLoading,
      child: CommonWidgets.pageLoadingScreen(context),
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

  Widget showOrderPlaced(OrderModel order){
    return new Container(
      child: new ListTile(
        title: new Text("Order placed by: "),
        subtitle: new Text(order.orderedBy),
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

  Widget orderProcessingButton(BuildContext context){
    if(widget.isProduction && viewingOrder.status == 2){
      return new Container(
        padding: EdgeInsets.all(15),
        child: new GradientButton(
          increaseWidthBy: double.infinity,
          gradient: Gradients.taitanum,
          child: new Text("Process Order"),
          callback: () async{
            setState(() {
              isLoading = true;
            });
            validateProcessAndSubmit(viewingOrder.orderID, statusType.order_Processing.index).then((UpdateResult result){
              setState(() {
                isLoading = false;
                if(result.pass){
                  successPopped = true;
                  successMsg = result.remarks;
                }else{
                  errorPopped = true;
                  errorMsg = result.remarks;
                }
              });
            });
          },
        ),
      );
    }else{
      return Container();
    }
  }

  Future<UpdateResult> validateAndSave(String orderID) async{
    if(orderID == "" || orderID == null || orderID.isEmpty){
      return new UpdateResult(pass: false, remarks: "Please enter something in orderID field!");
    }else{
      return _firestoreAccessors.getOrderByID(orderID).then((DocumentSnapshot order){
        if(order.exists){
          return new UpdateResult(pass: true, remarks: order.data['orderStatus'].toString());
        }else{
          return new UpdateResult(pass: false, remarks: "No such order number!");
        }
      });
    }
  }

  Future<UpdateResult> validateProcessAndSubmit(String orderID, int index){
    return validateAndSave(orderID).then((UpdateResult result){
      if(result.pass){
        if(int.parse(result.remarks) == statusType.order_Picked_Up.index){
          return _firestoreAccessors.updateOrderStatus(viewingOrder.orderID, index);
        }else{
          return new UpdateResult(pass: false, remarks: "Invalid operation, order has already been processed!"); 
        }
      }else{
        return new UpdateResult(pass: false, remarks: "No such order number!");
      }
    });
  }
}