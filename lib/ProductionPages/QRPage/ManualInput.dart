import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';
import 'package:woodwork/DataAccessors/OrderModel.dart';
import 'package:woodwork/DataAccessors/firestoreAccessors.dart';

class ManualInput extends StatefulWidget{
  ManualInput({this.fontColor, this.accentFontColor, this.accentColor});
  final Color fontColor;
  final Color accentFontColor;
  final Color accentColor;
  @override
  State<StatefulWidget> createState() => ManualInputState();
}

class ManualInputState extends State<ManualInput>{
  TextEditingController orderIDController;
  ScrollController _scrollController; 
  FirestoreAccessors _firestoreAccessors;
  String filter = "";
  bool isExpanded = true;
  bool isLoading = false;
  bool isValid = false;

  //Error & success msgs
  bool successPopped = false;
  String successMsg = "";
  bool errorPopped = false;
  String errorMsg = "";
  @override
  void dispose() {
    orderIDController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    orderIDController = new TextEditingController();
    _scrollController = new ScrollController();
    orderIDController.addListener((){
      setState(() {
        filter = orderIDController.text;
      });
    });
    _firestoreAccessors = new FirestoreAccessors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          new ListView(
            children: <Widget>[
              showErrorMessage(context),
              showSuccessMessage(context),
              showOrderIDInputField(),
              showSubmitButton(context),
            ],
          ),

        ]
      ),
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

  Widget showOrderIDInputField(){
    return new ExpansionTile(
      initiallyExpanded: isExpanded,
      leading: new Icon(
        Icons.search,
        color: widget.accentFontColor,
      ),
      title: new TextFormField(
        controller: orderIDController,
        decoration: new InputDecoration(
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey[600], width: 2.0)),
          hintText: "OrderID..."
        ),
        validator: (value){
          if(value == null|| value.isEmpty){
            return "OrderID...";
          }else{
            return value;
          }
        },
      ),
      children: <Widget>[
        populateQuickSearchResult(),
      ],
    );
  }

  Widget populateQuickSearchResult(){
    return FutureBuilder(
      future: _firestoreAccessors.getAllOrdersForProduction(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> orders){
        if(orders.hasData){
          if(orders.data.documents.length > 0){
            return ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: orders.data.documents.length,
              itemBuilder: (BuildContext context, index){
                String docID = orders.data.documents[index].documentID;
                if(filter.isEmpty || filter == null || filter == ""){
                  return quickSearchTileResult(docID);
                }else if(docID.toLowerCase().contains(filter)){
                  return quickSearchTileResult(docID);
                }else{
                  return Container();
                }
              },
            );
          }else{
            return ListTile(
              title: new Text("No orders at the moment",
                style: new TextStyle(
                  color: widget.accentFontColor
                ),
              ),
              leading: new Icon(
                Icons.insert_emoticon,
                color: widget.accentFontColor,
              )
            );
          }
          
        }else{
          return LinearProgressIndicator();
        }
      },
    );
  }

  Widget quickSearchTileResult(String orderID){
    return new ListTile(
      title: new Text(orderID),
      dense: true,
      onTap: (){
        setState(() {
          orderIDController.text = orderID;
          isExpanded = false;
        });
      },
    );
  }

  Widget showSubmitButton(BuildContext context){
    return new Container(
      padding: EdgeInsets.all(15),
      child: new GradientButton(
        increaseWidthBy: double.infinity,
        gradient: Gradients.taitanum,
        child: new Text("Confirm"),
        callback: () async{
          setState(() {
            isLoading = true;
          });
          validateAndSubmit(orderIDController.text, statusType.order_Processing.index).then((UpdateResult result){
            setState(() {
              isLoading = false;
              orderIDController.clear();
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

  Future<UpdateResult> validateAndSubmit(String orderID, int index){
    return validateAndSave(orderID).then((UpdateResult result){
      if(result.pass){
        if(int.parse(result.remarks) == 1){
          return _firestoreAccessors.updateOrderStatus(orderIDController.text, statusType.order_Processing.index);
        }else{
          return new UpdateResult(pass: false, remarks: "Invalid operation, order has already been processed!"); 
        }
      }else{
        return new UpdateResult(pass: false, remarks: "No such order number!");
      }
    });
  }
}