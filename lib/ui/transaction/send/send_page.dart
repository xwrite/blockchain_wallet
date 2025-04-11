import 'package:blockchain_wallet/common/extension/amount_format_extension.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/widget/edge_insets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'send_controller.dart';
import 'send_state.dart';

///转账
class SendPage extends StatelessWidget {
  SendPage({Key? key}) : super(key: key);

  final SendController controller = Get.put(SendController());
  final SendState state = Get.find<SendController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('转账')),
      body: Obx(() {
        final balanceText = state.balanceRx().formatEth(accuracy: 8);
        final amount = state.amountRx();
        final feeText = controller.feeRx.formatEth(accuracy: 8);
        final isReadySend = controller.isReadySendRx;
        return SingleChildScrollView(
          padding: XEdgeInsets(all: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Text('余额：$balanceText'),
              TextField(
                decoration: InputDecoration(labelText: '接收地址'),
                onChanged: state.receiveAddressRx.call,
              ),
              TextField(
                controller: controller.amountEditingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: amount == BigInt.zero
                        ? '数量（ETH）'
                        : '数量（${amount.formatEth(accuracy: 8)}）',
                    suffixIcon: TextButton(onPressed: controller.onTapAll, child: Text('全部余额'))
                ),
              ),
              Text('矿工费：$feeText'),
              Container(
                padding: XEdgeInsets(top: 24),
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed:  isReadySend ? controller.onTapSend : null,
                  child: Text(Global.text.ok),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
