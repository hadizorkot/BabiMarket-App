import 'package:flutter/services.dart' as rootBundle;
import 'dart:convert';
import 'package:babi_market/models/ProductCategory.dart';

class RemoteServices {
  Future<List<ProductCategory>?> getProductCategories() async {
    try {
      // Load the JSON file from assets
      final jsonString = await rootBundle.rootBundle.loadString(
        'assets/ProductCategory.json',
      );

      // Print the content of the JSON file to debug if it's loaded properly
      print(jsonString);

      // Parse the JSON data
      final List<dynamic> jsonResponse = json.decode(jsonString);

      // Convert the JSON data to a list of ProductCategory objects
      return jsonResponse
          .map((category) => ProductCategory.fromJson(category))
          .toList();
    } catch (e) {
      print('Error loading JSON from assets: $e');
      return null;
    }
  }
}
