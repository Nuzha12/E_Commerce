import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product_model.dart';

class ProductLocalDataSource {
  Future<List<ProductModel>> getProducts() async {
    final raw = await rootBundle.loadString('assets/data/products.json');
    final list = jsonDecode(raw) as List;
    return list.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<ProductModel> getProductById(int id) async {
    final products = await getProducts();
    return products.firstWhere((e) => e.id == id);
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    final products = await getProducts();
    return products.where((e) {
      return e.name.toLowerCase().contains(query.toLowerCase()) ||
          e.category.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final products = await getProducts();
    if (category == 'All') return products;
    return products.where((e) => e.category.toLowerCase() == category.toLowerCase()).toList();
  }
}