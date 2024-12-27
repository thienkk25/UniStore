import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fashion/models/product_model.dart';
import 'package:shop_fashion/services/riverpod.dart';

class ProductController {
  // Phương thức này sử dụng `WidgetRef` để lấy dữ liệu từ `dataAllProductProvider`
  List<Product> dataAllProductController(WidgetRef ref) {
    // Watch the FutureProvider for data and handle loading state properly.
    final productAsyncValue = ref.watch(dataAllProductProvider);

    return productAsyncValue.when(
      data: (products) => products, // Khi có dữ liệu, trả về danh sách sản phẩm
      loading: () => [], // Trả về danh sách rỗng khi đang tải dữ liệu
      error: (error, stack) => [], // Trả về danh sách rỗng nếu có lỗi
    );
  }

  List<Product> dataUriProductController(WidgetRef ref, String uri) {
    // Watch the FutureProvider for data and handle loading state properly.
    final productAsyncValue = ref.watch(dataUriProductProvider(uri));

    return productAsyncValue.when(
      data: (products) => products, // Khi có dữ liệu, trả về danh sách sản phẩm
      loading: () => [], // Trả về danh sách rỗng khi đang tải dữ liệu
      error: (error, stack) => [], // Trả về danh sách rỗng nếu có lỗi
    );
  }

  void fetchDataProductController(WidgetRef ref) {
    fetchLoadDataProduct(ref);
  }

  void loadMoreProductController(WidgetRef ref) {
    loadMoreProduct(ref);
  }
}

final productControllerProvider = Provider((ref) => ProductController());
