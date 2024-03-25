class CustomerEntity {
  final int? id;
  final String? name;
  final String? address;
  final String? phoneNumber1;
  final String? phoneNumber2;
  final int? initialAccountBalance;
  final String? description;
  final bool? isActive;

  CustomerEntity({
    this.id,
    this.name,
    this.address,
    this.phoneNumber1,
    this.phoneNumber2,
    this.initialAccountBalance,
    this.description,
    this.isActive,
  });

  @override
  String toString() {
    return 'CustomerEntity{id: $id, name: $name, address: $address, phoneNumber1: $phoneNumber1, phoneNumber2: $phoneNumber2, initialAccountBalance: $initialAccountBalance, description: $description, isActive: $isActive}';
  }
}
