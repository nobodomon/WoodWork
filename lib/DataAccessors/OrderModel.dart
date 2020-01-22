import 'package:flutter/material.dart';

enum statusType{
  order_Placed,
  order_Recieved,
  order_Picked_Up,
  order_Processing,
  order_Delivering,
  order_Complete
}
class OrderModel{
  OrderModel(this.orderID,this.orderedBy,this.status,this.orderPlaced,this.lastUpdated);
  String orderID;
  String orderedBy;
  int status;
  //Status Types
  //Order placed, Order recieved, Order picked up, Order Processing, Order delivering, Order Complete
  String lastUpdated;
  String orderPlaced;


  static OrderModel toObject(String orderID, Map<String, dynamic> data){
    String orderedBy = data['orderedBy'];
    int orderStatus = data['orderStatus'];
    String lastUpdated = data['lastUpdated'];
    String orderPlaced = data['orderPlaced'];
    return OrderModel(orderID, orderedBy,orderStatus,orderPlaced,lastUpdated);
  }

  static double convertOrderStatusToValue(int orderStatus){
    
    switch(statusType.values[orderStatus]){
      case statusType.order_Placed :  return 0.0;
                            break;
      case statusType.order_Recieved:  return 0.2;
                            break;
      case  statusType.order_Picked_Up:  return 0.4;
                            break;
      case statusType.order_Processing:  return 0.6;
                            break;
      case statusType.order_Delivering:  return 0.8;
                            break;
      case statusType.order_Complete:  return 1.0;
                            break;
      default:  return null;
                break;
    }
  }

  static String convertOrderStatusToReadableString(int orderStatus){
    switch(statusType.values[orderStatus]){
      case statusType.order_Placed :  return "Order Placed";
                            break;
      case statusType.order_Recieved:  return "Order Recieved";
                            break;
      case  statusType.order_Picked_Up:  return "Order Picked Up";
                            break;
      case statusType.order_Processing:  return "Order Processing";
                            break;
      case statusType.order_Delivering:  return "Order Delivering";
                            break;
      case statusType.order_Complete:  return "Order Complete";
                            break;
      default:  return null;
                break;
    }
  }

  static Icon convertOrderStatusToIcon(int orderStatus, Color accentColor){
    
    switch(statusType.values[orderStatus]){
      case statusType.order_Placed :  return Icon(
        Icons.playlist_add_check,
        semanticLabel: "Order Placed",
        color: accentColor,
      );
        break;
      case statusType.order_Recieved:  return Icon(
        Icons.receipt,
        semanticLabel: "Order Recieved",
        color: accentColor,);
        break;
      case  statusType.order_Picked_Up:  return Icon(
        Icons.local_shipping,
        semanticLabel: "Order Picked up",
        color: accentColor,);
        break;
      case statusType.order_Processing:  return Icon(
        Icons.gavel,
        semanticLabel: "Order Processing",
        color: accentColor,);
        break;
      case statusType.order_Delivering:  return Icon(
        Icons.local_shipping,
        semanticLabel: "Order Delivering",
        color: accentColor,);
        break;
      case statusType.order_Complete:  return Icon(
        Icons.check,
        semanticLabel: "Order Complete",
        color: accentColor,);
        break;
      default:  return null;
        break;
    }
  }
}