

///eth数量转换工具
class EtherAmountUtil{
  EtherAmountUtil._();

  ///wei转为eth
  ///- accuracy 保留最大小数位
  static String toEth(BigInt wei, {final int accuracy = 4}){
    final oneEth = BigInt.from(1e18);
    final rounding = BigInt.from(500000000000000); // 0.5e15
    final maxDecimal = BigInt.parse('1'.padRight(accuracy + 1,'0'));

    // 分离整数与小数
    BigInt integer = wei ~/ oneEth;
    BigInt decimal = wei % oneEth;

    // 四舍五入到maxDecimal
    BigInt scaled = (decimal * maxDecimal + rounding) ~/ oneEth;

    // 处理进位
    if (scaled >= maxDecimal) {
      integer += BigInt.one;
      scaled -= maxDecimal;
    }

    // 格式小数部分
    String decimalStr = scaled.toString().padLeft(accuracy, '0');
    decimalStr = decimalStr.replaceAll(RegExp(r'0+$'), '');

    return decimalStr.isEmpty ? '$integer' : '$integer.$decimalStr';
  }

  ///eth转为wei
  static BigInt toWei(String eth){
    // 格式校验
    if (!RegExp(r'^(\d+\.?\d*|\.\d+)$').hasMatch(eth)) {
      return BigInt.zero;
    }

    List<String> parts = eth.split('.');
    if (parts.length > 2) {
      return BigInt.zero;
    }

    String integerPart = parts[0].isEmpty ? '0' : parts[0];
    String decimalPart = parts.length == 2 ? parts[1] : '';

    // 小数部分不得超过 18 位
    if (decimalPart.length > 18) {
      return BigInt.zero;
    }

    // 补零到 18 位
    decimalPart = decimalPart.padRight(18, '0').substring(0, 18);

    // 转换为 BigInt
    BigInt integerWei = BigInt.parse(integerPart) * BigInt.from(1e18.toInt());
    BigInt decimalWei = BigInt.parse(decimalPart.isEmpty ? '0' : decimalPart);

    return integerWei + decimalWei;
  }

}