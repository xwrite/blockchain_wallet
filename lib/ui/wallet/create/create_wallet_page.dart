import 'package:blockchain_wallet/common/utils/password_validator.dart';
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
      body: Form(
        key: controller.formKey,
        autovalidateMode: AutovalidateMode.onUnfocus,
        child: SingleChildScrollView(
          padding: XEdgeInsets(all: 16),
          child: Column(
            spacing: 16,
            children: [
              buildAccountNameField(),
              buildPasswordField(),
              buildPasswordAgainField(),
              Container(
                padding: XEdgeInsets(top: 24),
                width: double.infinity,
                child: Obx(() {
                  return FilledButton(
                    onPressed:
                        state.isFormReadyRx() ? controller.onTapConfirm : null,
                    child: Text('创建钱包'),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAccountNameField() {
    return buildTextField(
      controller: controller.accountNameFieldController,
      labelText: '账户名称',
      maxLength: 14,
      validator: controller.accountNameValidator,
    );
  }

  Widget buildPasswordField() {
    return Obx(() {
      final passwordConditions = state.passwordConditionsRx();
      return Column(
        spacing: 4,
        children: [
          buildTextField(
            controller: controller.passwordFieldController,
            obscureText: true,
            maxLength: 32,
            labelText: '请设置密码',
          ),
          Row(
            spacing: 8,
            children: PasswordConditionEnum.values.map((element) {
              return Chip(
                label: Text(element.label),
                labelStyle: passwordConditions.contains(element)
                    ? TextStyle(color: Colors.green)
                    : TextStyle(color: Colors.black38),
              );
            }).toList(growable: false),
          ),
        ],
      );
    });
  }

  Widget buildPasswordAgainField() {
    return buildTextField(
      controller: controller.passwordAgainFieldController,
      obscureText: true,
      maxLength: 32,
      labelText: '请再次输入密码',
      validator: controller.passwordAgainValidator,
    );
  }

  Widget buildTextField({
    String? labelText,
    String? helperText,
    bool obscureText = false,
    int maxLength = 32,
    TextEditingController? controller,
    FormFieldValidator<String>? validator,
  }) {
    return ValueListenableBuilder(
      valueListenable: controller ?? ValueNotifier(TextEditingValue.empty),
      builder: (_, value, __) {
        return TextFormField(
          controller: controller,
          maxLength: maxLength,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            labelText: labelText,
            counterText: '',
            helperText: helperText,
            suffixIcon: value.text.isNotEmpty
                ? IconButton(
                    onPressed: controller?.clear,
                    icon: Icon(Icons.clear),
                  )
                : null,
          ),
        );
      },
    );
  }
}
