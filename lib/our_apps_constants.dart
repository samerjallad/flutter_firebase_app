import 'package:flutter/material.dart';

const kOurAppsRecommendedNaseem = Color(0xFFFCC28C);
const kOurAppsFloatMenuButtonlColor = Colors.white;
const kOurAppsAppBlue = Color(0xFF3E97D7);
const kOurAppsCardTextColor = Color(0xFF707070);
const kOurAppsActionBarColor = Color(0xFF263D6A);
const kOurAppsAppGreyDark = Color(0xFF707070);
//====for the main screen
const kOurAppsMainScreenCards = Color(0xFFECEFF1);

TextStyle kOurAppsAppDescription() {
  return const TextStyle(
    color: kOurAppsCardTextColor,
    fontSize: 16,
    fontFamily: 'Segoe UI',
  );
}

TextStyle kOurAppsWifiCheck({required double scaleFactor}) {
  return TextStyle(
    color: kOurAppsAppGreyDark,
    fontSize: 18 * scaleFactor,
    fontFamily: 'Segoe UI',
    fontWeight: FontWeight.w900,
    wordSpacing: 2,
  );
}

TextStyle kOurAppsCanNotFind({required double scaleFactor}) {
  return TextStyle(
    color: kOurAppsAppGreyDark,
    fontSize: 14 * scaleFactor,
    fontFamily: 'Segoe UI',
    fontWeight: FontWeight.w600,
    wordSpacing: 10,
  );
}

TextStyle kOurAppsResfresWiFi({required double scaleFactor}) {
  return TextStyle(
    color: kOurAppsAppGreyDark,
    fontSize: 14 * scaleFactor,
    fontFamily: 'Segoe UI',
    fontWeight: FontWeight.w600,
    wordSpacing: 10,
  );
}
