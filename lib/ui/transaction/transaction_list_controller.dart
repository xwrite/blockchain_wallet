import 'package:blockchain_wallet/common/utils/int_paging_controller.dart';
import 'package:blockchain_wallet/data/api/web3_provider.dart';
import 'package:blockchain_wallet/data/app_database.dart';
import 'package:blockchain_wallet/data/entity/transaction_entity.dart';
import 'package:blockchain_wallet/data/repository/transaction_repository.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:get/get.dart';
import 'transaction_list_state.dart';

class TransactionListController extends GetxController {
  final TransactionListState state = TransactionListState();
  static const _kPageSize = 20;
  final _repository = Get.find<TransactionRepository>();

  late final pagingController = IntPagingController<TransactionEntity>(
    fetchPage: fetchPage,
  );

  Future<List<TransactionEntity>> fetchPage(int page) {
    return _repository.getTransactionPage(page: page, pageSize: _kPageSize);
  }
}
