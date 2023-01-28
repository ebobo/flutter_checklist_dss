// To parse this JSON data, do
//
//     final item = itemFromJson(jsonString);

import 'dart:convert';

Item itemFromJson(String str) => Item.fromJson(json.decode(str));

String itemToJson(Item data) => json.encode(data.toJson());

class Item {
  Item({
    required this.id,
    required this.name,
    required this.position,
    required this.status,
    required this.tag,
  });

  String id;
  String name;
  int position;
  bool status;
  String tag;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        name: json["name"],
        position: json["position"],
        status: json["status"],
        tag: json["tag"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "position": position,
        "status": status,
        "tag": tag,
      };
}
