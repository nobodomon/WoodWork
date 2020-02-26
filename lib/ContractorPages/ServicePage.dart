import 'package:flutter/material.dart';
import 'package:woodwork/ContractorPages/callService.dart';
import 'package:woodwork/ProductionPages/QRPage/ManualInput.dart';
import 'package:woodwork/ProductionPages/QRPage/QrScanner.dart';

class ServicePage extends StatefulWidget{
  ServicePage({this.fontColor, this.accentFontColor, this.accentColor});
  final Color fontColor;
  final Color accentFontColor;
  final Color accentColor;
  @override
  State<StatefulWidget> createState()=> ServicePageState();
}

class ServicePageState extends State<ServicePage> with SingleTickerProviderStateMixin{
  
  int currIndex = 0;

  TabController _tabController;
  
  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: widget.accentFontColor,
        indicatorColor: widget.accentFontColor,
        controller: _tabController,
        isScrollable: true,
        tabs: <Widget>[
          new Tab(
            text: "Call service",
          ),
          new Tab(
            text: "QR Scanner"
          ),
          new Tab(
            text: "Manual Input"
          ),
        ],
      ),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          new CallService(fontColor: widget.fontColor,accentFontColor: widget.accentFontColor, accentColor: widget.accentColor,),
          new QrScanner(fontColor: widget.fontColor,accentFontColor: widget.accentFontColor, accentColor: widget.accentColor, pickup: false,),
          new ManualInput(fontColor: widget.fontColor,accentFontColor: widget.accentFontColor, accentColor: widget.accentColor, pickup: false,)
        ],
      ),
    );
  }

}