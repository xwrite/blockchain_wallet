import 'package:blockchain_wallet/common/extension/string_extension.dart';
import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('计数器'),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (ctx, state) {
          return Column(
            children: [
              Text('count ${state.count}'),
              TextButton(
                onPressed: () {
                  ctx.read<HomeCubit>().increment();
                },
                child: Text('+'),
              ),
              TextButton(
                onPressed: () {
                  ctx.read<HomeCubit>().decrement();
                },
                child: Text('-'),
              ),
              ElevatedButton(
                onPressed: () {
                },
                child: Text('GO'),
              )
            ],
          );
        },
      ),
    );
  }
}
