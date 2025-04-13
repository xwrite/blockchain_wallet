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
        title: Text(Global.text.passwordVerify),
      ),
      body: SecureWidget(
        isSecure: true,
        builder: (_, __, ___){
          return Obx((){
            final isPasswordVisible = state.isPasswordVisibleRx();
            // final isBiometricEnabled = Global.wallet.isBiometricEnabledRx;
            return Padding(
              padding: XEdgeInsets(all: 16),
              child: Column(
                children: [
                  buildTextField(
                    isVisiblePassword: isPasswordVisible,
                    onToggleVisiblePassword: state.isPasswordVisibleRx.toggle,
                    labelText: Global.text.passwordRequired,
                    onChanged: (val) => state.password = val,
                  ),
                  Padding(
                    padding: XEdgeInsets(top: 24),
                    child: ElevatedButton(
                      onPressed: controller.onTapVerifyPassword,
                      child: Text('密码验证'),
                    ),
                  ),
                  // if(isBiometricEnabled) Padding(
                  //   padding: XEdgeInsets(top: 16),
                  //   child: ElevatedButton(
                  //     onPressed: controller.onTapVerifyBiometric,
                  //     child: Text('指纹验证'),
                  //   ),
                  // ),
                ],
              ),
            );
          });
        },
      ),
    );
  }

  Widget buildTextField({
    String? labelText,
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
