import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/widget/edge_insets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_content/secure_content.dart';

import 'import_wallet_controller.dart';
import 'import_wallet_state.dart';

///导入钱包
class ImportWalletPage extends StatelessWidget {
  ImportWalletPage({Key? key}) : super(key: key);

  final ImportWalletController controller = Get.put(ImportWalletController());
  final ImportWalletState state = Get.find<ImportWalletController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(G.text.importWallet)),
      body: SecureWidget(builder: (_,__,___){
        return Padding(
          padding: XEdgeInsets(all: 16),
          child: Obx(() {
            final isPasswordVisible = state.isPasswordVisibleRx();
            final isPasswordAgainVisible = state.isPasswordAgainVisibleRx();
            return Column(
              spacing: 16,
              children: [
                TextField(
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: G.text.mnemonicRequired,
                  ),
                  onChanged: (text) => state.mnemonic = text,
                ),
                buildPasswordField(
                  isVisiblePassword: isPasswordVisible,
                  onToggleVisiblePassword: state.isPasswordVisibleRx.toggle,
                  labelText: G.text.passwordRequired,
                  helperText: G.text.passwordTips,
                  onChanged: (val) => state.password = val,
                ),
                buildPasswordField(
                  isVisiblePassword: isPasswordAgainVisible,
                  onToggleVisiblePassword: state.isPasswordAgainVisibleRx.toggle,
                  labelText: G.text.passwordAgainRequired,
                  onChanged: (val) => state.passwordAgain = val,
                ),
                Padding(
                  padding: XEdgeInsets(top: 24),
                  child: ElevatedButton(
                    onPressed: controller.onTapConfirm,
                    child: Text(G.text.ok),
                  ),
                )
              ],
            );
          }),
        );
      }, isSecure: true),
    );
  }

  Widget buildPasswordField({
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
