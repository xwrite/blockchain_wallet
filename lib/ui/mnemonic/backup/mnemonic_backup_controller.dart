import 'dart:math';

import 'package:blockchain_wallet/service/wallet_service.dart';
import 'package:blockchain_wallet/widget/loading.dart';
import 'package:blockchain_wallet/widget/toast.dart';
import 'package:get/get.dart';

import 'mnemonic_backup_state.dart';

class MnemonicBackupController extends GetxController {
  final MnemonicBackupState state = MnemonicBackupState();
  final walletService = Get.find<WalletService>();

  @override
  void onInit() {
    super.onInit();
    final mnemonic = walletService.mnemonic ?? '';
    state.wordList.addAll(mnemonic.split(' '));
    state.unselectedWordListRx.value = List.of(state.wordList)
      ..shuffle(Random.secure());
  }

  void onTapItem(String item) {
    if (state.unselectedWordListRx.contains(item)) {
      _addItem(item);
    } else {
      _deleteItem(item);
    }
  }

  void _addItem(String item) async {
    final nextIndex = state.selectedWordListRx.length;
    if (state.wordList[nextIndex] != item) {
      Toast.show('选的不对');
      return;
    }
    state.unselectedWordListRx.remove(item);
    state.selectedWordListRx
        .addIf(() => !state.selectedWordListRx.contains(item), item);

    //已选择完成，开始验证
    if(state.unselectedWordListRx.isEmpty){
      final mnemonic1 = state.wordList.join(' ');
      final mnemonic2 = state.selectedWordListRx.join(' ');
      if (mnemonic1 != mnemonic2) {
        Toast.show('助记词备份失败');
        return;
      }

      final result =
      await Loading.asyncWrapper(walletService.backupMnemonic(mnemonic1));
      if(result){
        Toast.show('助记词备份成功');
        Get.back(result: true);
      }else{
        Toast.show('助记词备份失败');
      }
    }
  }

  void _deleteItem(String item) {
    state.selectedWordListRx.remove(item);
    state.unselectedWordListRx
        .addIf(() => !state.unselectedWordListRx.contains(item), item);
  }
}
