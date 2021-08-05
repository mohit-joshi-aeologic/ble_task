/*
import 'dart:async';
import 'dart:io' show Platform;
import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:ble_task/models/AreaConfig.dart';
import 'package:ble_task/models/data_recieved.dart';
import 'package:ble_task/widget/navigation_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class ActiveArea extends StatefulWidget {
  @override
  _ActiveAreaState createState() => _ActiveAreaState();
}

class _ActiveAreaState extends State<ActiveArea> {
  @override
  Widget build(BuildContext context) {

    List<AreaConfig> areaConfigs= [AreaConfig(
        areaId: "0001",
        locId: "djjdjdf",
        beacons: [
          "909c3cf9-fc5c-4841-b695-380958a51a5a"
        ],
        name: "hdhh",
        storeId: "dhdh",
        type: ":jdjdj")];


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text('ACTIVE AREA '),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AreaBeacons(areaConfig: areaConfigs[0],)
            ),
          ),
        ),
      ),
    );
  }
}

class AreaBeacons extends StatefulWidget {
  final AreaConfig areaConfig;
  const AreaBeacons({Key? key, required this.areaConfig }) : super(key: key);

  @override
  _AreaBeaconsState createState() => _AreaBeaconsState();
}

class _AreaBeaconsState extends State<AreaBeacons> {
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
    for (int i = 0; i < widget.areaConfig.beacons!.length; i++) {
      await BeaconsPlugin.addRegion("BeaconType$i", widget.areaConfig.beacons![i]);
    }
*/
/*    await BeaconsPlugin.addRegion(
        "BeaconType1", "909c3cf9-fc5c-4841-b695-380958a51a5a");
    await BeaconsPlugin.addRegion(
        "BeaconType2", "6a84c716-0f2a-1ce9-f210-6a63bd873dd9");*/ /*


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
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Active Area"),
        Text("Area id: ${widget.areaConfig.areaId}"),
        ...List.generate(widget.areaConfig.beacons!.length, (itemIndex) {
          var data = widget.areaConfig.beacons;
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              color: Colors.blue[100],
              child: ListTile(
                title: RichText(
                  text: TextSpan(
                    text: 'Beacons: ',
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
                selected: true,
                onTap: () {},
              ),
            ),
          );
          // Text('$data  $data1');
        }),

            ...List.generate(
                    list.length,
                    (index) => Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            groupList.keys.elementAt(index),
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        ...List.generate(
                            groupList.entries.elementAt(index).value.length,
                            (itemIndex) {
                               var data = groupList.entries.elementAt(index).value[itemIndex];

                          var data1 = groupList.entries
                              .elementAt(index)
                              .value[itemIndex]
                              .uuid;
                          return Text(' $data1');
                        }),
                      ],
                    ),
                  ),
        Padding(
          padding: EdgeInsets.all(10.0),
        ),
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
            child: Text(
                isRunning ? '  Stop Scan  ' : '  Start Scan  ',
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}
*/

import 'dart:async';
import 'dart:io' show Platform;
import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:ble_task/models/data_recieved.dart';
import 'package:ble_task/widget/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class ActiveArea extends StatefulWidget {
  @override
  _ActiveAreaState createState() => _ActiveAreaState();
}

class _ActiveAreaState extends State<ActiveArea> {
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
          title: const Text("ACTIVE AREA"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Container(
                    color: Colors.blueGrey[100],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              text: 'Area Id: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                    text: '0001',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: Colors.black)),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Store Id: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                    text: '123',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: Colors.black)),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Location Id: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                    text: '01',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: Colors.black)),
                              ],
                            ),
                          ),
                          ...List.generate(
                            groupList.keys.length,
                            (index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ...List.generate(
                                    groupList.entries
                                        .elementAt(index)
                                        .value
                                        .length, (itemIndex) {
                                  /*    var data =
                                      groupList.entries.elementAt(index).value[itemIndex];*/
                                  var data = groupList.entries
                                      .elementAt(index)
                                      .value[itemIndex]
                                      .uuid;
                                  var data1 = groupList.entries
                                      .elementAt(index)
                                      .value[itemIndex]
                                      .proximity;
                                  var data2 = groupList.entries
                                          .elementAt(index)
                                          .value[itemIndex]
                                          .areaId ??
                                      "0001";
                                  print("area id is $data2");
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
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 14,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                        ),
                                        trailing: RichText(
                                          text: TextSpan(
                                            text: 'Proximity: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.black),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: '\n$data1',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 14,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                        ),
                                        selected: true,
                                        onTap: () {},
                                      ),
                                    ),
                                  );
                                  // Text('$data  $data1');
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                      child: Text(
                          isRunning ? '  Stop Scan  ' : '  Start Scan  ',
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
