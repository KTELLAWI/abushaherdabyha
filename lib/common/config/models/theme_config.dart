import '../../constants.dart';

class ThemeConfig {
  String mainColor = '#3FC1BE';
  String? logoImage;
  String? backgroundColor;
  String? primaryColorLight;
  String? textColor;
  String? secondaryColor;
  String? sideMenuColor;

  String get logo => logoImage ?? kLogo;

  ThemeConfig({
    this.mainColor = '#3FC1BE',
    this.logoImage,
    this.backgroundColor,
    this.primaryColorLight,
    this.textColor,
    this.secondaryColor,
    this.sideMenuColor
  });

  ThemeConfig.fromJson(Map config) {
    mainColor = config['MainColor'] ?? '#3FC1BE';
    logoImage = config['logo'];
    backgroundColor = config['backgroundColor'];
    primaryColorLight = config['primaryColorLight'];
    textColor = config['textColor'];
    secondaryColor = config['secondaryColor']; 
    sideMenuColor  = config['sideMenuColor'];
  }

  Map? toJson() {
    var map = <String, dynamic>{};
    map['MainColor'] = mainColor;
    map['logo'] = logoImage;
    map['backgroundColor'] = backgroundColor;
    map['primaryColorLight'] = primaryColorLight;
    map['textColor'] = textColor;
    map['secondaryColor'] = secondaryColor;
    map['sideMenuColor']= sideMenuColor;
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
