import 'package:blockchain_wallet/generated/l10n.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/ui/authentication/authentication_controller.dart';
import 'package:blockchain_wallet/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_content/secure_content.dart';

import 'authentication_state.dart';

///密码认证
class AuthenticationPage extends StatelessWidget {
  AuthenticationPage({super.key});

  AuthenticationController controller = Get.put(AuthenticationController());
  final AuthenticationState state = Get.find<AuthenticationController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(G.text.passwordVerify),
      ),
      body: SecureWidget(
        isSecure: true,
        builder: (_, __, ___){
          return Obx((){
            final isPasswordVisible = state.isPasswordVisibleRx();
            return Padding(
              padding: XEdgeInsets(all: 16),
              child: Column(
                children: [
                  buildTextField(
                    isVisiblePassword: isPasswordVisible,
                    onToggleVisiblePassword: state.isPasswordVisibleRx.toggle,
                    hintText: G.text.passwordRequired,
                    onChanged: (val) => state.password = val,
                  ),
                  Padding(
                    padding: XEdgeInsets(top: 24),
                    child: ElevatedButton(
                      onPressed: controller.onTapVerifyPassword,
                      child: Text(G.text.ok),
                    ),
                  ),
                ],
              ),
            );
          });
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
