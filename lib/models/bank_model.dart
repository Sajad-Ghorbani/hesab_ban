import 'package:hive/hive.dart';

part 'bank_model.g.dart';

@HiveType(typeId: 13)
class Bank extends HiveObject{
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? imageAddress;

  Bank({this.name, this.imageAddress});

  Bank.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    imageAddress = json['image_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['image_address'] = imageAddress;
    return data;
  }
}

List<Bank> bankList = [
  Bank(name: 'بانک آینده',imageAddress: 'assets/images/banks_image/Bank_ayandeh.png'),
  Bank(name: 'بانک دی',imageAddress: 'assets/images/banks_image/Bank_dey.png'),
  Bank(name: 'بانک اقتصاد نوین',imageAddress: 'assets/images/banks_image/Bank_eghtesad.png'),
  Bank(name: 'بانک گردشگری',imageAddress: 'assets/images/banks_image/Bank_gardeshgary.png'),
  Bank(name: 'بانک ایران زمین',imageAddress: 'assets/images/banks_image/Bank_iranzamin.png'),
  Bank(name: 'بانک کار آفرین',imageAddress: 'assets/images/banks_image/Bank_karafarin.png'),
  Bank(name: 'بانک کشاورزی',imageAddress: 'assets/images/banks_image/Bank_keshavarzi.png'),
  Bank(name: 'بانک خاورمیانه',imageAddress: 'assets/images/banks_image/Bank_khavar.png'),
  Bank(name: 'بانک مسکن',imageAddress: 'assets/images/banks_image/Bank_maskan.png'),
  Bank(name: 'بانک مهر ایران',imageAddress: 'assets/images/banks_image/Bank_mehr.png'),
  Bank(name: 'بانک ملت',imageAddress: 'assets/images/banks_image/Bank_mellat.png'),
  Bank(name: 'بانک ملی',imageAddress: 'assets/images/banks_image/Bank_melli.png'),
  Bank(name: 'بانک پارسیان',imageAddress: 'assets/images/banks_image/Bank_parsian.png'),
  Bank(name: 'بانک پاسارگاد',imageAddress: 'assets/images/banks_image/Bank_pasargad.png'),
  Bank(name: 'پست بانک ایران',imageAddress: 'assets/images/banks_image/Bank_postbank.png'),
  Bank(name: 'بانک رفاه',imageAddress: 'assets/images/banks_image/Bank_refah.png'),
  Bank(name: 'بانک رسالت',imageAddress: 'assets/images/banks_image/Bank_resalat.png'),
  Bank(name: 'بانک صادرات',imageAddress: 'assets/images/banks_image/Bank_saderat.png'),
  Bank(name: 'بانک سامان',imageAddress: 'assets/images/banks_image/Bank_saman.png'),
  Bank(name: 'بانک سپه',imageAddress: 'assets/images/banks_image/Bank_sepah.png'),
  Bank(name: 'بانک صنعت و مهدن',imageAddress: 'assets/images/banks_image/Bank_sanat.png'),
  Bank(name: 'بانک سرمایه',imageAddress: 'assets/images/banks_image/Bank_sarmaye.png'),
  Bank(name: 'بانک شهر',imageAddress: 'assets/images/banks_image/Bank_shahr.png'),
  Bank(name: 'بانک سینا',imageAddress: 'assets/images/banks_image/Bank_sina.png'),
  Bank(name: 'بانک تجارت',imageAddress: 'assets/images/banks_image/Bank_tejarat.png'),
  Bank(name: 'بانک توسعه صادرات',imageAddress: 'assets/images/banks_image/Bank_toseesaderat.png'),
  Bank(name: 'بانک توسعه تعاون',imageAddress: 'assets/images/banks_image/Bank_toseetaavon.png'),
];