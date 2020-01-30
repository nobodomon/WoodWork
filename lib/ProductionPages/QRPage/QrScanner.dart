import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/Authentication/UserProfile.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';
import 'package:woodwork/ContractorPages/viewOrders.dart';

class QrScanner extends StatefulWidget {
  QrScanner({this.fontColor, this.accentFontColor, this.accentColor, this.pickup});
  final Color fontColor;
  final Color accentFontColor;
  final Color accentColor;
  final bool pickup;
  @override
  State<StatefulWidget> createState() => QrScannerState();
}

class QrScannerState extends State<QrScanner> {
  Auth auth = new Auth();
  String camScanOut = "";
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: auth.getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<UserProfile> user) {
        if (user.hasData) {
          return Scaffold(
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
              icon: new Icon(Icons.center_focus_strong,
                  color: widget.fontColor, size: 48),
              tooltip: "Open QR Code Scanner",
              onPressed: () => showDialog(
                context: context,
                child: buildScanner(context, user.data.fsUser.data['Usertype'], pickUp: widget.pickup),
              ),
            ),
          )));
        } else {
          return CommonWidgets.pageLoadingScreen(context);
        }
      },
    );
  }

  Widget buildScanner(BuildContext context, int userRole, {bool pickUp}) {
    int opToDo;
    if(userRole == 1){
      opToDo = 5;
    }else if(userRole == 2){
      opToDo = 3;
    }else if(userRole == 3){
      if(pickUp){
        opToDo = 2;
      }else{
        opToDo = 4;
      }
    }
    return Dialog(
      child: new SizedBox(
        height: 300,
        width: 300,
        child: new QrCamera(
          qrCodeCallback: ((String output) {
            if (output.isNotEmpty) {
              setState(() {
                camScanOut = output;
              });
              print(camScanOut.toString());
              ParseResult result = CommonWidgets.parseQRinput(camScanOut);
              print(result.pass.toString());
              if (result.pass) {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewOrder(result.values, true,
                            operationToDo: opToDo)));
              } else {}
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
