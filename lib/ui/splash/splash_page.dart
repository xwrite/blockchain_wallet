
import 'package:blockchain_wallet/routing/routes.dart';
import 'package:blockchain_wallet/ui/splash/splash_view_model.dart';
import 'package:blockchain_wallet/widget/edge_insets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatelessWidget {
  final SplashViewModel viewModel;
  const SplashPage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: XEdgeInsets(horizontal: 24, bottom: 56),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Spacer(flex: 2),
            Text('开始进入 Web3.0', style: Theme.of(context).textTheme.headlineMedium),
            Padding(
              padding: XEdgeInsets(top: 24),
              child: Text(
                '安全的去中心化钱包，为用户的交昜保驾护航，保证用户可安心畅游 Web3 世界',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black54,
                ),
              ),
            ),
            const Spacer(flex: 1),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: Size.fromHeight(40)),
              onPressed: () {
                context.push(Routes.createWallet);
              },
              child: Text('创建钱包'),
            ),
            Padding(
              padding: const XEdgeInsets(top: 16),
              child: OutlinedButton(
                style:
                OutlinedButton.styleFrom(minimumSize: Size.fromHeight(40)),
                onPressed: () {
                },
                child: Text('导入钱包'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
