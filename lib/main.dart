
import 'package:flutter/material.dart';
import 'dart:async';

//import OneSignal
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() => runApp( MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _debugLabelString = "";

  // CHANGE THIS parameter to true if you want to test GDPR privacy consent


  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    // NOTE: Replace with your own app ID from https://www.onesignal.com
    await OneSignal.shared
        .setAppId("5e6fb46b-a322-4b61-beeb-b2a63d56866d");

    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });




    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
      this.setState(() {
        _debugLabelString =
        "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });



    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });
   }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home:  Scaffold(
          appBar:  AppBar(
            title:  Text('OneSignal Flutter Demo'),
            backgroundColor: Color.fromARGB(255, 212, 86, 83),
          ),
          body: Container(
            padding: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child:  Table(
                children: [
                   TableRow(children: [
                     Container(
                      child:  Text(_debugLabelString),
                      alignment: Alignment.center,
                    )
                  ]),
                ],
              ),
            ),
          )),
    );
  }
}

typedef void OnButtonPressed();

class OneSignalButton extends StatefulWidget {
  final String title;
  final OnButtonPressed onPressed;
  final bool enabled;

  OneSignalButton(this.title, this.onPressed, this.enabled);

  State<StatefulWidget> createState() => new OneSignalButtonState();
}

class OneSignalButtonState extends State<OneSignalButton> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Table(
      children: [
         TableRow(children: [
           FlatButton(
            disabledColor: Color.fromARGB(180, 212, 86, 83),
            disabledTextColor: Colors.white,
            color: Color.fromARGB(255, 212, 86, 83),
            textColor: Colors.white,
            padding: EdgeInsets.all(8.0),
            child:  Text(widget.title),
            onPressed: widget.enabled ? widget.onPressed : null,
          )
        ]),
         TableRow(children: [
          Container(
            height: 8.0,
          )
        ]),
      ],
    );
  }
}
