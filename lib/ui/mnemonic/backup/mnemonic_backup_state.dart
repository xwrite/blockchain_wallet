import 'package:get/get.dart';

class MnemonicBackupState {

  ///正确的助记词
  final wordList = <String>[];

  ///未选择的助记词
  final unselectedWordListRx = <String>[].obs;

  ///选择的助记词
  final selectedWordListRx = <String>[].obs;

}
