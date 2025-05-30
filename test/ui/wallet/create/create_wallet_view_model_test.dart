
import 'package:blockchain_wallet/ui/wallet/create/create_wallet_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../testing/fake/repositories/fake_wallet_repository.dart';

void main(){
  group('CreateWalletViewModel tests', (){
    late CreateWalletViewModel viewModel;

    setUp((){
      viewModel = CreateWalletViewModel(walletRepository: FakeWalletRepository());
    });

    test('Init values are correct', (){
      expect(viewModel.name, '钱包');
      expect(viewModel.valid, false);
      expect(viewModel.passwordConditions, isEmpty);
      expect(viewModel.create.running, false);
    });
    
    test('accountNameValidator tests', (){
      final ret1 = viewModel.accountNameValidator(null);
      expect(ret1, '需包含2-14个字符');

      final ret2 = viewModel.accountNameValidator('');
      expect(ret2, '需包含2-14个字符');

      final ret3 = viewModel.accountNameValidator('123456789012345');
      expect(ret3, '需包含2-14个字符');

      final ret4 = viewModel.accountNameValidator('ab');
      expect(ret4, null);

    });

    test('password update should trigger passwordConditions', (){
      final ret1 = viewModel.accountNameValidator(null);
      expect(ret1, '需包含2-14个字符');

      final ret2 = viewModel.accountNameValidator('');
      expect(ret2, '需包含2-14个字符');

      final ret3 = viewModel.accountNameValidator('123456789012345');
      expect(ret3, '需包含2-14个字符');

      final ret4 = viewModel.accountNameValidator('ab');
      expect(ret4, null);

    });

    test('name、password、passwordAgain updates should trigger validation', (){

      //名称不符合要求
      viewModel.name = 'a';
      expect(viewModel.valid, false);
      
      //名称符合要求，但密码未设置
      viewModel.name = '钱包1';
      expect(viewModel.valid, false);

      //密码不符合要求
      viewModel.password = 'abc';
      expect(viewModel.valid, false);

      //密码符合要求，但两次密码输入不一致
      viewModel.password = 'abcABC123';
      expect(viewModel.valid, false);

      //两次密码输入不一致
      viewModel.passwordAgain = 'abc';
      expect(viewModel.valid, false);

      //表单验证通过
      viewModel.passwordAgain = 'abcABC123';
      expect(viewModel.valid, true);

    });
    

  });
}