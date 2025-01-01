// Provider lưu trạng thái trang hiện tại
import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fashion/models/product_model.dart';
import 'package:http/http.dart' as http;

final currentPageProductProvider = StateProvider<int>((ref) => 0);
final isLoadingProvider = StateProvider<bool>((ref) => false);
final isLoadingMoreProvider = StateProvider<bool>((ref) => false);
final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

Future<List<Product>> fetchDataProduct() async {
  try {
    final url = Uri.parse("https://dummyjson.com/products?limit=194");
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

Stream<List<dynamic>> fetchCartProduct() {
  return firestore
      .collection("userCarts")
      .doc(auth.currentUser!.uid)
      .snapshots()
      .map((cartDoc) {
    if (cartDoc.exists) {
      return List.from(cartDoc.data()!['products']);
    } else {
      return [];
    }
  });
}

Future<String> addCartProduct(int id) async {
  try {
    String userId = auth.currentUser!.uid;

    DocumentSnapshot cartDoc =
        await firestore.collection("userCarts").doc(userId).get();

    if (cartDoc.exists) {
      Map<String, dynamic> cartData = cartDoc.data() as Map<String, dynamic>;
      List<dynamic> products = cartData['products'] ?? [];

      bool productExists = products.any((product) => product['id'] == id);

      if (productExists) {
        return "Product already in the cart";
      } else {
        await firestore.collection("userCarts").doc(userId).update({
          'products': FieldValue.arrayUnion([
            {
              'id': id,
              'createAt': DateTime.now().toIso8601String(),
            }
          ])
        });
        return "Add Success";
      }
    } else {
      // Nếu giỏ hàng chưa tồn tại, tạo mới giỏ hàng với sản phẩm
      await firestore.collection("userCarts").doc(userId).set({
        'uid': userId,
        'products': [
          {
            'id': id,
            'createAt': DateTime.now().toIso8601String(),
          }
        ]
      });
      return "Add Success";
    }
  } catch (e) {
    return e.toString();
  }
}

Future<String> deleteCartProduct(int id) async {
  try {
    String userId = auth.currentUser!.uid;

    DocumentSnapshot cartDoc =
        await firestore.collection("userCarts").doc(userId).get();

    if (cartDoc.exists) {
      Map<String, dynamic> cartData = cartDoc.data() as Map<String, dynamic>;
      List<dynamic> products = cartData['products'] ?? [];

      bool productExists = products.any((product) => product['id'] == id);

      if (productExists) {
        products.removeWhere((product) => product['id'] == id);
        await firestore
            .collection("userCarts")
            .doc(userId)
            .update({'products': products});

        return "Delete Success";
      } else {
        return "Product not found in cart";
      }
    } else {
      return "Cart not found";
    }
  } catch (e) {
    return e.toString();
  }
}

final dataYourCartsProvider = StateProvider<List<Product>>((ref) => []);
final checkBoxYourCartsProvider = StateProvider<List<bool>>((ref) => []);
final textEditingControllerYourCartsProvider =
    StateProvider<List<TextEditingController>>((ref) => []);
final subTotalProductProvider = StateProvider<double>((ref) => 0);
final discountProductProvider = StateProvider<double>((ref) => 0);
final totalProductProvider = StateProvider<double>((ref) => 0);

Future<List> fetchFavoriteProduct() async {
  try {
    String userId = auth.currentUser!.uid;
    DocumentSnapshot cartDoc =
        await firestore.collection("userFavorites").doc(userId).get();
    if (cartDoc.exists) {
      Map<String, dynamic> cartData = cartDoc.data() as Map<String, dynamic>;
      List<dynamic> products = cartData['products'] ?? [];
      return products;
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}

final fetchFavoriteProductProvider =
    FutureProvider<List>((ref) async => await fetchFavoriteProduct());

Future<String> addFavoriteProduct(int id) async {
  try {
    String userId = auth.currentUser!.uid;

    DocumentSnapshot cartDoc =
        await firestore.collection("userFavorites").doc(userId).get();

    if (cartDoc.exists) {
      Map<String, dynamic> cartData = cartDoc.data() as Map<String, dynamic>;
      List<dynamic> products = cartData['products'] ?? [];

      bool productExists = products.any((product) => product['id'] == id);

      if (productExists) {
        return "Favorite already in the data";
      } else {
        await firestore.collection("userFavorites").doc(userId).update({
          'products': FieldValue.arrayUnion([
            {
              'id': id,
              'createAt': DateTime.now().toIso8601String(),
            }
          ])
        });
        return "Favorite Success";
      }
    } else {
      await firestore.collection("userFavorites").doc(userId).set({
        'uid': userId,
        'products': [
          {
            'id': id,
            'createAt': DateTime.now().toIso8601String(),
          }
        ]
      });
      return "Favorite Success";
    }
  } catch (e) {
    return e.toString();
  }
}

Future<String> deleteFavoriteProduct(int id) async {
  try {
    String userId = auth.currentUser!.uid;

    DocumentSnapshot cartDoc =
        await firestore.collection("userFavorites").doc(userId).get();

    if (cartDoc.exists) {
      Map<String, dynamic> cartData = cartDoc.data() as Map<String, dynamic>;
      List<dynamic> products = cartData['products'] ?? [];

      bool productExists = products.any((product) => product['id'] == id);

      if (productExists) {
        products.removeWhere((product) => product['id'] == id);
        await firestore
            .collection("userFavorites")
            .doc(userId)
            .update({'products': products});

        return "Unfavorite Success";
      } else {
        return "Favorite not found in data";
      }
    } else {
      return "Favorite not found";
    }
  } catch (e) {
    return e.toString();
  }
}
