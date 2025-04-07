import 'package:blockchain_wallet/common/extension/amount_format_extension.dart';
import 'package:blockchain_wallet/data/entity/transaction_entity.dart';
import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionListTile extends StatelessWidget {
  final TransactionEntity item;

  const TransactionListTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {

    final eth = BigInt.tryParse(item.value)?.formatEth(accuracy: 8);

    return GestureDetector(
      onTap: (){
        Get.toNamed(kTransactionDetailPage, parameters: {
          'txHash': item.txHash,
        });
      },
      child: Card(
        child: ListTile(
          isThreeLine: true,
          title: Text(eth ?? '0'),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('From: ${item.from}'),
              Text('To: ${item.to}'),
            ],
          ),
          trailing: Text('${item.status}'),
        ),
      ),
    );
  }
}
