
import 'package:blockchain_wallet/common/utils/ether_amount_util.dart';

extension AmountFormatExtension on BigInt{

  ///wei转为eth余额显示
  ///- accuracy 保留最大小数位
  ///- currency 币种符号
  String formatEth({final int accuracy = 4, final String currency = 'ETH'}){
    final text = EtherAmountUtil.toEth(this, accuracy: accuracy);
    if(currency.isEmpty){
      return text;
    }else{
      return '$text $currency';
    }
  }

}