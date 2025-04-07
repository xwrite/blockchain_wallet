
///钱包地址
class AddressEntity {

  ///地址
  final String address;

  ///派生路径
  final String path;

  ///地址index
  final int index;

  ///是否是主页显示的地址,1是，0否
  final int selected;

  ///创建时间
  final int createdAt;

  ///更新时间
  final int updatedAt;

  AddressEntity({
    required this.address,
    required this.path,
    required this.index,
    required this.selected,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddressEntity.fromJson(Map<String, dynamic> json){
    return AddressEntity(
      address: json['address'] ?? '',
      path: json['path'] ?? '',
      index: json['index'] ?? 0,
      selected: json['selected'] ?? 0,
      createdAt: json['createdAt'] ?? 0,
      updatedAt: json['updatedAt'] ?? 0,
    );
  }
}
