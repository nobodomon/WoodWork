import 'package:flutter/material.dart';
import 'package:woodwork/ProductionPages/QRPage/ManualInput.dart';
import 'package:woodwork/ProductionPages/QRPage/QrScanner.dart';

class Scan extends StatefulWidget{
  Scan({this.fontColor, this.accentFontColor, this.accentColor});
  final Color fontColor;
  final Color accentFontColor;
  final Color accentColor;
  @override
  State<StatefulWidget> createState() => ScanState();
}
  
class ScanState extends State<Scan> with SingleTickerProviderStateMixin{
  int currIndex = 0;

  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    print(widget.fontColor.toString());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: widget.accentColor,

        bottom: new TabBar(
          labelColor: widget.fontColor,
          indicatorColor: widget.fontColor,
          controller: _tabController,
          isScrollable: true,
          tabs: <Widget>[
            new Tab(
              text: "Scan QR",
            ),
            new Tab(
              text: "Manual Input"
            ),
          ],
        )
      ),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          new QrScanner(),
          new ManualInput(fontColor: widget.fontColor,accentFontColor: widget.accentFontColor, accentColor: widget.accentColor)
        ],
      ),
    );
  }
}