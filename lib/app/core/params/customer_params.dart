class CustomerParams {
  int? id;
  String name;
  String address;
  String phoneNumber1;
  String phoneNumber2;
  int initialAccountBalance;
  String description;

  CustomerParams({
    this.id,
    required this.name,
    required this.address,
    required this.phoneNumber1,
    required this.phoneNumber2,
    required this.initialAccountBalance,
    required this.description,
  });
}
