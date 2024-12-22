// Provider lưu trạng thái trang hiện tại
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentsSupportPageProvider = StateProvider<int>((ref) => 0);
