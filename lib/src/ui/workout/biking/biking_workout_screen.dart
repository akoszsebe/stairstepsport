import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ludisy/src/ui/workout/biking/biking_workout_controller.dart';
import 'package:ludisy/src/ui/base/base_screen_state.dart';
import 'package:ludisy/src/ui/base/base_view.dart';
import 'package:ludisy/src/util/assets.dart';
import 'package:ludisy/src/util/navigation_module.dart';
import 'package:ludisy/src/util/style/colors.dart';
import 'package:ludisy/src/util/style/theme_provider.dart';
import 'package:ludisy/src/util/ui_utils.dart';
import 'package:ludisy/src/widgets/rounded_button.dart';
import 'package:ludisy/src/widgets/rounded_mini_button.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ludisy/src/widgets/workout_active_container.dart';
import 'package:provider/provider.dart';

class BikingWorkoutScreen extends StatefulWidget {
  BikingWorkoutScreen({Key key}) : super(key: key);
  @override
  _BikingWorkoutScreenState createState() => _BikingWorkoutScreenState();
}

class _BikingWorkoutScreenState
    extends BaseScreenState<BikingWorkoutScreen, BikingWorkoutController> {
  _BikingWorkoutScreenState() : super();

  GoogleMapController _controller;
  bool isMapCreated = false;
  static final LatLng myLocation = LatLng(46.769933, 23.586294);

  @override
  void initState() {
    super.initState();
  }

  final CameraPosition _kGooglePlex = CameraPosition(
    target: myLocation,
    zoom: 12.4746,
  );

  changeMapMode(String themeName) {
    switch (themeName) {
      case "LIGHT":
        getJsonFile("lib/resources/map/map_style_light.json").then(setMapStyle);
        break;
      case "DARK":
        getJsonFile("lib/resources/map/map_style_dark.json").then(setMapStyle);
        break;
      default:
    }
  }

  void setMapStyle(String mapStyle) {
    _controller.setMapStyle(mapStyle);
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (isMapCreated) {
      changeMapMode(themeProvider.themeName);
    }
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: BaseView(
            bacgroundColor: AppColors.instance.primaryWithOcupacity50,
            child: Stack(
              children: <Widget>[
                GoogleMap(
                  mapType: MapType.normal,
                  zoomGesturesEnabled: true,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                    isMapCreated = true;
                    changeMapMode(themeProvider.themeName);
                    setState(() {});
                  },
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 12, bottom: 40, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            RoundedMiniButton(
                              "back",
                              AppSVGAssets.back,
                              () {
                                NavigationModule.pop(context);
                              },
                            ),
                          ],
                        )),
                    Column(
                      children: <Widget>[
                        WorkoutActiveContainer(
                          leftChild: buildIconTextPair(
                              "1:42:25", AppSVGAssets.stopper),
                          centerChild: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                SvgPicture.asset(
                                  AppSVGAssets.speed,
                                  color: AppColors.instance.iconSecundary,
                                  height: 16,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                ),
                                Text(
                                  "32",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.instance.primary),
                                ),
                                Text(
                                  "km/h",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.instance.primary),
                                ),
                                Text(
                                  "Avg.",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.instance.textSecundary),
                                ),
                                RichText(
                                    text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                    text: '10.5',
                                    style: GoogleFonts.montserrat(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            AppColors.instance.textSecundary),
                                  ),
                                  TextSpan(
                                    text: ' km/h',
                                    style: GoogleFonts.montserrat(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w400,
                                        color:
                                            AppColors.instance.textSecundary),
                                  ),
                                ]))
                              ]),
                          rightChild: buildIconTextPair(
                              "7.3 km", AppSVGAssets.distance),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 24),
                            child: RoundedContainer(
                              backgroundColor:
                                  AppColors.instance.containerColor,
                              radius: 32.0,
                              height: 48,
                              width: 160,
                              child: Row(
                                children: <Widget>[
                                  buildIconTextPair(
                                      "425 m", AppSVGAssets.altitude),
                                  buildIconTextPair(
                                      "432 cal", AppSVGAssets.cal)
                                ],
                              ),
                            )),
                        Padding(
                            padding: EdgeInsets.only(bottom: 24, top: 48),
                            child: RoundedButton(
                              "pause",
                              AppSVGAssets.pause,
                              () {},
                            ))
                      ],
                    ),
                  ],
                )
              ],
            )));
  }

  Widget buildIconTextPair(String text, String iconName) {
    return Container(
        width: 80,
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                iconName,
                color: AppColors.instance.iconSecundary,
                height: 17,
              ),
              Padding(
                padding: EdgeInsets.only(top: 2),
              ),
              Text(
                text,
                style: GoogleFonts.montserrat(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.instance.primary),
              ),
            ]));
  }
}