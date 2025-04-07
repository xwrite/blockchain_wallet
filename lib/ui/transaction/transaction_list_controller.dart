import 'package:blockchain_wallet/common/int_paging_controller.dart';
import 'package:blockchain_wallet/data/app_database.dart';
import 'package:blockchain_wallet/data/entity/transaction_entity.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:get/get.dart';
import 'transaction_list_state.dart';

class TransactionListController extends GetxController {
  final TransactionListState state = TransactionListState();

  late final pagingController = IntPagingController<TransactionEntity>(
    fetchPage: fetchPage,
  );

  Future<List<TransactionEntity>> fetchPage(int page) {
    return G.db.transactionDao.list(page: page, pageSize: 20);
  }
}
