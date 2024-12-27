// Provider lưu trạng thái trang hiện tại
import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fashion/models/product_model.dart';
import 'package:http/http.dart' as http;

final currentPageProductProvider = StateProvider<int>((ref) => 0);
final isLoadingProvider = StateProvider<bool>((ref) => false);
final isLoadingMoreProvider = StateProvider<bool>((ref) => false);

Future<List<Product>> fetchDataProduct() async {
  try {
    final url = Uri.parse("https://dummyjson.com/products");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      List<Product> data =
          List<Product>.from(json['products'].map((e) => Product.fromJson(e)));
      return data;
    } else {
      return [];
    }
  } catch (e) {
    throw (e.toString());
  }
}

Future<List<Product>> fetchDataProductSkip(int skip) async {
  const int limit = 20;
  try {
    final url =
        Uri.parse("https://dummyjson.com/products?limit=$limit&skip=$skip");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      List<Product> data =
          List<Product>.from(json['products'].map((e) => Product.fromJson(e)));
      return data;
    } else {
      return [];
    }
  } catch (e) {
    throw (e.toString());
  }
}

Future<List<Product>> fetchDataProductUrl(String uri) async {
  try {
    final url = Uri.parse(uri);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      List<Product> data =
          List<Product>.from(json['products'].map((e) => Product.fromJson(e)));
      return data;
    } else {
      return [];
    }
  } catch (e) {
    throw (e.toString());
  }
}

Future<void> fetchLoadDataProduct(WidgetRef ref) async {
  ref.read(isLoadingProvider.notifier).state = true;
  final newd =
      await fetchDataProductSkip(ref.watch(currentPageProductProvider));
  ref.read(productProvider.notifier).setProducts(newd);
  ref.read(isLoadingProvider.notifier).state = false;
}

Future<void> loadMoreProduct(WidgetRef ref) async {
  if (!ref.watch(isLoadingProvider)) {
    ref.read(isLoadingMoreProvider.notifier).state = true;
    ref.read(currentPageProductProvider.notifier).state += 20;
    final newd =
        await fetchDataProductSkip(ref.watch(currentPageProductProvider));
    ref.read(productProvider.notifier).addProduct(newd);

    ref.read(isLoadingMoreProvider.notifier).state = false;
  }
}

// StateNotifier để quản lý danh sách sản phẩm và trạng thái
class ProductStateNotifier extends StateNotifier<List<Product>> {
  ProductStateNotifier() : super([]);

  // Phương thức để cập nhật danh sách sản phẩm
  void setProducts(List<Product> products) {
    state = [...products];
  }

  // Phương thức để thêm sản phẩm vào danh sách
  void addProduct(List<Product> products) {
    state = [...state, ...products];
  }
}

final productProvider =
    StateNotifierProvider<ProductStateNotifier, List<Product>>(
  (ref) => ProductStateNotifier(),
);

// Provider để lưu trữ dữ liệu sản phẩm toàn cục
final dataProductProvider = StateProvider<List<Product>>((ref) {
  final productList =
      ref.watch(productProvider); // Đọc trạng thái từ productProvider
  return productList;
});

final dataAllProductProvider = FutureProvider<List<Product>>((ref) async {
  return await fetchDataProduct();
});

final dataUriProductProvider =
    FutureProvider.family<List<Product>, String>((ref, uri) async {
  return await fetchDataProductUrl(uri);
});
