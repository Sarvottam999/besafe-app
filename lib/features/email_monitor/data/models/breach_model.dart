
 import 'package:hive/hive.dart';

part 'breach_model.g.dart';

@HiveType(typeId: 1)
class BreachModel {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String domain;

  @HiveField(3)
  final String breachDate;

  @HiveField(4)
  final String addedDate;

  @HiveField(5)
  final String modifiedDate;

  @HiveField(6)
  final int pwnCount;

  @HiveField(7)
  final String description;

  @HiveField(8)
  final String logoPath;

  @HiveField(9)
  final String? attribution;

  @HiveField(10)
  final List<String> dataClasses;

  @HiveField(11)
  final bool isVerified;

  @HiveField(12)
  final bool isFabricated;

  @HiveField(13)
  final bool isSensitive;

  @HiveField(14)
  final bool isRetired;

  @HiveField(15)
  final bool isSpamList;

  @HiveField(16)
  final bool isMalware;

  @HiveField(17)
  final bool isSubscriptionFree;

  @HiveField(18)
  final bool isStealerLog;

  BreachModel({
    required this.name,
    required this.title,
    required this.domain,
    required this.breachDate,
    required this.addedDate,
    required this.modifiedDate,
    required this.pwnCount,
    required this.description,
    required this.logoPath,
    required this.attribution,
    required this.dataClasses,
    required this.isVerified,
    required this.isFabricated,
    required this.isSensitive,
    required this.isRetired,
    required this.isSpamList,
    required this.isMalware,
    required this.isSubscriptionFree,
    required this.isStealerLog,
  });

  factory BreachModel.fromJson(Map<String, dynamic> json) {
    return BreachModel(
      name: json['Name'] ?? '',
      title: json['Title'] ?? '',
      domain: json['Domain'] ?? '',
      breachDate: json['BreachDate'] ?? '',
      addedDate: json['AddedDate'] ?? '',
      modifiedDate: json['ModifiedDate'] ?? '',
      pwnCount: json['PwnCount'] ?? 0,
      description: json['Description'] ?? '',
      logoPath: json['LogoPath'] ?? '',
      attribution: json['Attribution'],
      dataClasses: List<String>.from(json['DataClasses'] ?? []),
      isVerified: json['IsVerified'] ?? false,
      isFabricated: json['IsFabricated'] ?? false,
      isSensitive: json['IsSensitive'] ?? false,
      isRetired: json['IsRetired'] ?? false,
      isSpamList: json['IsSpamList'] ?? false,
      isMalware: json['IsMalware'] ?? false,
      isSubscriptionFree: json['IsSubscriptionFree'] ?? false,
      isStealerLog: json['IsStealerLog'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "Name": name,
    "Title": title,
    "Domain": domain,
    "BreachDate": breachDate,
    "AddedDate": addedDate,
    "ModifiedDate": modifiedDate,
    "PwnCount": pwnCount,
    "Description": description,
    "LogoPath": logoPath,
    "Attribution": attribution,
    "DataClasses": dataClasses,
    "IsVerified": isVerified,
    "IsFabricated": isFabricated,
    "IsSensitive": isSensitive,
    "IsRetired": isRetired,
    "IsSpamList": isSpamList,
    "IsMalware": isMalware,
    "IsSubscriptionFree": isSubscriptionFree,
    "IsStealerLog": isStealerLog,
  };
}
