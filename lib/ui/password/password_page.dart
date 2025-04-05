import 'package:blockchain_wallet/generated/l10n.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'password_controller.dart';

///设置钱包密码
class PasswordPage extends StatelessWidget {
  const PasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(G.text.setWalletPassword),
      ),
      body: GetBuilder(
        init: PasswordController(),
        builder: (controller){
          final state = controller.state;
          return Padding(
            padding: XEdgeInsets(all: 16),
            child: Column(
              spacing: 8,
              children: [
                buildTextField(
                  isVisiblePassword: state.isPasswordVisible,
                  onToggleVisiblePassword: controller.togglePasswordVisible,
                  hintText: G.text.passwordRequired,
                  helperText: G.text.passwordTips,
                  onChanged: (val) => state.password = val,
                ),
                buildTextField(
                  isVisiblePassword: state.isPasswordAgainVisible,
                  onToggleVisiblePassword: controller.togglePasswordAgainVisible,
                  hintText: G.text.passwordAgainRequired,
                  onChanged: (val) => state.passwordAgain = val,
                ),
                Padding(
                  padding: XEdgeInsets(top: 24),
                  child: ElevatedButton(
                    onPressed: controller.onTapConfirm,
                    child: Text(G.text.createWallet),
                  ),
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
    String? helperText,
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
          helperText: helperText,
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
