// To parse this JSON data, do
//
//     final areaConfig = areaConfigFromJson(jsonString);

import 'dart:convert';

AreaConfig areaConfigFromJson(String str) => AreaConfig.fromJson(json.decode(str));

String areaConfigToJson(AreaConfig data) => json.encode(data.toJson());

class AreaConfig {
  AreaConfig({
    this.name,
    this.storeId,
    this.areaId,
    this.locId,
    this.type,
    this.beacons,
  });

  String? name;
  String? storeId;
  String? areaId;
  String? locId;
  String? type;
  List<String>? beacons;

  factory AreaConfig.fromJson(Map<String, dynamic> json) => AreaConfig(
    name: json["name"],
    storeId: json["store_id"],
    areaId: json["area_id"],
    locId: json["loc_id"],
    type: json["type"],
    beacons: List<String>.from(json["beacons"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "store_id": storeId,
    "area_id": areaId,
    "loc_id": locId,
    "type": type,
    "beacons": List<dynamic>.from(beacons!.map((x) => x)),
  };
}
