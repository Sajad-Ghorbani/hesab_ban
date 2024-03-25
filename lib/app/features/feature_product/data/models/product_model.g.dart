// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 2;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: fields[0] as int?,
      name: fields[1] as String?,
      priceOfBuy: fields[2] as int?,
      priceOfOneSale: fields[3] as int?,
      priceOfMajorSale: fields[4] as int?,
      mainUnit: fields[5] as Unit?,
      subCountingUnit: fields[6] as Unit?,
      mainUnitOfProduct: fields[10] as UnitOfProduct?,
      subCountingUnitOfProduct: fields[11] as UnitOfProduct?,
      count: fields[7] as double?,
      unitRatio: fields[8] as double?,
      category: fields[9] as Category?,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.priceOfBuy)
      ..writeByte(3)
      ..write(obj.priceOfOneSale)
      ..writeByte(4)
      ..write(obj.priceOfMajorSale)
      ..writeByte(5)
      ..write(obj.mainUnit)
      ..writeByte(6)
      ..write(obj.subCountingUnit)
      ..writeByte(10)
      ..write(obj.mainUnitOfProduct)
      ..writeByte(11)
      ..write(obj.subCountingUnitOfProduct)
      ..writeByte(7)
      ..write(obj.count)
      ..writeByte(8)
      ..write(obj.unitRatio)
      ..writeByte(9)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UnitAdapter extends TypeAdapter<Unit> {
  @override
  final int typeId = 3;

  @override
  Unit read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Unit.number;
      case 1:
        return Unit.packet;
      case 2:
        return Unit.meter;
      case 3:
        return Unit.squareMeters;
      case 4:
        return Unit.box;
      case 5:
        return Unit.branch;
      default:
        return Unit.number;
    }
  }

  @override
  void write(BinaryWriter writer, Unit obj) {
    switch (obj) {
      case Unit.number:
        writer.writeByte(0);
        break;
      case Unit.packet:
        writer.writeByte(1);
        break;
      case Unit.meter:
        writer.writeByte(2);
        break;
      case Unit.squareMeters:
        writer.writeByte(3);
        break;
      case Unit.box:
        writer.writeByte(4);
        break;
      case Unit.branch:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UnitAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as int?,
      name: json['name'] as String?,
      priceOfBuy: json['priceOfBuy'] as int?,
      priceOfOneSale: json['priceOfOneSale'] as int?,
      priceOfMajorSale: json['priceOfMajorSale'] as int?,
      mainUnitOfProduct: json['mainUnitOfProduct'] == null
          ? null
          : UnitOfProduct.fromJson(
              json['mainUnitOfProduct'] as Map<String, dynamic>),
      subCountingUnitOfProduct: json['subCountingUnitOfProduct'] == null
          ? null
          : UnitOfProduct.fromJson(
              json['subCountingUnitOfProduct'] as Map<String, dynamic>),
      count: (json['count'] as num?)?.toDouble(),
      unitRatio: (json['unitRatio'] as num?)?.toDouble(),
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'priceOfBuy': instance.priceOfBuy,
      'priceOfOneSale': instance.priceOfOneSale,
      'priceOfMajorSale': instance.priceOfMajorSale,
      'mainUnitOfProduct': instance.mainUnitOfProduct?.toJson(),
      'subCountingUnitOfProduct': instance.subCountingUnitOfProduct?.toJson(),
      'count': instance.count,
      'unitRatio': instance.unitRatio,
      'category': instance.category?.toJson(),
    };
