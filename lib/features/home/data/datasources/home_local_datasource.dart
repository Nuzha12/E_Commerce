import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';

class HomeLocalDataSource {
  Future<List<BannerModel>> getBanners() async {
    final raw = await rootBundle.loadString('assets/data/banners.json');
    final list = jsonDecode(raw) as List;
    return list.map((e) => BannerModel.fromJson(e)).toList();
  }

  Future<List<CategoryModel>> getCategories() async {
    final raw = await rootBundle.loadString('assets/data/categories.json');
    final list = jsonDecode(raw) as List;
    return list.map((e) => CategoryModel.fromJson(e)).toList();
  }
}