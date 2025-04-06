
///转账交易信息
class TransactionEntity {
  ///交易hash
  final String txHash;

  ///发送地址
  final String from;

  ///接收地址
  final String to;

  ///发送数量(wei)
  final String value;

  ///gasPrice
  final String gasPrice;

  ///实际消耗的 Gas
  final int gasUsed;

  ///交易状态 0已广播到网络，1成功，2失败
  final int status;

  ///创建时间
  final int createdAt;

  ///更新时间
  final int updatedAt;

  TransactionEntity({
    required this.txHash,
    required this.from,
    required this.to,
    required this.value,
    required this.gasPrice,
    required this.gasUsed,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionEntity.fromJson(Map<String, dynamic> json){
    return TransactionEntity(
      txHash: json['txHash'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      value: json['value'] ?? '',
      gasPrice: json['gasPrice'] ?? '',
      gasUsed: json['gasUsed'] ?? 0,
      status: json['status'] ?? 0,
      createdAt: json['createdAt'] ?? 0,
      updatedAt: json['updatedAt'] ?? 0,
    );
  }
}
