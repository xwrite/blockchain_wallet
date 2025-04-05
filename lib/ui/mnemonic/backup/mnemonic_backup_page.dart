import 'package:blockchain_wallet/widget/edge_insets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'mnemonic_backup_controller.dart';
import 'mnemonic_backup_state.dart';

///备份助记词
class MnemonicBackupPage extends StatelessWidget {
  MnemonicBackupPage({Key? key}) : super(key: key);

  final MnemonicBackupController controller =
      Get.put(MnemonicBackupController());
  final MnemonicBackupState state = Get.find<MnemonicBackupController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('备份助记词'),
      ),
      body: Obx(() {
        final unselectedWordList = state.unselectedWordListRx();
        final selectedWordList = state.selectedWordListRx();
        return Column(
          children: [
            buildItems(unselectedWordList),
            Divider(),
            buildItems(selectedWordList),
          ],
        );
      }),
    );
  }

  Widget buildItems(List<String> items) {
    return Expanded(
      child: Padding(
        padding: XEdgeInsets(all: 16),
        child: Wrap(
          spacing: 16,
          runSpacing: 12,
          children: items.map((item) {
            return ElevatedButton(
              onPressed: () {
                controller.onTapItem(item);
              },
              child: Text(item),
            );
          }).toList(),
        ),
      ),
    );
  }
}
