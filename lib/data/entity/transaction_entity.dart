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
  final int? gasUsed;

  ///区块哈希
  final String? blockHash;

  ///区块号
  final int? blockNumber;

  ///交易状态 0已广播到网络，1成功，2失败
  final int status;

  ///类型 0转账
  final int type;

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
    required this.status,
    required this.type,
    this.gasUsed,
    this.blockHash,
    this.blockNumber,
    this.createdAt = 0,
    this.updatedAt = 0,
  });

  factory TransactionEntity.fromJson(Map<String, dynamic> json) {
    return TransactionEntity(
      txHash: json['txHash'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      value: json['value'] ?? '',
      gasPrice: json['gasPrice'] ?? '',
      gasUsed: json['gasUsed'],
      blockHash: json['blockHash'],
      blockNumber: json['blockNumber'],
      status: json['status'] ?? 0,
      type: json['type'] ?? 0,
      createdAt: json['createdAt'] ?? 0,
      updatedAt: json['updatedAt'] ?? 0,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'txHash': txHash,
      'from': from,
      'to': to,
      'value': value,
      'gasPrice': gasPrice,
      'gasUsed': gasUsed,
      'blockHash': blockHash,
      'blockNumber': blockNumber,
      'status': status,
      'type': type,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  TransactionEntity copyWith({
    String? txHash,
    String? from,
    String? to,
    String? value,
    String? gasPrice,
    int? gasUsed,
    String? blockHash,
    int? blockNumber,
    int? status,
    int? type,
    int? createdAt,
    int? updatedAt,
  }) {
    return TransactionEntity(
      txHash: txHash ?? this.txHash,
      from: from ?? this.from,
      to: to ?? this.to,
      value: value ?? this.value,
      gasPrice: gasPrice ?? this.gasPrice,
      gasUsed: gasUsed ?? this.gasUsed,
      blockHash: blockHash ?? this.blockHash,
      blockNumber: blockNumber ?? this.blockNumber,
      status: status ?? this.status,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
