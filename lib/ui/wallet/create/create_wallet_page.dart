import 'package:blockchain_wallet/common/utils/password_validator.dart';
import 'package:blockchain_wallet/common/utils/result.dart';
import 'package:blockchain_wallet/routing/routes.dart';
import 'package:blockchain_wallet/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'create_wallet_view_model.dart';

///创建钱包
class CreateWalletPage extends StatefulWidget {
  final CreateWalletViewModel viewModel;

  const CreateWalletPage({super.key, required this.viewModel});

  @override
  State<CreateWalletPage> createState() => _CreateWalletPageState();
}

class _CreateWalletPageState extends State<CreateWalletPage> {
  late final accountNameController = TextEditingController(text: viewModel.name);
  final passwordController = TextEditingController();
  final passwordAgainController = TextEditingController();

  CreateWalletViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    accountNameController.addListener(() {
      viewModel.name = accountNameController.text;
    });
    passwordController.addListener(() {
      viewModel.password = passwordController.text;
    });
    passwordAgainController.addListener(() {
      viewModel.passwordAgain = passwordAgainController.text;
    });
    viewModel.create.addListener((){
      switch(viewModel.create.result){
        case Ok<void>():
          Loading.dismiss();
          Toast.show('创建成功');
          context.go(Routes.home);
          break;
        case Error<void>():
          Loading.dismiss();
          Toast.show('创建失败');
          break;
        case _:
          Loading.show();
          break;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('创建钱包'),
      ),
      body: Form(
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
                child: ListenableBuilder(
                    listenable: viewModel,
                    builder: (_, __) {
                      final valid = viewModel.valid;
                      return FilledButton(
                        onPressed: valid
                            ? () => viewModel.create.execute((
                                  accountNameController.text,
                                  passwordController.text,
                                ))
                            : null,
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
      controller: accountNameController,
      labelText: '账户名称',
      maxLength: 14,
      validator: viewModel.accountNameValidator,
    );
  }

  Widget buildPasswordField() {
    return Column(
      spacing: 4,
      children: [
        buildTextField(
          controller: passwordController,
          obscureText: true,
          maxLength: 32,
          labelText: '请设置密码',
        ),
        ListenableBuilder(
          listenable: viewModel,
          builder: (_, __) {
            final passwordConditions = viewModel.passwordConditions;
            return Row(
              spacing: 8,
              children: PasswordConditionEnum.values.map((element) {
                return Chip(
                  label: Text(element.label),
                  padding: XEdgeInsets(all: 4),
                  labelStyle: passwordConditions.contains(element)
                      ? TextStyle(color: Colors.green)
                      : TextStyle(color: Colors.black38),
                );
              }).toList(growable: false),
            );
          },
        ),
      ],
    );
  }

  Widget buildPasswordAgainField() {
    return buildTextField(
      controller: passwordAgainController,
      obscureText: true,
      maxLength: 32,
      labelText: '请再次输入密码',
      validator: (value) => viewModel.passwordAgainValidator(
        value,
        passwordAgainController.text,
      ),
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

  @override
  void dispose() {
    accountNameController.dispose();
    passwordController.dispose();
    passwordAgainController.dispose();
    super.dispose();
  }
}
