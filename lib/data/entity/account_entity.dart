
///账户
class AccountEntity {

  ///地址
  final String address;

  ///币种类型（https://github.com/satoshilabs/slips/blob/master/slip-0044.md）
  final int coin;

  ///地址index
  final int index;

  ///是否是主页显示的地址,1是，0否
  final int selected;

  ///创建时间
  final DateTime createdAt;

  ///更新时间
  final DateTime updatedAt;

  AccountEntity({
    required this.address,
    required this.coin,
    required this.index,
    required this.selected,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AccountEntity.fromJson(Map<String, dynamic> json){
    return AccountEntity(
      address: json['address'] ?? '',
      coin: json['coin'] ?? -1,
      index: json['index'] ?? 0,
      selected: json['selected'] ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] ?? 0),
    );
  }
}
