// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breach_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BreachModelAdapter extends TypeAdapter<BreachModel> {
  @override
  final int typeId = 1;

  @override
  BreachModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BreachModel(
      name: fields[0] as String,
      title: fields[1] as String,
      domain: fields[2] as String,
      breachDate: fields[3] as String,
      addedDate: fields[4] as String,
      modifiedDate: fields[5] as String,
      pwnCount: fields[6] as int,
      description: fields[7] as String,
      logoPath: fields[8] as String,
      attribution: fields[9] as String?,
      dataClasses: (fields[10] as List).cast<String>(),
      isVerified: fields[11] as bool,
      isFabricated: fields[12] as bool,
      isSensitive: fields[13] as bool,
      isRetired: fields[14] as bool,
      isSpamList: fields[15] as bool,
      isMalware: fields[16] as bool,
      isSubscriptionFree: fields[17] as bool,
      isStealerLog: fields[18] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BreachModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.domain)
      ..writeByte(3)
      ..write(obj.breachDate)
      ..writeByte(4)
      ..write(obj.addedDate)
      ..writeByte(5)
      ..write(obj.modifiedDate)
      ..writeByte(6)
      ..write(obj.pwnCount)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.logoPath)
      ..writeByte(9)
      ..write(obj.attribution)
      ..writeByte(10)
      ..write(obj.dataClasses)
      ..writeByte(11)
      ..write(obj.isVerified)
      ..writeByte(12)
      ..write(obj.isFabricated)
      ..writeByte(13)
      ..write(obj.isSensitive)
      ..writeByte(14)
      ..write(obj.isRetired)
      ..writeByte(15)
      ..write(obj.isSpamList)
      ..writeByte(16)
      ..write(obj.isMalware)
      ..writeByte(17)
      ..write(obj.isSubscriptionFree)
      ..writeByte(18)
      ..write(obj.isStealerLog);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BreachModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
