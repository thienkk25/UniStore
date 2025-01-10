// Provider lưu trạng thái trang hiện tại
import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_store/models/product_model.dart';
import 'package:http/http.dart' as http;

final currentPageProductProvider = StateProvider<int>((ref) => 0);
final isLoadingProvider = StateProvider<bool>((ref) => false);
final isLoadingMoreProvider = StateProvider<bool>((ref) => false);

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

class ProductStateNotifier extends StateNotifier<List<Product>> {
  ProductStateNotifier() : super([]);

  void setProducts(List<Product> products) {
    state = [...products];
  }

  void addProduct(List<Product> products) {
    state = [...state, ...products];
  }
}

final productProvider =
    StateNotifierProvider<ProductStateNotifier, List<Product>>(
  (ref) => ProductStateNotifier(),
);

final dataProductProvider = StateProvider<List<Product>>((ref) {
  final productList = ref.watch(productProvider);
  return productList;
});

final dataAllProductProvider = FutureProvider<List<Product>>((ref) async {
  return await fetchDataProduct();
});

final dataUriProductProvider =
    FutureProvider.family<List<Product>, String>((ref, uri) async {
  return await fetchDataProductUrl(uri);
});

Future<List> fetchCartProduct() async {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  String userId = auth.currentUser!.uid;
  try {
    DocumentSnapshot cartDoc =
        await firestore.collection("userCarts").doc(userId).get();
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

class CartProductNotifier extends StateNotifier<List<Product>> {
  CartProductNotifier() : super([]);

  setStateCartProduct(List<Product> products) {
    state = products;
  }

  addStateCartProduct(Product product) {
    if (!state.contains(product)) {
      state = [...state, product];
    }
  }

  removeStateCartProduct(Product product) {
    if (!state.contains(product)) {
      state = state.where((e) => e.id != product.id).toList();
    }
  }
}

final cartProductNotifierProvider =
    StateNotifierProvider<CartProductNotifier, List<Product>>(
        (ref) => CartProductNotifier());

Future<String> addCartProduct(int id) async {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  String userId = auth.currentUser!.uid;
  try {
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
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  String userId = auth.currentUser!.uid;
  try {
    DocumentSnapshot cartDoc =
        await firestore.collection("userCarts").doc(userId).get();

    if (!cartDoc.exists) {
      return "Cart not found";
    }

    Map<String, dynamic>? cartData = cartDoc.data() as Map<String, dynamic>?;
    List<dynamic> products = cartData?['products'] ?? [];

    int productIndex = products.indexWhere((product) => product['id'] == id);
    if (productIndex == -1) {
      return "Product not found in cart";
    }

    products.removeAt(productIndex);

    await firestore
        .collection("userCarts")
        .doc(userId)
        .update({'products': products});
    return "Delete Success";
  } catch (e) {
    return "An error occurred while deleting the product";
  }
}

class CheckBoxYourCartsNotifier extends StateNotifier<List<bool>> {
  CheckBoxYourCartsNotifier() : super([]);
  setStatecheckBoxYourCarts(int length) {
    state = List.generate(length, (index) => true);
  }

  addStatecheckBoxYourCarts() {
    state = [...state, true];
  }

  removeStatecheckBoxYourCarts(int index) {
    if (index >= 0 && index < state.length) {
      state = List.from(state)..removeAt(index);
    }
  }

  void toggleStateCheckBoxYourCarts(int index) {
    if (index >= 0 && index < state.length) {
      final updatedState = List<bool>.from(state);
      updatedState[index] = !updatedState[index];
      state = updatedState;
    }
  }
}

final checkBoxYourCartsProvider =
    StateNotifierProvider<CheckBoxYourCartsNotifier, List<bool>>(
        (ref) => CheckBoxYourCartsNotifier());

class TextEditingControllerYourCarts
    extends StateNotifier<List<TextEditingController>> {
  TextEditingControllerYourCarts() : super([]);
  setStateTextEditingControllerYourCarts(int length) {
    state = List.generate(length, (index) => TextEditingController(text: "1"));
  }

  addStateTextEditingControllerYourCarts(String count) {
    state = [...state, TextEditingController(text: count)];
  }

  removeStateTextEditingControllerYourCarts(int index) {
    if (index >= 0 && index < state.length) {
      state[index].dispose();
      state = List.from(state)..removeAt(index);
    }
  }

  void incrementValue(int index) {
    if (index >= 0 && index < state.length) {
      final controller = state[index];
      final currentValue = int.tryParse(controller.text) ?? 0;
      controller.text = (currentValue + 1).toString();
    }
  }

  void decrementValue(int index) {
    if (index >= 0 && index < state.length) {
      final controller = state[index];
      final currentValue = int.tryParse(controller.text) ?? 0;
      controller.text = (currentValue - 1).toString();
    }
  }
}

final textEditingControllerYourCartsProvider = StateNotifierProvider<
    TextEditingControllerYourCarts,
    List<TextEditingController>>((ref) => TextEditingControllerYourCarts());

Future<List> fetchFavoriteProduct() async {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  String userId = auth.currentUser!.uid;
  try {
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

class FavoriteProductNotifier extends StateNotifier<List<Product>> {
  FavoriteProductNotifier() : super([]);

  setStateFavorite(List<Product> products) {
    state = products;
  }

  addStateFavorite(Product product) {
    if (!state.contains(product)) {
      state = [...state, product];
    }
  }

  removeStateFavorite(Product product) {
    if (state.contains(product)) {
      state = state.where((e) => e.id != product.id).toList();
    }
  }
}

final favoriteProductNotifierProvider =
    StateNotifierProvider<FavoriteProductNotifier, List<Product>>(
        (ref) => FavoriteProductNotifier());

Future<String> addFavoriteProduct(int id) async {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  String userId = auth.currentUser!.uid;
  try {
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
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  String userId = auth.currentUser!.uid;
  try {
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

final quantityProvider = StateProvider<int>(
  (ref) => 1,
);
