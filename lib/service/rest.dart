import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:checklist_flutter/model/item.dart';

class RestService {
  String baseUrl = 'http://127.0.0.1:9099';

  //Get all items
  Future<List<Item>> getListItems() async {
    if (baseUrl == '') {
      return [];
    }
    final response = await http.get(Uri.parse('$baseUrl/api/v1/items'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) {
        return List<dynamic>.from(data).map((e) => Item.fromJson(e)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  //Create new item
  Future<Item> createItem(Item item) async {
    final response = await http.post(Uri.parse('$baseUrl/api/v1/item'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(item.toJson()));

    if (response.statusCode == 201) {
      return Item.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create item');
    }
  }

  //Update item
  Future<Item> updateItem(Item item) async {
    final response =
        await http.put(Uri.parse('$baseUrl/api/v1/item/${item.id}'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(item.toJson()));

    if (response.statusCode == 200) {
      return Item.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update item');
    }
  }

  //Delete item
  Future<void> deleteItem(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/v1/item/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete item');
    }
  }
}
