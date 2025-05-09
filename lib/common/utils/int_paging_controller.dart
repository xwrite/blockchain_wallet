import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class IntPagingController<ItemType> extends PagingController<int, ItemType> {
  IntPagingController({required super.fetchPage})
      : super(
          getNextPageKey: (state) {
            if (state.pages?.lastOrNull?.isEmpty ?? false) {
              return null;
            }
            return (state.keys?.lastOrNull ?? 0) + 1;
          },
        );
}
