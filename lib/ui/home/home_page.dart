import 'package:blockchain_wallet/common/utils/result.dart';
import 'package:blockchain_wallet/data/repositories/wallet/wallet_repository.dart';
import 'package:blockchain_wallet/routing/routes.dart';
import 'package:blockchain_wallet/widget/edge_insets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'home_view_model.dart';

class HomePage extends StatelessWidget {
  final HomeViewModel viewModel;
  const HomePage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('区块链钱包')),
      body: SingleChildScrollView(
        padding: XEdgeInsets(all: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            ElevatedButton(onPressed: () async{
              final result = await context.read<WalletRepository>().resetWallet();
              switch(result){
                case Ok<void>():
                  context.go(Routes.splash);
                  break;
                case Error<void>():
                  break;
              }

            }, child: Text('重置'))
          ],
        ),
      ),
    );
  }
}
