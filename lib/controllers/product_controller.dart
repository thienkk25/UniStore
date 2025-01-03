import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fashion/models/product_model.dart';
import 'package:shop_fashion/services/riverpod_home_view.dart';
import 'package:shop_fashion/services/riverpod_product.dart';

class ProductController {
  List<Product> dataAllProductController(WidgetRef ref) {
    final productAsyncValue = ref.watch(dataAllProductProvider);

    return productAsyncValue.when(
      data: (products) => products,
      loading: () => [],
      error: (error, stack) => [],
    );
  }

  AsyncValue<List<Product>> dataUriProductController(
      WidgetRef ref, String uri) {
    return ref.watch(dataUriProductProvider(uri));
  }

  void fetchDataProductController(WidgetRef ref) {
    fetchLoadDataProduct(ref);
  }

  void loadMoreProductController(WidgetRef ref) {
    loadMoreProduct(ref);
  }

  Future<void> fetchCartProductController(WidgetRef ref) async {
    List<Product> dataProduct = await fetchDataProduct();
    final productValue = await fetchCartProduct();

    List<Product> data = dataProduct
        .where((element) =>
            productValue.any((product) => product['id'] == element.id))
        .toList();
    ref.read(cartProductNotifierProvider.notifier).setStateCartProduct(data);
    ref
        .read(checkBoxYourCartsProvider.notifier)
        .setStatecheckBoxYourCarts(data.length);
    ref
        .read(textEditingControllerYourCartsProvider.notifier)
        .setStateTextEditingControllerYourCarts(data.length);
    ref.read(badgeCartProvider.notifier).state = data.length;
  }

  Future<String> addCartProductController(int id) async {
    return await addCartProduct(id);
  }

  Future<String> deleteCartProductController(int id) async {
    return await deleteCartProduct(id);
  }

  Future<void> fetchFavoriteProductController(WidgetRef ref) async {
    List<Product> dataProduct = await fetchDataProduct();
    final productValue = await fetchFavoriteProduct();

    List<Product> data = dataProduct
        .where((element) =>
            productValue.any((product) => product['id'] == element.id))
        .toList();
    ref.read(favoriteProductNotifierProvider.notifier).setStateFavorite(data);
    ref.read(badgeFavoriteProvider.notifier).state = data.length;
  }

  Future<String> addFavoriteProductController(int id) async {
    return await addFavoriteProduct(id);
  }

  Future<String> deleteFavoriteProductController(int id) async {
    return await deleteFavoriteProduct(id);
  }
}

final productControllerProvider = Provider((ref) => ProductController());
