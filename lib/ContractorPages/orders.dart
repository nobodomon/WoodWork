import 'package:flutter/material.dart';
import 'package:woodwork/ContractorPages/viewOrders.dart';

class Orders extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => new OrdersState();
  
}

class OrdersState extends State<Orders>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new ListView(
        children: <Widget>[
          new ListTile(
            title: new Text("Order #1"),
            subtitle: new Text("20/12/19"),
            trailing: new IconButton(
              icon: new Icon(Icons.chevron_right),
              onPressed: ()=> Navigator.of(context).push(MaterialPageRoute(builder:(context)=> viewOrders())),
            ),
          )
        ],
      ),
    );
  }
}
