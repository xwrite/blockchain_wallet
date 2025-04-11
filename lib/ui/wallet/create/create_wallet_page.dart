import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_content/secure_content.dart';

import 'create_wallet_controller.dart';
import 'create_wallet_state.dart';

///创建钱包
class CreateWalletPage extends StatelessWidget {

  CreateWalletPage({super.key});

  final CreateWalletController controller = Get.put(CreateWalletController());
  final CreateWalletState state = Get.find<CreateWalletController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Global.text.createWallet),
      ),
      body: SecureWidget(builder: (_,__,___){
        return Obx((){
          final isPasswordVisible = state.isPasswordVisibleRx();
          final isPasswordAgainVisible = state.isPasswordAgainVisibleRx();
          return Padding(
            padding: XEdgeInsets(all: 16),
            child: Column(
              spacing: 16,
              children: [
                buildTextField(
                  isVisiblePassword: isPasswordVisible,
                  onToggleVisiblePassword: state.isPasswordVisibleRx.toggle,
                  labelText: Global.text.passwordRequired,
                  helperText: Global.text.passwordTips,
                  onChanged: (val) => state.password = val,
                ),
                buildTextField(
                  isVisiblePassword: isPasswordAgainVisible,
                  onToggleVisiblePassword: state.isPasswordAgainVisibleRx.toggle,
                  labelText: Global.text.passwordAgainRequired,
                  onChanged: (val) => state.passwordAgain = val,
                ),
                Padding(
                  padding: XEdgeInsets(top: 24),
                  child: ElevatedButton(
                    onPressed: controller.onTapConfirm,
                    child: Text(Global.text.ok),
                  ),
                ),
              ],
            ),
          );
        });
      }, isSecure: true),
    );
  }

  Widget buildTextField({
    String? labelText,
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
          labelText: labelText,
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
