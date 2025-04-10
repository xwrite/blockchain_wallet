import 'dart:async';

import 'package:blockchain_wallet/data/repository/transaction_repository.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/widget/widget.dart';
import 'package:get/get.dart';

import 'transaction_detail_state.dart';

class TransactionDetailController extends GetxController {
  final TransactionDetailState state = TransactionDetailState();

  final String txHash;
  Timer? _timer;
  final _repository = Get.find<TransactionRepository>();
  TransactionDetailController({required this.txHash});

  @override
  void onInit() {
    super.onInit();
    Loading.asyncWrapper(fetchData);
  }

  Future<void> fetchData() async{
    final entity = await _repository.getTransaction(txHash);
    state.transactionRx.value = entity;
    if( entity?.status == 0){
      //轮询
      _timer = Timer(Duration(seconds: 3), fetchData);
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

}
