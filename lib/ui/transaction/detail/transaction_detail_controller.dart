import 'package:get/get.dart';

import 'transaction_detail_state.dart';

class TransactionDetailController extends GetxController {
  final TransactionDetailState state = TransactionDetailState();

  final String txHash;
  TransactionDetailController({required this.txHash});
}
