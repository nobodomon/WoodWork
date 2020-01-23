import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';
import 'package:woodwork/ContractorPages/viewOrders.dart';
import 'package:woodwork/DataAccessors/OrderModel.dart';

import 'QRViewOrders.dart';

class QrScanner extends StatefulWidget {
  QrScanner({this.fontColor, this.accentFontColor, this.accentColor});
  final Color fontColor;
  final Color accentFontColor;
  final Color accentColor;
  @override
  State<StatefulWidget> createState() => QrScannerState();
}

class QrScannerState extends State<QrScanner> {
  String camScanOut = "";
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Center(
            child: new Container(
      width: 150,
      height: 150,
      decoration: new BoxDecoration(
          gradient: Gradients.taitanum,
          shape: BoxShape.circle,
          border: Border.all(color: widget.fontColor, width: 3),
          boxShadow: [
            new BoxShadow(
                color: widget.accentFontColor,
                spreadRadius: 7.5,
                blurRadius: 7.5)
          ]),
      child: IconButton(
        icon: new Icon(
          Icons.center_focus_strong,
          color: widget.fontColor,
          size: 48
        ),
        tooltip: "Open QR Code Scanner",
        onPressed: () => showDialog(
          context: context,
          child: buildScanner(context),
        ),
      ),
    )));
  }

  Widget buildScanner(BuildContext context) {
    return Dialog(
      child: new SizedBox(
        height: 300,
        width: 300,
        child: new QrCamera(
          qrCodeCallback:((String output) {
            
            if (output.isNotEmpty) {
              setState(() {
                camScanOut = output;
              });
              print(camScanOut.toString());
              ParseResult result = CommonWidgets.parseQRinput(camScanOut);
              if (result.pass) {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewOrder(result.values[0], true,
                            operationToDo: int.parse(result.values[1]))));
                
              } else {

              }
            }
          }),
          notStartedBuilder: (BuildContext context) {
            return Container(
                decoration: new BoxDecoration(
                    border: Border.all(color: widget.accentColor, width: 2.5)),
                child: Icon(
                  Icons.remove_red_eye,
                  color: widget.accentFontColor,
                ));
          },
          offscreenBuilder: (BuildContext context) {
            return Container(
                decoration: new BoxDecoration(
                    border: Border.all(color: widget.accentColor, width: 2.5)),
                child: Icon(
                  Icons.remove_red_eye,
                  color: widget.accentFontColor,
                ));
          },
        ),
      ),
    );
  }
}
