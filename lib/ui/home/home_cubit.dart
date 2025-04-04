import 'package:bloc/bloc.dart';
import 'package:blockchain_wallet/common/util/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:wallet_core_bindings/wallet_core_bindings.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  void increment(){
    emit(state.copyWith(count: state.count + 1));
  }

  void decrement(){
    emit(state.copyWith(count: state.count - 1));
    final isEthAddress = TWAnyAddress.isValid(
        '0x4E5B2e1dc63F6b91cb6Cd759936495434C7e972F', TWCoinType.Ethereum);

    logger.d('isEthAddress: $isEthAddress');

    final privateKey = TWPrivateKey();
    logger.d('privateKey: ${privateKey.data.toString()}');

  }
}
