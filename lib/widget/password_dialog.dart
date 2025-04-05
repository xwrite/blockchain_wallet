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
          hintText: '请输入密码',
          counterText: '',
        ),
      ),
      actions: [
        TextButton(onPressed: Get.back, child: Text('取消')),
        TextButton(
          onPressed: () {
            if (password.isEmpty) {
              Toast.show('请输入密码');
              return;
            }
            Get.back(result: password);
          },
          child: Text('确定'),
        ),
      ],
    );
  }
}
