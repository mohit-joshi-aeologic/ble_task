import 'dart:convert';

BeaconsResponse dataRecievedFromJson(String str) => BeaconsResponse.fromJson(json.decode(str));

String dataRecievedToJson(BeaconsResponse data) => json.encode(data.toJson());

class BeaconsResponse {
  BeaconsResponse({
    this.name,
    this.uuid,
    this.macAddress,
    this.major,
    this.minor,
    this.distance,
    this.proximity,
    this.scanTime,
    this.rssi,
    this.txPower,
    this.areaId
  });

  String? name;
  String? uuid;
  String? macAddress;
  String? major;
  String? minor;
  String? distance;
  String? proximity;
  String? scanTime;
  String? rssi;
  String? txPower;
  String? areaId;


  factory BeaconsResponse.fromJson(Map<String, dynamic> json) => BeaconsResponse(
    name: json["name"],
    uuid: json["uuid"],
    macAddress: json["macAddress"],
    major: json["major"],
    minor: json["minor"],
    distance: json["distance"],
    proximity: json["proximity"],
    scanTime: json["scanTime"],
    rssi: json["rssi"],
    txPower: json["txPower"],
    areaId: json["areaId"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "uuid": uuid,
    "macAddress": macAddress,
    "major": major,
    "minor": minor,
    "distance": distance,
    "proximity": proximity,
    "scanTime": scanTime,
    "rssi": rssi,
    "txPower": txPower,
    "areaId": areaId,
  };

  @override
  String toString() {
    return 'DataRecieved{name: $name, uuid: $uuid, macAddress: $macAddress, major: $major, minor: $minor, distance: $distance, proximity: $proximity, scanTime: $scanTime, rssi: $rssi, txPower: $txPower,areaId:$areaId}';
  }
}
