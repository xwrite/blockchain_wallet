import 'package:blockchain_wallet/router/app_routes.dart';
import 'package:blockchain_wallet/service/wallet_service.dart';
import 'package:blockchain_wallet/ui/authentication/authentication_controller.dart';
import 'package:blockchain_wallet/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///密码认证
class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('密码验证'),
      ),
      body: GetBuilder(
        init: AuthenticationController(),
        builder: (controller){
          final state = controller.state;
          return Padding(
            padding: XEdgeInsets(all: 16),
            child: Column(
              children: [
                buildTextField(
                  isVisiblePassword: state.isPasswordVisible,
                  onToggleVisiblePassword: controller.togglePasswordVisible,
                  hintText: '请输入密码',
                  onChanged: (val) => state.password = val,
                ),
                Padding(
                  padding: XEdgeInsets(top: 24),
                  child: ElevatedButton(
                    onPressed: controller.onTapVerifyPassword,
                    child: Text('确定'),
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
