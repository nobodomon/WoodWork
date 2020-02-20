import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:woodwork/DataAccessors/OrderModel.dart';
import 'package:woodwork/DataAccessors/firestoreAccessors.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';

class ViewOrder extends StatefulWidget{
  ViewOrder(this.orderID, this.isProduction, {this.operationToDo, this.accentFontColor, this.accentColor, this.fontColor});
  
  final Color accentFontColor;
  final Color accentColor;
  final Color fontColor;
  final String orderID;
  final bool isProduction;
  int operationToDo;
  @override
  State<StatefulWidget> createState ()=> new ViewOrderState();
}

class ViewOrderState extends State<ViewOrder>{
  FirestoreAccessors _firestoreAccessors;
  @override
  void initState() {
    _firestoreAccessors = new FirestoreAccessors();
    if(widget.operationToDo == null){
      setState(() {
        widget.operationToDo = -1;
      });
    }
    super.initState();
  }
  bool isLoading= false;
  
  bool successPopped = false;
  String successMsg = "";
  bool errorPopped = false;
  String errorMsg = "";
  OrderModel viewingOrder;
  
  void dismissError(){
    setState(() {
      errorPopped = false;
      errorMsg = "";
    });
  }

  
  void dismissSuccess(){
    setState(() {
      successPopped = false;
      successMsg = "";
    });
  }
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: _firestoreAccessors.getOrderByID(widget.orderID),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> orderchit){
        if(orderchit.hasData){
          viewingOrder = OrderModel.toObject(widget.orderID, orderchit.data.data);
          return new Scaffold(
            backgroundColor: widget.accentColor,
            appBar: new AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: new IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: widget.accentFontColor,
                ),
                onPressed: ()=> Navigator.pop(context),
              ),
              title: new Text(
                widget.orderID,
                style: new TextStyle(
                  color: widget.accentFontColor,
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
                    orderActionButton(context, viewingOrder),
                  ],
                ),
                showLoading(context),
              ],
            ),
          );
        }else if(orderchit.data == null){ 
          return CommonWidgets.pageLoadingScreen(context);
        }else{
          
          return CommonWidgets.pageLoadingScreen(context);
        }
      },
    );
  }
  
  Container showSuccessMessage(BuildContext context){
    return CommonWidgets.commonSuccessMessage(context, successPopped, successMsg, dismissSuccess);
  }

  Container showErrorMessage(BuildContext context){
    return CommonWidgets.commonErrorMessage(context, errorPopped, errorMsg, dismissError);
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
        leading: new Icon(Icons.timeline, color: widget.accentFontColor),
        title: new Text("Order Status: " + OrderModel.convertOrderStatusToReadableString(order.status),
        style: new TextStyle(color: widget.fontColor),),
        subtitle: new LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.accentFontColor
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
        leading: new Icon(Icons.person, color: widget.accentFontColor),
        title: new Text("Order placed by: ",
        style: new TextStyle(color: widget.fontColor),),
        subtitle: new Text(order.orderedBy, style: TextStyle(color:widget.fontColor)),
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
        leading: new Icon(Icons.date_range, color: widget.accentFontColor),
        title: new Text(title,
        style: new TextStyle(color: widget.fontColor),),
        subtitle: new Text("at " + date.split('@')[1], style: TextStyle(color:widget.fontColor)),
      ),
    );
  }
  
  Widget orderActionButton(BuildContext context, OrderModel order){
    int operation;
    String buttonLabel;
    if(widget.operationToDo - order.status == 1){
      switch(widget.operationToDo){
        case 1: operation = statusType.order_Recieved.index;
                buttonLabel = "Recieve Order";
                break;
        case 2: operation = statusType.order_Picked_Up.index;
                buttonLabel = "Pick up Order";
                break;
        case 3: operation = statusType.order_Processing.index;
                buttonLabel = "Process Order";
                break;
        case 4: operation = statusType.order_Delivering.index;
                buttonLabel = "Deliver Order";
                break;
        case 5: operation = statusType.order_Complete.index;
                buttonLabel = "Confirm recieve Order";
                break;
        default: operation = -1;
                buttonLabel = "";
      }
      if(operation == -1){
        return new Container();
      }else{
        return new Container(
          padding: EdgeInsets.all(15),
          child: new GradientButton(
            increaseWidthBy: double.infinity,
            gradient: Gradients.backToFuture,
            child: new Text(buttonLabel),
            callback: () async{
              setState(() {
                isLoading = true;
              });
              validateAndSubmit(viewingOrder.orderID, operation).then((UpdateResult result){
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
      }
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

  Future<UpdateResult> validateAndSubmit(String orderID, int operation){
    return validateAndSave(orderID).then((UpdateResult result){
      if(result.pass){
        if(operation - int.parse(result.remarks) == 1){
          return _firestoreAccessors.updateOrderStatus(viewingOrder.orderID, operation);
        }else{
          return new UpdateResult(pass: false, remarks: "Invalid operation!"); 
        }
      }else{
        return new UpdateResult(pass: false, remarks: "No such order number!");
      }
    });
  }
}