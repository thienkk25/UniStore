import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_fashion/services/riverpod_product.dart';

final badgeNotifyProvider = StateProvider<int>((ref) => 0);
final badgeCartProvider = StateProvider<int>((ref) => 0);
final badgeFavoriteProvider = StateProvider<int>((ref) => 0);

void resetStateAllProviderNeed(WidgetRef ref) {
  List resetStateProvider = [
    badgeNotifyProvider,
    badgeCartProvider,
    badgeFavoriteProvider,
    currentPageProductProvider,
  ];
  for (var element in resetStateProvider) {
    ref.read(element.notifier).state = 0;
  }
  ref.read(isLoadingProvider.notifier).state = false;
  ref.read(isLoadingMoreProvider.notifier).state = false;
}
