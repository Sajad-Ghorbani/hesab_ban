class UnitOfProductEntity {
  final int? id;
  final String? name;

  UnitOfProductEntity({this.id, this.name});

  @override
  bool operator ==(other) {
    return other is UnitOfProductEntity && other.id == id;
  }

  @override
  int get hashCode => id!;
}
