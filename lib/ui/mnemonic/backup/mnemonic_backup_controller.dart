import 'dart:math';

import 'package:blockchain_wallet/generated/l10n.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/service/wallet_service.dart';
import 'package:blockchain_wallet/widget/loading.dart';
import 'package:blockchain_wallet/widget/toast.dart';
import 'package:get/get.dart';

import 'mnemonic_backup_state.dart';

class MnemonicBackupController extends GetxController {
  final MnemonicBackupState state = MnemonicBackupState();

  @override
  void onInit() {
    super.onInit();
    // final mnemonic = Global.wallet.mnemonic ?? '';
    // state.wordList.addAll(mnemonic.split(' '));
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
      Toast.show(Global.text.selectError);
      return;
    }
    state.unselectedWordListRx.remove(item);
    state.selectedWordListRx
        .addIf(() => !state.selectedWordListRx.contains(item), item);

    //已选择完成，开始验证
    if (state.unselectedWordListRx.isEmpty) {
      final mnemonic1 = state.wordList.join(' ');
      final mnemonic2 = state.selectedWordListRx.join(' ');
      if (mnemonic1 != mnemonic2) {
        Toast.show(Global.text.mnemonicBackupFailed);
        return;
      }

      // final result =
      //     await Loading.asyncWrapper(() => Global.wallet.backupMnemonic(mnemonic1));
      // if (result) {
      //   Toast.show(Global.text.mnemonicBackupSuccess);
      //   Get.back(result: true);
      // } else {
      //   Toast.show(Global.text.mnemonicBackupFailed);
      // }
    }
  }

  void _deleteItem(String item) {
    state.selectedWordListRx.remove(item);
    state.unselectedWordListRx
        .addIf(() => !state.unselectedWordListRx.contains(item), item);
  }
}
