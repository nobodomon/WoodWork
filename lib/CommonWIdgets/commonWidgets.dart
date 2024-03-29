import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:woodwork/ContractorPages/viewOrders.dart';
import 'package:woodwork/DataAccessors/OrderModel.dart';

class CommonWidgets extends WidgetsApp{
  static Color accentFontColor = Colors.lightBlue[300];
  static Color accentColor = Colors.grey[900];
  static Color fontColor = Colors.white;
  static Gradient mainGradient = Gradients.deepSpace;
  static Gradient subGradient= Gradients.taitanum;
  
  static MediaQueryData getDeviceInfo(BuildContext context){
    return MediaQuery.of(context);
  }

  static Scaffold pageLoadingScreen(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.black54,
        body: new Center(
          child: new CircularProgressIndicator(),
        ));
  }

  static String mapUserRoleToLongName(int userRole) {
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

  static Color mapUserRoleToColor(int userRole){
    switch (userRole) {
        case 1:
          return Colors.yellow[400];
          break;
        case 2:
          return Colors.red[400];
          break;
        case 3:
          return Colors.blue[400];
          break;
        case 99:
          return Colors.green[400];
          break;
        case 999:
          return Colors.teal[400];
          break;
        case -1:
          return Colors.black;
          break;
        default:
          return Colors.white;
      }
  }

  static String timeStampToString(Timestamp input) {
    DateTime d = input.toDate();
    String formattedDateTime = d.day.toString() +
        "/" +
        d.month.toString() +
        "/" +
        d.year.toString() +
        "@" +
        d.hour.toString() +
        ":" +
        d.minute.toString();
    return formattedDateTime;
  }

  static String createOrderID(Timestamp input) {
    DateTime d = input.toDate();
    String day = d.day.toString();
    if (day.length == 1) {
      day = "0" + day;
    }
    String month = d.month.toString();
    if (month.length == 1) {
      month = "0" + month;
    }
    String hour = d.hour.toString();
    if (hour.length == 1) {
      hour = "0" + hour;
    }
    String minute = d.minute.toString();
    if (minute.length == 1) {
      minute = "0" + minute;
    }
    String second = d.second.toString();
    if (second.length == 1) {
      second = "0" + second;
    }
    String orderID =
        "WW" + day + month + d.year.toString() + hour + minute + second;
    return orderID;
  }

  static Widget logoutDialog(
      BuildContext context, VoidCallback logoutCallback, bool fromSettings) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        margin: new EdgeInsets.all(75),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
                title: new Text("Log-out"),
                subtitle: new Text("Are you sure you want to log out?")),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new FlatButton(
                    child: new Text("Confirm"),
                    onPressed: () {
                      logoutCallback();
                      Navigator.of(context).pop();
                    }),
                new FlatButton(
                    child: new Text("Cancel"),
                    onPressed: () => {Navigator.of(context).pop()})
              ],
            )
          ],
        ),
      ),
    );
  }

  static Widget showOrderTile(BuildContext context, OrderModel order,
      bool isProductionAndItemJustPlaced,
      {int operationToDo,
      Color fontColor,
      Color accentColor,
      Color accentFontColor}) {
    int op = operationToDo;
    if (operationToDo == null) {
      op = -1;
    }
    return new Container(
      margin: EdgeInsets.fromLTRB(4.5, 2.25, 4.5, 2.25),
      decoration: new BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(5),
          border: new Border.all(color: accentFontColor, width: 1.5)),
      child: new ListTile(
      dense: true,
      leading: new Container(
        alignment: Alignment.center,
        width: 45,
        height: 45,
        decoration: new BoxDecoration(
          border: new Border.all(color: accentFontColor,width: 2) ,
            color:Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              new BoxShadow(
                  color: Colors.black87, spreadRadius: 0.75, blurRadius: 1)
            ]),
        child: OrderModel.convertOrderStatusToIcon(order.status, accentFontColor),
        ),
      title: new Text("ID: " + order.orderID, style: TextStyle(color:fontColor)),
      subtitle: new Text("Order Placed: " + order.orderPlaced.split('@')[0], style: TextStyle(color:fontColor)),
      trailing: new IconButton(
        icon: Icon(
          Icons.chevron_right,
          color: accentFontColor,
        ),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewOrder(
                      order.orderID,
                      isProductionAndItemJustPlaced,
                      operationToDo: op,
                      fontColor: fontColor,
                      accentFontColor: accentFontColor,
                      accentColor: accentColor,
                    ))),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewOrder(
                  order.orderID,
                  isProductionAndItemJustPlaced,
                  operationToDo: op,
                  fontColor: fontColor,
                  accentFontColor: accentFontColor,
                  accentColor: accentColor,
                )),
      ),
    ));
  }

  static QrImage generateQR(String orderID, int operation) {
    String embedCode = orderID + "," + operation.toString();
    return QrImage(
      data: embedCode,
    );
  }

  static ParseResult parseQRinput(String input) {
    if (input.length == 16) {
      if (input.substring(0, 2) == 'WW') {
        if (int.parse(input.substring(2)).isNaN == false) {
          return new ParseResult(true, "Input successfully parsed",
              values: input);
        } else {
          return new ParseResult(false, "Invalid QR Code");
        }
      } else {
        return new ParseResult(false, "Invalid QR Code");
      }
    } else {
      return new ParseResult(false, "Invalid QR Code");
    }
  }

  static Widget commonTextFormField(IconData icon, String title,
      TextEditingController controller, Color inputColor, Color accentFontColor,
      {TextInputType type}) {
    return new ListTile(
        leading: new Icon(
          icon,
          color: accentFontColor,
        ),
        title: new TextFormField(
          cursorColor: accentFontColor,
          style: new TextStyle(
            color: inputColor,
          ),
          keyboardType: type,
          controller: controller,
          decoration: new InputDecoration(
              focusColor: accentFontColor,
              labelText: title,
              labelStyle: new TextStyle(
                color: inputColor,
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: accentFontColor, width: 2.0))),
        ));
  }

  static Widget commonPasswordFormField(
      IconData icon,
      String title,
      TextEditingController controller,
      bool visibility,
      Icon visibilityIcon,
      Color inputColor,
      Color accentFontColor,
      VoidCallback visibilityImp,
      {TextInputType type}) {
    return new ListTile(
        leading: new Icon(
          Icons.lock,
          color: accentFontColor,
        ),
        title: new TextFormField(
          cursorColor: accentFontColor,
          style: new TextStyle(
            color: inputColor,
          ),
          controller: controller,
          decoration: new InputDecoration(
              focusColor: accentFontColor,
              labelText: title,
              labelStyle: new TextStyle(
                color: inputColor,
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: accentFontColor, width: 2.0))),
          obscureText: !visibility,
        ),
        trailing: new IconButton(
          icon: visibilityIcon,
          onPressed: visibilityImp,
        ));
  }

  static Widget commonPasswordFormFieldNoToggle(
      IconData icon,
      String title,
      TextEditingController controller,
      bool visibility,
      Color inputColor,
      Color accentFontColor,
      {TextInputType type}) {
    return new ListTile(
        leading: new Icon(
          Icons.lock,
          color: accentFontColor,
        ),
        title: new TextFormField(
          cursorColor: accentFontColor,
          style: new TextStyle(
            color: inputColor,
          ),
          controller: controller,
          decoration: new InputDecoration(
              focusColor: accentFontColor,
              labelText: title,
              labelStyle: new TextStyle(
                color: inputColor,
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: accentFontColor, width: 2.0))),
          obscureText: !visibility,
        ));
  }

  static Widget commonErrorMessage(BuildContext context, bool visibility,
      String message, VoidCallback dismissImp) {
    return Container(
      margin: EdgeInsets.symmetric(vertical:0,horizontal:15),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        gradient: Gradients.backToFuture
      ),
        child: new Visibility(
            visible: visibility,
            child: new ListTile(
              title: new Text(message),
              trailing: new IconButton(
                  icon: Icon(Icons.highlight_off), onPressed: dismissImp),
            )));
  }



  static Widget commonSuccessMessage(BuildContext context, bool visibility,
      String message, VoidCallback dismissImp) {
    return Container(
      margin: EdgeInsets.symmetric(vertical:0,horizontal:15),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        gradient: Gradients.coldLinear
      ),
        child: new Visibility(
            visible: visibility,
            child: new ListTile(
              title: new Text(message),
              trailing: new IconButton(
                  icon: Icon(Icons.highlight_off), onPressed: dismissImp),
            )));
  }
}

class ParseResult {
  ParseResult(this.pass, this.remarks, {this.values});
  bool pass;
  String remarks;
  String values;
}
