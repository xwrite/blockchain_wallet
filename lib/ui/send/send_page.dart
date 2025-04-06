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
      body: Container(
        padding: XEdgeInsets(all: 16),
      ),
    );
  }
}
