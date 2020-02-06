import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/Authentication/UserProfile.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';
import 'package:woodwork/ContractorPages/viewOrders.dart';
import 'package:woodwork/DataAccessors/firestoreAccessors.dart';

class ManualInput extends StatefulWidget {
  ManualInput({this.fontColor, this.accentFontColor, this.accentColor, this.pickup, this.recieve});
  final Color fontColor;
  final Color accentFontColor;
  final Color accentColor;
  final bool pickup;
  final bool recieve;
  @override
  State<StatefulWidget> createState() => ManualInputState();
}

class ManualInputState extends State<ManualInput> {
  TextEditingController orderIDController;
  ScrollController _scrollController;
  FirestoreAccessors _firestoreAccessors;
  String filter = "";
  bool isLoading = false;
  bool isValid = false;
  int opToDo;
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
    orderIDController.addListener(() {
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
      backgroundColor: widget.accentColor,
      body: Stack(children: <Widget>[
        new ListView(
          children: <Widget>[
            showErrorMessage(context),
            showSuccessMessage(context),
            showOrderIDInputField(),
            showSubmitButton(context),
          ],
        ),
      ]),
    );
  }

  Container showSuccessMessage(BuildContext context) {
    return Container(
      color: Colors.greenAccent,
      child: new Visibility(
        visible: successPopped,
        child: new ListTile(
            title: new Text(successMsg),
            trailing: new IconButton(
              icon: Icon(Icons.highlight_off),
              onPressed: () => setState(() {
                successPopped = false;
                successMsg = "";
              }),
            )),
      ),
    );
  }

  Container showErrorMessage(BuildContext context) {
    return Container(
      color: Colors.red,
      child: new Visibility(
        visible: errorPopped,
        child: new ListTile(
            title: new Text(errorMsg),
            trailing: new IconButton(
              icon: Icon(Icons.highlight_off),
              onPressed: () => setState(() {
                errorPopped = false;
                errorMsg = "";
              }),
            )),
      ),
    );
  }

  Widget showLoading(BuildContext context) {
    return Visibility(
      visible: isLoading,
      child: CommonWidgets.pageLoadingScreen(context),
    );
  }

  Widget showOrderIDInputField() {
    return new ExpansionTile(
      initiallyExpanded: true,
      title: CommonWidgets.commonTextFormField(Icons.insert_drive_file, "Order ID", orderIDController, widget.fontColor, widget.accentFontColor),
      trailing: new Container(
        width: 0,
        height: 0,
      ),
      children: <Widget>[
        populateQuickSearchResult(pickup: widget.pickup, recieve: widget.recieve),
      ],
    );
  }

  Widget populateQuickSearchResult({bool pickup, bool recieve}){
    Auth auth = new Auth();
    return FutureBuilder(
      future: auth.getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<UserProfile> user){
        if(user.hasData){
          switch(user.data.fsUser.data['Usertype']){
            case 2: if(widget.recieve){
                      opToDo = 1;
                      return populateQuickSearchResultRecieve(opToDo);
                    }else{
                      opToDo = 3;
                      return populateQuickSearchResultProduction(opToDo);
                    }
                    break;
            case 3: if(widget.pickup){
                      opToDo = 2;
                      return populateQuickSearchResultPickup(opToDo);
                    }else{
                    opToDo = 4;
                      return populateQuickSearchResultDelivery(opToDo);
                    }
                    break;
            case 1: opToDo = 5;
                    return populateQuickSearchResultComplete(opToDo);
                    break;
            default: return CommonWidgets.pageLoadingScreen(context);
          }
        }else{
          return CommonWidgets.pageLoadingScreen(context);
        }
      },
    );
  }

  Widget populateQuickSearchResultRecieve(int opToDo) {
    return FutureBuilder(
      future: _firestoreAccessors.getAllOrdersForPickUp(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> orders) {
        if (orders.hasData) {
          if (orders.data.documents.length > 0) {
            return ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: orders.data.documents.length,
              itemBuilder: (BuildContext context, index) {
                String docID = orders.data.documents[index].documentID;
                if (filter.isEmpty || filter == null || filter == "") {
                  return quickSearchTileResult(docID, opToDo);
                } else if (docID.toLowerCase().contains(filter)) {
                  return quickSearchTileResult(docID, opToDo);
                } else {
                  return Container();
                }
              },
            );
          } else {
            return ListTile(
                title: new Text(
                  "No orders at the moment",
                  style: new TextStyle(color: widget.accentFontColor),
                ),
                leading: new Icon(
                  Icons.insert_emoticon,
                  color: widget.accentFontColor,
                ));
          }
        } else {
          return LinearProgressIndicator();
        }
      },
    );
  }

  Widget populateQuickSearchResultPickup(int opToDo) {
    return FutureBuilder(
      future: _firestoreAccessors.getAllOrdersForPickUp(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> orders) {
        if (orders.hasData) {
          if (orders.data.documents.length > 0) {
            return ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: orders.data.documents.length,
              itemBuilder: (BuildContext context, index) {
                String docID = orders.data.documents[index].documentID;
                if (filter.isEmpty || filter == null || filter == "") {
                  return quickSearchTileResult(docID, opToDo);
                } else if (docID.toLowerCase().contains(filter)) {
                  return quickSearchTileResult(docID, opToDo);
                } else {
                  return Container();
                }
              },
            );
          } else {
            return ListTile(
                title: new Text(
                  "No orders at the moment",
                  style: new TextStyle(color: widget.accentFontColor),
                ),
                leading: new Icon(
                  Icons.insert_emoticon,
                  color: widget.accentFontColor,
                ));
          }
        } else {
          return LinearProgressIndicator();
        }
      },
    );
  }

  Widget populateQuickSearchResultProduction(int opToDo) {
    return FutureBuilder(
      future: _firestoreAccessors.getAllOrdersForProduction(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> orders) {
        if (orders.hasData) {
          if (orders.data.documents.length > 0) {
            return ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: orders.data.documents.length,
              itemBuilder: (BuildContext context, index) {
                String docID = orders.data.documents[index].documentID;
                if (filter.isEmpty || filter == null || filter == "") {
                  return quickSearchTileResult(docID, opToDo);
                } else if (docID.toLowerCase().contains(filter)) {
                  return quickSearchTileResult(docID, opToDo);
                } else {
                  return Container();
                }
              },
            );
          } else {
            return ListTile(
                title: new Text(
                  "No orders at the moment",
                  style: new TextStyle(color: widget.accentFontColor),
                ),
                leading: new Icon(
                  Icons.insert_emoticon,
                  color: widget.accentFontColor,
                ));
          }
        } else {
          return LinearProgressIndicator();
        }
      },
    );
  }
  Widget populateQuickSearchResultDelivery(int opToDo) {
    return FutureBuilder(
      future: _firestoreAccessors.getAllOrdersForDelivery(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> orders) {
        if (orders.hasData) {
          if (orders.data.documents.length > 0) {
            return ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: orders.data.documents.length,
              itemBuilder: (BuildContext context, index) {
                String docID = orders.data.documents[index].documentID;
                if (filter.isEmpty || filter == null || filter == "") {
                  return quickSearchTileResult(docID, opToDo);
                } else if (docID.toLowerCase().contains(filter)) {
                  return quickSearchTileResult(docID, opToDo);
                } else {
                  return Container();
                }
              },
            );
          } else {
            return ListTile(
                title: new Text(
                  "No orders at the moment",
                  style: new TextStyle(color: widget.accentFontColor),
                ),
                leading: new Icon(
                  Icons.insert_emoticon,
                  color: widget.accentFontColor,
                ));
          }
        } else {
          return LinearProgressIndicator();
        }
      },
    );
  }

  Widget populateQuickSearchResultComplete(int opToDo) {
    return FutureBuilder(
      future: _firestoreAccessors.getAllOrdersForCompletion(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> orders) {
        if (orders.hasData) {
          if (orders.data.documents.length > 0) {
            return ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: orders.data.documents.length,
              itemBuilder: (BuildContext context, index) {
                String docID = orders.data.documents[index].documentID;
                if (filter.isEmpty || filter == null || filter == "") {
                  return quickSearchTileResult(docID, opToDo);
                } else if (docID.toLowerCase().contains(filter)) {
                  return quickSearchTileResult(docID, opToDo);
                } else {
                  return Container();
                }
              },
            );
          } else {
            return ListTile(
                title: new Text(
                  "No orders at the moment",
                  style: new TextStyle(color: widget.accentFontColor),
                ),
                leading: new Icon(
                  Icons.insert_emoticon,
                  color: widget.accentFontColor,
                ));
          }
        } else {
          return LinearProgressIndicator();
        }
      },
    );
  }

  Widget quickSearchTileResult(String orderID, int opToDo) {
    return new ListTile(
      title: new Text(orderID,
          style: new TextStyle(
            color: widget.accentFontColor,
          )),
      dense: true,
      trailing: new IconButton(
        icon: Icon(
          Icons.chevron_right,
          color: widget.accentFontColor,
        ),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => ViewOrder(orderID, false, operationToDo: opToDo,fontColor: widget.fontColor, accentFontColor: widget.accentFontColor, accentColor: widget.accentColor,))),
      ),
      onTap: () {
        setState(() {
          orderIDController.text = orderID;
        });
      },
    );
  }

  Widget showSubmitButton(BuildContext context) {
    return new Container(
      padding: EdgeInsets.all(15),
      child: new GradientButton(
        increaseWidthBy: double.infinity,
        gradient: Gradients.backToFuture,
        child: new Text("Confirm"),
        callback: () async {
          setState(() {
            isLoading = true;
          });
          validateAndSubmit(
                  orderIDController.text, opToDo)
              .then((UpdateResult result) {
            setState(() {
              isLoading = false;
              orderIDController.clear();
              if (result.pass) {
                successPopped = true;
                successMsg = result.remarks;
              } else {
                errorPopped = true;
                errorMsg = result.remarks;
              }
            });
          });
        },
      ),
    );
  }

  Future<UpdateResult> validateAndSave(String orderID) async {
    if (orderID == "" || orderID == null || orderID.isEmpty) {
      return new UpdateResult(
          pass: false, remarks: "Please enter something in orderID field!");
    } else {
      return _firestoreAccessors
          .getOrderByID(orderID)
          .then((DocumentSnapshot order) {
        if (order.exists) {
          return new UpdateResult(
              pass: true, remarks: order.data['orderStatus'].toString());
        } else {
          return new UpdateResult(
              pass: false, remarks: "No such order number!");
        }
      });
    }
  }

  Future<UpdateResult> validateAndSubmit(String orderID, int operation) {
    return validateAndSave(orderID).then((UpdateResult result) {
      if (result.pass) {
        if (operation - int.parse(result.remarks) == 1) {
          return _firestoreAccessors.updateOrderStatus(orderID, operation);
        } else {
          return new UpdateResult(pass: false, remarks: "Invalid operation!");
        }
      } else {
        return new UpdateResult(pass: false, remarks: "No such order number!");
      }
    });
  }
}
