import 'package:blockchain_wallet/data/entity/transaction_entity.dart';
import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:blockchain_wallet/widget/edge_insets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'transaction_list_controller.dart';
import 'transaction_list_state.dart';
import 'widget/transaction_list_tile.dart';

///交易列表
class TransactionListPage extends StatelessWidget {
  TransactionListPage({Key? key}) : super(key: key);

  final TransactionListController controller =
      Get.put(TransactionListController());
  final TransactionListState state =
      Get.find<TransactionListController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('转账记录'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => controller.pagingController.refresh(),
        child: PagingListener(
          controller: controller.pagingController,
          builder: (context, state, fetchNextPage) {
            return PagedListView<int, TransactionEntity>(
              padding: XEdgeInsets(all: 8),
              state: state,
              fetchNextPage: fetchNextPage,
              builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (context, item, index) {
                  return TransactionListTile(item: item);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
