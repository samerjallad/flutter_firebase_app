class User {
  User({
    required this.imageName,
    required this.appName,
    required this.androidAvailable,
    required this.iosAvailable,
    required this.description,
    required this.paidFree,
    required this.paidFreeIOS,
    required this.andLink,
    required this.iosLink,
    required this.playStoreLogoLink,
    required this.appStoreLogoLink,
    required this.huaweiStoreLogoLink,
    required this.samsungStoreLogoLink,
    required this.huaweiAvailable,
    required this.huaweiAppLink,
    required this.samsungAppLink,
    required this.samsungAvailable,
    required this.samsungPaid,
    required this.huaweiPaid,
  });
  final String imageName;
  final String appName;
  final String androidAvailable;
  final String iosAvailable;
  final String paidFree;
  final String paidFreeIOS;
  final String description;
  final String andLink;
  final String iosLink;
  final String playStoreLogoLink;
  final String appStoreLogoLink;
  final String huaweiStoreLogoLink;
  final String samsungStoreLogoLink;
  final String huaweiAvailable;
  final String huaweiAppLink;
  final String samsungAppLink;
  final String samsungAvailable;
  final String samsungPaid;
  final String huaweiPaid;

  Map<String, dynamic> toJson() => {
        'imageName': imageName,
        'appName': appName,
        'androidAvailable': androidAvailable,
        'iosAvailable': iosAvailable,
        'description': description,
        'paidFree': paidFree,
        'paidFreeIOS': paidFreeIOS,
        'andLink': andLink,
        'iosLink': iosLink,
        'playStoreLogoLink': playStoreLogoLink,
        'appStoreLogoLink': appStoreLogoLink,
        'huaweiStoreLogoLink': huaweiStoreLogoLink,
        'samsungStoreLogoLink': samsungStoreLogoLink,
        'huaweiAvailable': huaweiAvailable,
        'huaweiAppLink': huaweiAppLink,
        'samsungAvailable': samsungAvailable,
        'samsungAppLink': samsungAppLink,
        'samsungPaid': samsungPaid,
        'huaweiPaid': huaweiPaid,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        imageName: json['imageName'],
        appName: json['appName'],
        androidAvailable: json['androidAvailable'],
        iosAvailable: json['iosAvailable'],
        description: json['description'],
        paidFree: json['paidFree'],
        paidFreeIOS: json['paidFreeIOS'],
        andLink: json['andLink'],
        iosLink: json['iosLink'],
        playStoreLogoLink: json['playStoreLogoLink'],
        appStoreLogoLink: json['appStoreLogoLink'],
        huaweiStoreLogoLink: json['huaweiStoreLogoLink'],
        samsungStoreLogoLink: json['samsungStoreLogoLink'],
        huaweiAvailable: json['huaweiAvailable'],
        huaweiAppLink: json['huaweiAppLink'],
        samsungAppLink: json['samsungAppLink'],
        samsungAvailable: json['samsungAvailable'],
        samsungPaid: json['samsungPaid'],
        huaweiPaid: json['huaweiPaid'],
      );
}
