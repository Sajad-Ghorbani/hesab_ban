class UserEntity {
  int? id;

  String? name;

  String? phoneNumber;

  String? storeAddress;

  String? storeName;

  String? storeLogo;

  String? userEmail;

  String? hashedPassword;

  UserEntity({
    this.id,
    this.name,
    this.phoneNumber,
    this.storeAddress,
    this.storeName,
    this.storeLogo,
    this.userEmail,
    this.hashedPassword,
  });
}
