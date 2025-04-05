import 'package:blockchain_wallet/generated/l10n.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'toast.dart';

///密码对话框
class PasswordDialog extends StatelessWidget {
  static var _visible = false;

  const PasswordDialog._({super.key});

  static Future<String?> show() async {
    if (_visible) {
      return null;
    }
    _visible = true;
    return Get.dialog<String>(PasswordDialog._(), barrierDismissible: false)
        .whenComplete(() => _visible = false);
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
          hintText: G.text.passwordRequired,
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
