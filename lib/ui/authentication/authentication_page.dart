import 'package:blockchain_wallet/common/extension/observable_extension.dart';
import 'package:blockchain_wallet/generated/l10n.dart';
import 'package:blockchain_wallet/ui/authentication/authentication_cubit.dart';
import 'package:blockchain_wallet/widget/edge_insets.dart';
import 'package:blockchain_wallet/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///设置钱包密码
class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthenticationCubit(),
      child: const _AuthenticationView(),
    );
  }
}

class _AuthenticationView extends StatelessWidget {
  const _AuthenticationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.setWalletPassword),
      ),
      body: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        buildWhen: (previous, current) {
          return current.isPasswordVisible != previous.isPasswordVisible ||
              current.isPasswordAgainVisible != previous.isPasswordAgainVisible;
        },
        builder: (ctx, state) {
          final cubit = ctx.read<AuthenticationCubit>();
          return Padding(
            padding: XEdgeInsets(all: 16),
            child: Column(
              spacing: 8,
              children: [
                buildTextField(
                  isVisiblePassword: state.isPasswordVisible,
                  onToggleVisiblePassword: cubit.togglePasswordVisible,
                  hintText: '请输入密码',
                  onChanged: cubit.changePassword,
                ),
                buildTextField(
                  isVisiblePassword: state.isPasswordAgainVisible,
                  onToggleVisiblePassword: cubit.togglePasswordAgainVisible,
                  hintText: '请再次输入密码',
                  onChanged: cubit.changePasswordAgain,
                ),
                ElevatedButton(
                  onPressed: () {
                    cubit.confirm().subscribeUi();
                  },
                  child: Text('确定'),
                ),
                ElevatedButton(
                  onPressed: () {
                    cubit.verifyPassword().subscribeUi(
                      onSuccess: (_){
                        Toast.show('验证成功');
                      }
                    );
                  },
                  child: Text('验证密码'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildTextField({
    String? hintText,
    bool isVisiblePassword = false,
    VoidCallback? onToggleVisiblePassword,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      maxLength: 32,
      obscureText: !isVisiblePassword,
      keyboardType: TextInputType.visiblePassword,
      onChanged: onChanged,
      decoration: InputDecoration(
          hintText: hintText,
          counterText: '',
          suffixIcon: IconButton(
            onPressed: onToggleVisiblePassword,
            icon: Icon(
              isVisiblePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
          )),
    );
  }
}
