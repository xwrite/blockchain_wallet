import 'package:blockchain_wallet/global.dart';
import 'package:blockchain_wallet/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///密码认证对话框
class AuthenticationDialog extends StatelessWidget {
  static var _visible = false;

  const AuthenticationDialog._({super.key});

  static Future<bool?> show({VoidCallback? onSuccess}) async {
    if (_visible) {
      return null;
    }
    _visible = true;
    final password = await Get.dialog<String>(
      AuthenticationDialog._(),
      barrierDismissible: false,
    ).whenComplete(() => _visible = false);

    if (password == null) {
      return null;
    }
    final result =
        await Loading.asyncWrapper(G.wallet.authentication(password));
    if (!result) {
      Toast.show(G.text.passwordError);
    }else{
      onSuccess?.call();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var password = '123abcABC';
    return AlertDialog(
      content: TextField(
        maxLength: 32,
        obscureText: true,
        autofocus: true,
        keyboardType: TextInputType.visiblePassword,
        onChanged: (val) => password = val,
        decoration: InputDecoration(
          labelText: G.text.passwordRequired,
          counterText: '',
        ),
      ),
      actions: [
        TextButton(onPressed: Get.back, child: Text(G.text.cancel)),
        TextButton(
          onPressed: () {
            if (password.isEmpty) {
              Toast.show(G.text.passwordRequired);
              return;
            }
            Get.back(result: password);
          },
          child: Text(G.text.ok),
        ),
      ],
    );
  }
}
