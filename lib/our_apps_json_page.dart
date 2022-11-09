import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'cutom_icon.dart';
import 'our_apps_constants.dart';
import 'our_apps_users.dart';
import 'firebase_options.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:animate_icons/animate_icons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OurAppsJSONII extends StatefulWidget {
  const OurAppsJSONII({Key? key}) : super(key: key);

  @override
  State<OurAppsJSONII> createState() => _OurAppsJSONIIState();
}

class _OurAppsJSONIIState extends State<OurAppsJSONII>
    with TickerProviderStateMixin {
  late AnimationController controller;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  AnimateIconController controllerII = AnimateIconController();
  bool netConnected = false;

  //=====This is teh animation of the floatAction button
  late final AnimationController _floatActionController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 125),
    value: 1.0,
    lowerBound: 0.65,
    upperBound: 1,
  );
//=====This is teh animation of the floatAction button
  late final AnimationController _floatActionControllerPrint =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 125),
    value: 1.0,
    lowerBound: 0.65,
    upperBound: 1,
  );

  @override
  void initState() {
    super.initState();
    initConnectivity();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    controller.forward();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
// Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status');
      return;
    }
    if (result == ConnectivityResult.none) {
      netConnected = false;
    } else {
      netConnected = true;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.gv
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

//====This will be used to expand all expandedTile
  Key keyTile = UniqueKey();
  bool isExpanded = false;
  bool expandedText = false;
//=====This is to expand the tiles
  void expandTile() {
    setState(() {
      isExpanded = true;
      keyTile = UniqueKey();
    });
  }

//======This is to shrink the tiles
  void shrinkTile() {
    setState(() {
      isExpanded = false;
      keyTile = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

//==== This is to determine the shortest side of the device to determine if iPad/Tablet or mobile phone
//==== 552 was selected based on my tablet Lenovo TAB 2 A7, physical number were extracted from the App in debug mode
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 552;
//===== These are the sony xperia screen size
    double sonyXRWidth = 360;
    double sonyXRHeight = 592;
//==== This is to generat scale factor for any mobile device based on the screen size of the sony xperia
    double scaleFactorScreenMobile = (MediaQuery.of(context).size.width +
            MediaQuery.of(context).size.height) /
        (sonyXRWidth + sonyXRHeight);
//===== This to identify the size of the iPad to make responsive fonts
    double iPAD4thGenWidth = 1180;
    double iPAD4thGenHeight = 820;
//===== This is the Scale Factor for the screen
    double scaleFactorScreenTablets = (MediaQuery.of(context).size.width +
            MediaQuery.of(context).size.height) /
        (iPAD4thGenWidth + iPAD4thGenHeight);

//====== This to force the mobile device to be in Portrait mode only ========
//===========================================================================
    if (useMobileLayout) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }

//==== Scroll controller for shift the list to the beginning (go to Top)
    final ScrollController scrollControllerUp = ScrollController();

//===== Toast Massage if the link is not updated till the time of application issue
    appURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw Fluttertoast.showToast(
          msg:
              "The App Link was not available at the time of publishing this App...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      }
    }

//====== this is the AlertDialog for Android Operation system ==================
    void appLinkAlertAndroidFinal(
        String urlLink, String storeName, String nameApp, String storeLogo) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: Center(child: Text('$nameApp link')),
              content: Text(
                'This will take you to location of $nameApp in $storeName,\n\n\nTo cancel press any place on the screen',
                textAlign: TextAlign.justify,
              ),
              actions: [
                CupertinoDialogAction(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.network(storeLogo,
                            width: 50 * scaleFactorScreenMobile,
                            height: 50 * scaleFactorScreenMobile),
                        const SizedBox(width: 20),
                        Text('Go to $storeName',
                            style: TextStyle(
                                fontSize: 10 * scaleFactorScreenMobile)),
                      ],
                    ),
                  ),
                  onPressed: () {
                    appURL(urlLink);
                    Navigator.of(context, rootNavigator: true).pop("Discard");
                  },
                ),
              ],
            );
          });
    }

//=====This is the application cards for mobile devices
    Widget buildAppsMobile(User user) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              Container(
                width: 0.90 * MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: kOurAppsMainScreenCards,
                  border: Border.all(color: Colors.transparent),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: -150,
                      left: -150,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.transparent),
                              gradient: RadialGradient(
                                colors: [
                                  Colors.red.withOpacity(0.2),
                                  Colors.white.withOpacity(0.1),
                                ],
                              )),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -150,
                      right: -150,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.transparent),
                              gradient: RadialGradient(
                                colors: [
                                  Colors.green.withOpacity(0.2),
                                  Colors.white.withOpacity(0.1),
                                ],
                              )),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, bottom: 0, top: 8.0),
                          child: SizedBox(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: Image.network(user.imageName),
                                      ),
                                      SizedBox(
                                          width: 5 * scaleFactorScreenMobile),
                                      Flexible(
                                        child: Text(
                                          user.appName,
                                          maxLines: 2,
                                          // overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize:
                                                16 * scaleFactorScreenMobile,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Segoe UI',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
//====================== This is to add an ExpansionTile for the Application description
                                  useMobileLayout
                                      ? Theme(
                                          data: Theme.of(context).copyWith(
                                              dividerColor: Colors.transparent),
                                          child: ExpansionTile(
                                            key: keyTile,
                                            initiallyExpanded: isExpanded,
                                            title: Text(
                                              '${user.appName} description',
                                              style: TextStyle(
                                                  fontSize: 14 *
                                                      scaleFactorScreenMobile),
                                            ),
                                            children: [
                                              Text(
                                                user.description,
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                    fontSize: 14 *
                                                        scaleFactorScreenMobile),
                                              )
                                            ],
                                          ),
                                        )
                                      : SizedBox(
                                          height: 0.78 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .height,
                                          width: 0.9 *
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            user.description,
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                                fontSize: 16 *
                                                    scaleFactorScreenMobile),
                                          ),
                                        ),
                                  const SizedBox(height: 5),
//==========================This to show the availability of the App in Android & IOS store
                                  Platform.isAndroid
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
//===========================To Add Android logo & link to App
                                            Expanded(
                                              flex: 1,
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () {
                                                    appLinkAlertAndroidFinal(
                                                        user.andLink,
                                                        'Play Store',
                                                        user.appName,
                                                        user.playStoreLogoLink);
                                                  },
                                                  splashColor: kOurAppsAppBlue,
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.network(
                                                        user.playStoreLogoLink,
                                                        width: 25 *
                                                            scaleFactorScreenMobile,
                                                        height: 25 *
                                                            scaleFactorScreenMobile,
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            user.androidAvailable,
                                                            style: TextStyle(
                                                              color:
                                                                  kOurAppsCardTextColor,
                                                              fontSize: 12 *
                                                                  scaleFactorScreenMobile,
                                                              fontFamily:
                                                                  'Segoe UI',
                                                            ),
                                                          ),
                                                          Text(
                                                            user.paidFree,
                                                            style: TextStyle(
                                                              color:
                                                                  kOurAppsCardTextColor,
                                                              fontSize: 14 *
                                                                  scaleFactorScreenMobile,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontFamily:
                                                                  'Segoe UI',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
//===========================To Add IOS logo & link to App
                                            Expanded(
                                              flex: 1,
                                              child: user.iosAvailable != ""
                                                  ? Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () {
                                                          appLinkAlertAndroidFinal(
                                                              user.iosLink,
                                                              'App Store',
                                                              user.appName,
                                                              user.appStoreLogoLink);
                                                        },
                                                        splashColor:
                                                            kOurAppsAppBlue,
                                                        child: Row(
                                                          children: [
                                                            SvgPicture.network(
                                                              user.appStoreLogoLink,
                                                              width: 25 *
                                                                  scaleFactorScreenMobile,
                                                              height: 25 *
                                                                  scaleFactorScreenMobile,
                                                            ),
                                                            const SizedBox(
                                                                width: 10),
                                                            //==== IOS App Link
                                                            Column(
                                                              children: [
                                                                Text(
                                                                  user.iosAvailable,
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        kOurAppsCardTextColor,
                                                                    fontSize: 12 *
                                                                        scaleFactorScreenMobile,
                                                                    fontFamily:
                                                                        'Segoe UI',
                                                                  ),
                                                                ),
                                                                Text(
                                                                  user.paidFreeIOS,
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        kOurAppsCardTextColor,
                                                                    fontSize: 14 *
                                                                        scaleFactorScreenMobile,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontFamily:
                                                                        'Segoe UI',
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox.shrink(),
                                            ),
//===========================This is for Huawei store
                                            Expanded(
                                              flex: 1,
                                              child: user.huaweiStoreLogoLink !=
                                                      ""
                                                  ? Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () {
                                                          appLinkAlertAndroidFinal(
                                                              user.huaweiAppLink,
                                                              'Huawei Store',
                                                              user.appName,
                                                              user.huaweiStoreLogoLink);
                                                        },
                                                        splashColor:
                                                            kOurAppsAppBlue,
                                                        child: Row(
                                                          children: [
                                                            SvgPicture.network(
                                                              user.huaweiStoreLogoLink,
                                                              width: 25 *
                                                                  scaleFactorScreenMobile,
                                                              height: 25 *
                                                                  scaleFactorScreenMobile,
                                                            ),
                                                            const SizedBox(
                                                                width: 10),
                                                            Column(
                                                              children: [
                                                                Text(
                                                                  user.huaweiAvailable,
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        kOurAppsCardTextColor,
                                                                    fontSize: 12 *
                                                                        scaleFactorScreenMobile,
                                                                    fontFamily:
                                                                        'Segoe UI',
                                                                  ),
                                                                ),
                                                                Text(
                                                                  user.huaweiPaid,
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        kOurAppsCardTextColor,
                                                                    fontSize: 14 *
                                                                        scaleFactorScreenMobile,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontFamily:
                                                                        'Segoe UI',
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox.shrink(),
                                            ),
                                          ],
                                        )
//===========================This is for IOS devices only to add the link of the Apps
                                      : Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              appLinkAlertAndroidFinal(
                                                  user.iosLink,
                                                  'App Store',
                                                  user.appName,
                                                  user.appStoreLogoLink);
                                            },
                                            splashColor: kOurAppsAppBlue,
                                            child: Row(
                                              children: [
                                                SvgPicture.network(
                                                  user.appStoreLogoLink,
                                                  width: 25 *
                                                      scaleFactorScreenMobile,
                                                  height: 25 *
                                                      scaleFactorScreenMobile,
                                                ),
                                                const SizedBox(width: 10),
                                                //==== IOS App Link
                                                Column(
                                                  children: [
                                                    Text(
                                                      user.iosAvailable,
                                                      style: TextStyle(
                                                        color:
                                                            kOurAppsCardTextColor,
                                                        fontSize: 12 *
                                                            scaleFactorScreenMobile,
                                                        fontFamily: 'Segoe UI',
                                                      ),
                                                    ),
                                                    Text(
                                                      user.paidFreeIOS,
                                                      style: TextStyle(
                                                        color:
                                                            kOurAppsCardTextColor,
                                                        fontSize: 14 *
                                                            scaleFactorScreenMobile,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily: 'Segoe UI',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

//=====This is the application cards for iPad/Tablet devices Landscape mode
    Widget buildAppsLandscape(User user) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: kOurAppsMainScreenCards,
                  border: Border.all(color: Colors.transparent),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: -150,
                      left: -150,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.transparent),
                              gradient: RadialGradient(
                                colors: [
                                  Colors.red.withOpacity(0.2),
                                  Colors.white.withOpacity(0.1),
                                ],
                              )),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -150,
                      right: -150,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.transparent),
                              gradient: RadialGradient(
                                colors: [
                                  Colors.green.withOpacity(0.2),
                                  Colors.white.withOpacity(0.1),
                                ],
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  controller: scrollControllerUp,
                  child: Column(
                    children: [
                      SizedBox(
                        child: SingleChildScrollView(
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.network(
                                    user.imageName,
                                    width: 100 * scaleFactorScreenTablets,
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      user.appName,
                                      maxLines: 2,
                                      // overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 24 * scaleFactorScreenTablets,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Segoe UI',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30 * scaleFactorScreenTablets),
                              Platform.isAndroid
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
//===========================To Add Android logo & link to App
                                        Expanded(
                                          flex: 1,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                appLinkAlertAndroidFinal(
                                                    user.andLink,
                                                    'Play Store',
                                                    user.appName,
                                                    user.playStoreLogoLink);
                                              },
                                              splashColor: kOurAppsAppBlue,
                                              child: Row(
                                                children: [
                                                  SvgPicture.network(
                                                    user.playStoreLogoLink,
                                                    width: 35 *
                                                        scaleFactorScreenTablets,
                                                    height: 35 *
                                                        scaleFactorScreenTablets,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        user.androidAvailable,
                                                        style: TextStyle(
                                                          color:
                                                              kOurAppsCardTextColor,
                                                          fontSize: 20 *
                                                              scaleFactorScreenTablets,
                                                          fontFamily:
                                                              'Segoe UI',
                                                        ),
                                                      ),
                                                      Text(
                                                        user.paidFree,
                                                        style: TextStyle(
                                                          color:
                                                              kOurAppsCardTextColor,
                                                          fontSize: 20 *
                                                              scaleFactorScreenTablets,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily:
                                                              'Segoe UI',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
//===========================To Add IOS logo & link to App
                                        Expanded(
                                          flex: 1,
                                          child: user.iosAvailable != ""
                                              ? Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      appLinkAlertAndroidFinal(
                                                          user.iosLink,
                                                          'App Store',
                                                          user.appName,
                                                          user.appStoreLogoLink);
                                                    },
                                                    splashColor:
                                                        kOurAppsAppBlue,
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.network(
                                                          user.appStoreLogoLink,
                                                          width: 35 *
                                                              scaleFactorScreenTablets,
                                                          height: 35 *
                                                              scaleFactorScreenTablets,
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        //==== IOS App Link
                                                        Column(
                                                          children: [
                                                            Text(
                                                              user.iosAvailable,
                                                              style: TextStyle(
                                                                color:
                                                                    kOurAppsCardTextColor,
                                                                fontSize: 20 *
                                                                    scaleFactorScreenTablets,
                                                                fontFamily:
                                                                    'Segoe UI',
                                                              ),
                                                            ),
                                                            Text(
                                                              user.paidFreeIOS,
                                                              style: TextStyle(
                                                                color:
                                                                    kOurAppsCardTextColor,
                                                                fontSize: 20 *
                                                                    scaleFactorScreenTablets,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontFamily:
                                                                    'Segoe UI',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                        ),
//===========================This is for Huawei store
                                        Expanded(
                                          flex: 1,
                                          child: user.huaweiStoreLogoLink != ""
                                              ? Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      appLinkAlertAndroidFinal(
                                                          user.huaweiAppLink,
                                                          'Huawei Store',
                                                          user.appName,
                                                          user.huaweiStoreLogoLink);
                                                    },
                                                    splashColor:
                                                        kOurAppsAppBlue,
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.network(
                                                          user.huaweiStoreLogoLink,
                                                          width: 35 *
                                                              scaleFactorScreenTablets,
                                                          height: 35 *
                                                              scaleFactorScreenTablets,
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Column(
                                                          children: [
                                                            Text(
                                                              user.huaweiAvailable,
                                                              style: TextStyle(
                                                                color:
                                                                    kOurAppsCardTextColor,
                                                                fontSize: 20 *
                                                                    scaleFactorScreenTablets,
                                                                fontFamily:
                                                                    'Segoe UI',
                                                              ),
                                                            ),
                                                            Text(
                                                              user.huaweiPaid,
                                                              style: TextStyle(
                                                                color:
                                                                    kOurAppsCardTextColor,
                                                                fontSize: 20 *
                                                                    scaleFactorScreenTablets,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontFamily:
                                                                    'Segoe UI',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                        ),
                                      ],
                                    )
//===========================This is for IOS devices only to add the link of the Apps
                                  : Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          appLinkAlertAndroidFinal(
                                              user.iosLink,
                                              'App Store',
                                              user.appName,
                                              user.appStoreLogoLink);
                                        },
                                        splashColor: kOurAppsAppBlue,
                                        child: Row(
                                          children: [
                                            SvgPicture.network(
                                              user.appStoreLogoLink,
                                              width:
                                                  35 * scaleFactorScreenTablets,
                                              height:
                                                  35 * scaleFactorScreenTablets,
                                            ),
                                            const SizedBox(width: 10),
                                            //==== IOS App Link
                                            Column(
                                              children: [
                                                Text(
                                                  user.iosAvailable,
                                                  style: TextStyle(
                                                    color:
                                                        kOurAppsCardTextColor,
                                                    fontSize: 20 *
                                                        scaleFactorScreenTablets,
                                                    fontFamily: 'Segoe UI',
                                                  ),
                                                ),
                                                Text(
                                                  user.paidFreeIOS,
                                                  style: TextStyle(
                                                    color:
                                                        kOurAppsCardTextColor,
                                                    fontSize: 20 *
                                                        scaleFactorScreenTablets,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'Segoe UI',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              SizedBox(height: 30 * scaleFactorScreenTablets),
                              Text(
                                user.description,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontSize: 21 * scaleFactorScreenTablets),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

//=======This is the arrangement of the widget for tablet Portrait mode
    Widget buildAppsPortrait(User user) {
//=====This is the application cards for iPad/Tablet devices portrait mode
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: kOurAppsMainScreenCards,
                  border: Border.all(color: Colors.transparent),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: -150,
                      left: -150,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.transparent),
                              gradient: RadialGradient(
                                colors: [
                                  Colors.red.withOpacity(0.2),
                                  Colors.white.withOpacity(0.1),
                                ],
                              )),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -150,
                      right: -150,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.transparent),
                              gradient: RadialGradient(
                                colors: [
                                  Colors.green.withOpacity(0.2),
                                  Colors.white.withOpacity(0.1),
                                ],
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                controller: scrollControllerUp,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 0, top: 8.0),
                      child: SizedBox(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.network(
                                  user.imageName,
                                  width: 100 * scaleFactorScreenTablets,
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    user.appName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 24 * scaleFactorScreenTablets,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Segoe UI',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30 * scaleFactorScreenTablets),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
//===========================To Add Android logo & link to App
                                Platform.isAndroid
                                    ? Expanded(
                                        flex: 1,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              appLinkAlertAndroidFinal(
                                                  user.andLink,
                                                  'Play Store',
                                                  user.appName,
                                                  user.playStoreLogoLink);
                                            },
                                            splashColor: kOurAppsAppBlue,
                                            child: Column(
                                              children: [
                                                SvgPicture.network(
                                                  user.playStoreLogoLink,
                                                  width: 30 *
                                                      scaleFactorScreenTablets,
                                                  height: 30 *
                                                      scaleFactorScreenTablets,
                                                ),
                                                const SizedBox(height: 10),
                                                Column(
                                                  children: [
                                                    Text(
                                                      user.androidAvailable,
                                                      style: TextStyle(
                                                        color:
                                                            kOurAppsCardTextColor,
                                                        fontSize: 20 *
                                                            scaleFactorScreenTablets,
                                                        fontFamily: 'Segoe UI',
                                                      ),
                                                    ),
                                                    Text(
                                                      user.paidFree,
                                                      style: TextStyle(
                                                        color:
                                                            kOurAppsCardTextColor,
                                                        fontSize: 20 *
                                                            scaleFactorScreenTablets,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily: 'Segoe UI',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
//===========================To Add IOS logo & link to App
                                Expanded(
                                  flex: 1,
                                  child: user.iosAvailable != ""
                                      ? Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              appLinkAlertAndroidFinal(
                                                  user.iosLink,
                                                  'App Store',
                                                  user.appName,
                                                  user.appStoreLogoLink);
                                            },
                                            splashColor: kOurAppsAppBlue,
                                            child: Column(
                                              children: [
                                                SvgPicture.network(
                                                  user.appStoreLogoLink,
                                                  width: 30 *
                                                      scaleFactorScreenTablets,
                                                  height: 30 *
                                                      scaleFactorScreenTablets,
                                                ),
                                                const SizedBox(height: 10),
                                                //==== IOS App Link
                                                Column(
                                                  children: [
                                                    Text(
                                                      user.iosAvailable,
                                                      style: TextStyle(
                                                        color:
                                                            kOurAppsCardTextColor,
                                                        fontSize: 20 *
                                                            scaleFactorScreenTablets,
                                                        fontFamily: 'Segoe UI',
                                                      ),
                                                    ),
                                                    Text(
                                                      user.paidFreeIOS,
                                                      style: TextStyle(
                                                        color:
                                                            kOurAppsCardTextColor,
                                                        fontSize: 20 *
                                                            scaleFactorScreenTablets,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily: 'Segoe UI',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
//===========================This is for Huawei store
                                Platform.isAndroid
                                    ? Expanded(
                                        flex: 1,
                                        child: user.huaweiStoreLogoLink != ""
                                            ? Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () {
                                                    appLinkAlertAndroidFinal(
                                                        user.huaweiAppLink,
                                                        'Huawei Store',
                                                        user.appName,
                                                        user.huaweiStoreLogoLink);
                                                  },
                                                  splashColor: kOurAppsAppBlue,
                                                  child: Column(
                                                    children: [
                                                      SvgPicture.network(
                                                        user.huaweiStoreLogoLink,
                                                        width: 30 *
                                                            scaleFactorScreenTablets,
                                                        height: 30 *
                                                            scaleFactorScreenTablets,
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            user.huaweiAvailable,
                                                            style: TextStyle(
                                                              color:
                                                                  kOurAppsCardTextColor,
                                                              fontSize: 20 *
                                                                  scaleFactorScreenTablets,
                                                              fontFamily:
                                                                  'Segoe UI',
                                                            ),
                                                          ),
                                                          Text(
                                                            user.huaweiPaid,
                                                            style: TextStyle(
                                                              color:
                                                                  kOurAppsCardTextColor,
                                                              fontSize: 20 *
                                                                  scaleFactorScreenTablets,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontFamily:
                                                                  'Segoe UI',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                            SizedBox(height: 30 * scaleFactorScreenTablets),
                            Text(
                              user.description,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 18 * scaleFactorScreenTablets),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

//=======This will be used for the tablet portrait mode
    Widget tabletPortrait(List<User> users) {
      return GridView(
        controller: scrollControllerUp,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1 / 1.45,
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        children: users.map(buildAppsPortrait).toList(),
      );
    }

//=======This will be used for the tablet portrait mode
    Widget tabletLandscape(List<User> users) {
      return GridView(
        controller: scrollControllerUp,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1 / 0.85,
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        children: users.map(buildAppsLandscape).toList(),
      );
    }

//======This will be used to show the maintenance tags when un-able to connect to JASON cloud
    Widget maintenanceNote() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Under Maintenance/Update",
                textAlign: TextAlign.justify,
                style: kOurAppsWifiCheck(
                  scaleFactor: (useMobileLayout
                      ? scaleFactorScreenMobile
                      : scaleFactorScreenTablets),
                ),
              ),
              OrientationBuilder(
                builder: (context, orientation) =>
                    orientation == Orientation.landscape
                        ? Image.asset(
                            'images/under_main_small.png',
                            width: 0.90 * MediaQuery.of(context).size.width,
                          )
                        : Image.asset(
                            'images/under_main_small.png',
                            width: 0.5 * MediaQuery.of(context).size.width,
                            height: 0.5 * MediaQuery.of(context).size.height,
                          ),
              ),
              Text(
                "Sorry we are updating the Data base or doing maintenance, try again after a while",
                textAlign: TextAlign.justify,
                style: kOurAppsCanNotFind(
                  scaleFactor: (useMobileLayout
                      ? scaleFactorScreenMobile
                      : scaleFactorScreenTablets),
                ),
              ),
              Container(
                width: orientation == Orientation.portrait
                    ? 0.9 * MediaQuery.of(context).size.width
                    : 0.3 * MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green),
                ),
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OurAppsJSONII(),
                      ),
                    ).then((value) => null);
                  },
                  icon: Icon(
                    Icons.refresh,
                    color: kOurAppsAppGreyDark,
                    size: 25 *
                        (useMobileLayout
                            ? scaleFactorScreenMobile
                            : scaleFactorScreenTablets),
                  ),
                  label: Text(
                    'Refresh Page',
                    style: kOurAppsResfresWiFi(
                      scaleFactor: (useMobileLayout
                          ? scaleFactorScreenMobile
                          : scaleFactorScreenTablets),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Our Apps',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          useMobileLayout
              ? AnimateIcons(
                  startIcon: MyIcons.max,
                  endIcon: MyIcons.min,
                  controller: controllerII,
                  size: 25.0,
                  onStartIconPress: () {
                    print("Clicked on Add Icon");
                    expandTile();
                    return true;
                  },
                  onEndIconPress: () {
                    print("Clicked on Close Icon");
                    print('yyyyyyy$_connectionStatus');
                    shrinkTile();
                    return true;
                  },
                  duration: const Duration(milliseconds: 500),
                  startIconColor: kOurAppsAppGreyDark,
                  endIconColor: kOurAppsAppGreyDark,
                  clockwise: false,
                )
              : const SizedBox.shrink(),
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
          child: netConnected
              ? Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: StreamBuilder<List<User>>(
                          stream: readUsers(),
                          builder:
                              (context, AsyncSnapshot<List<User>> snapshot) {
                            if (snapshot.hasError) {
                              return maintenanceNote();
                            } else if (snapshot.hasData) {
                              final users = snapshot.data!;
                              return useMobileLayout
                                  ? ListView(
                                      controller: scrollControllerUp,
                                      children:
                                          users.map(buildAppsMobile).toList(),
                                    )
                                  : OrientationBuilder(
                                      builder: (context, orientation) =>
                                          orientation == Orientation.landscape
                                              ? tabletLandscape(users)
                                              : tabletPortrait(users));
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 16),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Can't connect to data!!",
                          textAlign: TextAlign.justify,
                          style: kOurAppsWifiCheck(
                            scaleFactor: (useMobileLayout
                                ? scaleFactorScreenMobile
                                : scaleFactorScreenTablets),
                          ),
                        ),
                        OrientationBuilder(
                          builder: (context, orientation) => orientation ==
                                  Orientation.landscape
                              ? Image.asset(
                                  'images/wifi_connection.png',
                                  width:
                                      0.90 * MediaQuery.of(context).size.width,
                                )
                              : Image.asset(
                                  'images/wifi_connection.png',
                                  width:
                                      0.5 * MediaQuery.of(context).size.width,
                                  height:
                                      0.5 * MediaQuery.of(context).size.height,
                                ),
                        ),
                        Text(
                          "Sorry we are not able to reach the data, please check you internet connection",
                          textAlign: TextAlign.justify,
                          style: kOurAppsCanNotFind(
                            scaleFactor: (useMobileLayout
                                ? scaleFactorScreenMobile
                                : scaleFactorScreenTablets),
                          ),
                        ),
                        Container(
                          width: orientation == Orientation.portrait
                              ? 0.9 * MediaQuery.of(context).size.width
                              : 0.3 * MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.green),
                          ),
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OurAppsJSONII(),
                                ),
                              ).then((value) => null);
                            },
                            icon: Icon(
                              Icons.refresh,
                              color: kOurAppsAppGreyDark,
                              size: 25 *
                                  (useMobileLayout
                                      ? scaleFactorScreenMobile
                                      : scaleFactorScreenTablets),
                            ),
                            label: Text(
                              'Refresh Page',
                              style: kOurAppsResfresWiFi(
                                scaleFactor: (useMobileLayout
                                    ? scaleFactorScreenMobile
                                    : scaleFactorScreenTablets),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _floatActionController,
        child: FloatingActionButton(
          backgroundColor: Colors.blueGrey,
          elevation: 8,
          onPressed: () {
            _tap();
            Future.delayed(const Duration(milliseconds: 100))
                .then((value) => setState(() {
                      scrollControllerUp.jumpTo(0.0);
                    }));
          },
          child: const Icon(
            Icons.keyboard_arrow_up,
            size: 40,
          ),
        ),
      ),
    );
  }

  //=======This tap to make action on the floating action button onTap (to jump to 0.0)
  void _tap() {
    _floatActionController.reverse().then((value) {
      _floatActionController.forward();
    });
  }

//=====This will be used to stream the data of the Apps from the fireBase auth
  Stream<List<User>> readUsers() => FirebaseFirestore.instance
      .collection('Users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

  Widget buildUsers(User user) => ListTile(
        title: Text(
          'Application Name: ${user.appName}',
          style: const TextStyle(fontSize: 14, color: Colors.red),
        ),
      );
}
