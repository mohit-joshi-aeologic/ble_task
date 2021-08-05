import 'dart:async';


import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:ble_task/models/data_recieved.dart';
import 'package:ble_task/widget/navigation_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:collection/collection.dart';



class BeaconDetection extends StatefulWidget {
  @override
  _BeaconDetectionState createState() => _BeaconDetectionState();
}

class _BeaconDetectionState extends State<BeaconDetection> {
  // String _beaconResult = 'Not Scanned Yet.';
  int _nrMessaggesReceived = 0;
  var isRunning = false;
  List<BeaconsResponse> list = [];
  Map<String, List<BeaconsResponse>> groupList = {};
  final StreamController<String> beaconEventsController =
  StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    beaconEventsController.close();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (Platform.isAndroid) {
      //Prominent disclosure
      await BeaconsPlugin.setDisclosureDialogMessage(
          title: "Need Location Permission",
          message: "This app collects location data to work with beacons.");

      //Only in case, you want the dialog to be shown again. By Default, dialog will never be shown if permissions are granted.
      //await BeaconsPlugin.clearDisclosureDialogShowFlag(false);
    }

    BeaconsPlugin.listenToBeacons(beaconEventsController);

    await BeaconsPlugin.addRegion(
        "BeaconType1", "909c3cf9-fc5c-4841-b695-380958a51a5a");
    await BeaconsPlugin.addRegion(
        "BeaconType2", "6a84c716-0f2a-1ce9-f210-6a63bd873dd9");

    beaconEventsController.stream.listen(
            (data) {
          if (data.isNotEmpty) {
            setState(() {
              BeaconsResponse dataRecieved = dataRecievedFromJson(data);

              int index = list
                  .indexWhere((element) => element.uuid == dataRecieved.uuid);

              if (index == -1) {
                list.add(dataRecieved);
              } else {
                list[index] = dataRecieved;
              }

              groupList = groupBy(list, (value) => value.proximity ?? "");

              _nrMessaggesReceived++;
            });
            print("Beacons DataReceived: " + data);
          }
        },
        onDone: () {},
        onError: (error) {
          print("Error: $error");
        });

    //Send 'true' to run in background
    await BeaconsPlugin.runInBackground(true);
    if (Platform.isAndroid) {
      BeaconsPlugin.channel.setMethodCallHandler((call) async {
        if (call.method == 'scannerReady') {
          await BeaconsPlugin.startMonitoring();
          setState(() {
            isRunning = true;
          });
        }
      });
    } else if (Platform.isIOS) {
      await BeaconsPlugin.startMonitoring();
      setState(() {
        isRunning = true;
      });
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: NavigationDrawerWidget(),

        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text('BLE LOCATION'),

        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ...List.generate(
                    groupList.keys.length,
                        (index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "⦿ " + groupList.keys.elementAt(index),
                          style: TextStyle(
                              fontSize: 25, fontStyle: FontStyle.italic),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                        ),
                        ...List.generate(
                            groupList.entries.elementAt(index).value.length,
                                (itemIndex) {
                              /*    var data =
                              groupList.entries.elementAt(index).value[itemIndex];*/
                              var data = groupList.entries
                                  .elementAt(index)
                                  .value[itemIndex]
                                  .uuid;
                              var data1 = groupList.entries
                                  .elementAt(index)
                                  .value[itemIndex]
                                  .rssi;
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  color: Colors.blue[100],
                                  child: ListTile(
                                    title: RichText(
                                      text: TextSpan(
                                        text: 'UUID: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: '$data',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                    trailing: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.brown.shade200,
                                      child: Text(
                                        "$data1\n dBm",
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.black),
                                      ),
                                    ),
                                    selected: true,
                                    onTap: () {},
                                  ),
                                ),
                              );
                              // Text('$data  $data1');
                            }),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  Text('$_nrMessaggesReceived'),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    color: Colors.blueGrey,
                    child: TextButton(
                      onPressed: () async {
                        if (isRunning) {
                          await BeaconsPlugin.stopMonitoring();
                        } else {
                          initPlatformState();
                          await BeaconsPlugin.startMonitoring();
                        }
                        setState(() {
                          isRunning = !isRunning;
                        });
                      },
                      child: Text(isRunning ? '  Stop Scan  ' : '  Start Scan  ',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}