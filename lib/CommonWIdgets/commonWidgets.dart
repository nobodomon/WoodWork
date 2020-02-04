import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:woodwork/ContractorPages/viewOrders.dart';
import 'package:woodwork/DataAccessors/OrderModel.dart';

class CommonWidgets{
  
  static Scaffold pageLoadingScreen(BuildContext context){
    return new Scaffold(
      backgroundColor: Colors.black54,
      body: new Center(
        child: new CircularProgressIndicator(),
      )
    );
  }

  static String mapUserRoleToLongName(int userRole){
    String userTypeLong = "";
    switch (userRole) {
      case 1:
        userTypeLong = "Contractor";
        break;
      case 2:
        userTypeLong = "Production";
        break;
      case 3:
        userTypeLong = "Delivery";
        break;
      case 99:
        userTypeLong = "Admin";
        break;
      case 999:
        userTypeLong = "S.Admin";
        break;
      case -1:
        userTypeLong = "Invalid/Deleted user";
        break;
    }
    return userTypeLong;
  }

  static String timeStampToString(Timestamp input){
    DateTime d = input.toDate();
    String formattedDateTime = d.day.toString() + "/" + d.month.toString()+ "/" + d.year.toString() + "@" + d.hour.toString() + ":" + d.minute.toString();
    return formattedDateTime;
  }

  static String createOrderID(Timestamp input){
    DateTime d = input.toDate();
    String day = d.day.toString();
    if(day.length == 1){
      day = "0" + day;
    }
    String month = d.month.toString();
    if(month.length == 1){
      month = "0" + month;
    }
    String hour = d.hour.toString();
    if(hour.length == 1){
      hour = "0" + hour;
    }
    String minute = d.minute.toString();
    if(minute.length == 1){
      minute = "0" + minute;
    }
    String second = d.second.toString();
    if(second.length == 1){
      second = "0" + second;
    }
    String orderID = "WW" + day + month + d.year.toString() + hour + minute + second;
    return orderID;
  }

  static Widget logoutDialog(BuildContext context, VoidCallback logoutCallback, bool fromSettings){
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        margin: new EdgeInsets.all(75),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              title: new Text("Log-out"),
              subtitle: new Text("Are you sure you want to log out?")
            ),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new FlatButton(
                  child: new Text("Confirm"),
                  onPressed: (){
                    logoutCallback();
                    Navigator.of(context).pop();
                  }
                ),
                new FlatButton(
                  child: new Text("Cancel"),
                  onPressed: ()=>{Navigator.of(context).pop()}
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  static Widget showOrderTile(BuildContext context,OrderModel order,bool isProductionAndItemJustPlaced, {int operationToDo, Color fontColor, Color accentColor, Color accentFontColor}) {
    int op = operationToDo;
    if(operationToDo == null){
      op = -1;
    }
    return new Container(
      child: new ListTile(
        dense: true,
        leading: OrderModel.convertOrderStatusToIcon(
            order.status, accentFontColor),
        title: new Text("ID: " + order.orderID),
        subtitle: new Text("Order Placed: " + order.orderPlaced.split('@')[0]),
        trailing: new IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewOrder(order.orderID, isProductionAndItemJustPlaced, operationToDo:  op,fontColor: fontColor,accentFontColor: accentFontColor, accentColor: accentColor,))),
        ),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => ViewOrder(order.orderID,isProductionAndItemJustPlaced, operationToDo:  op,fontColor: fontColor,accentFontColor: accentFontColor, accentColor: accentColor,)),
      ),
    ));
  }

  static QrImage generateQR(String orderID, int operation){
    String embedCode = orderID + "," + operation.toString();
    return QrImage(
      data: embedCode,

    );
  }

  static ParseResult parseQRinput(String input){
    if(input.length == 16){
      if(input.substring(0,2) == 'WW'){
        if(int.parse(input.substring(2)).isNaN == false){
          return new ParseResult(true, "Input successfully parsed",values: input);
        }else{
          return new ParseResult(false, "Invalid QR Code");
        }
      }else{
        return new ParseResult(false, "Invalid QR Code");
      }
    }else{
      return new ParseResult(false, "Invalid QR Code");
    }
  }

  

}

class ParseResult{
  ParseResult(this.pass,this.remarks,{this.values});
  bool pass;
  String remarks;
  String values;
}



