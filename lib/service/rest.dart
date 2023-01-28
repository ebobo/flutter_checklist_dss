import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:checklist_flutter/model/item.dart';

class RestService {
  String baseUrl = 'http://127.0.0.1:9099';

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
}
