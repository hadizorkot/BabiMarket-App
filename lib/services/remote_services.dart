import 'package:flutter/services.dart' as rootBundle;
import 'dart:convert';
import 'package:babi_market/models/ProductCategory.dart';
import 'package:babi_market/models/Product.dart';

class RemoteServices {
  // Fetch product categories
  Future<List<ProductCategory>?> getProductCategories() async {
    try {
      final jsonString = await rootBundle.rootBundle.loadString(
        'assets/ProductCategory.json',
      );
      final List<dynamic> jsonResponse = json.decode(jsonString);
      return jsonResponse
          .map((category) => ProductCategory.fromJson(category))
          .toList();
    } catch (e) {
      print('Error loading JSON from assets: $e');
      return null;
    }
  }

  // Fetch products by category id
  Future<List<Product>?> getProductsByCategory(int categoryId) async {
    try {
      final jsonString = await rootBundle.rootBundle.loadString(
        'assets/products.json',
      );
      final List<dynamic> jsonResponse = json.decode(jsonString);

      // Find the category with the matching categoryId
      final category = jsonResponse.firstWhere(
        (category) => category["categoryId"] == categoryId,
        orElse: () => null,
      );

      if (category != null) {
        // Convert the products to a list of Product objects
        final List<Product> products = (category["products"] as List)
            .map((product) => Product.fromJson(product))
            .toList();
        return products;
      } else {
        return null; // No products found for the category
      }
    } catch (e) {
      print('Error loading products: $e');
      return null;
    }
  }
}
