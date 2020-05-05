import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ludisy/src/ui/base/base_screen_state.dart';
import 'package:ludisy/src/ui/base/base_view.dart';
import 'package:ludisy/src/ui/settings/settings_controller.dart';
import 'package:ludisy/src/util/assets.dart';
import 'package:ludisy/src/util/navigation_module.dart';
import 'package:ludisy/src/util/style/colors.dart';
import 'package:ludisy/src/widgets/quickinfobar.dart';
import 'package:ludisy/src/widgets/rounded_mini_button.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState
    extends BaseScreenState<SettingsScreen, SettingsController> {
  @override
  void initState() {
    super.initState();
    con.init();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 12, top: 20, bottom: 40, right: 16),
            child: QuickInfoBar(
              con.userData.displayName != null
                  ? con.userData.displayName.split(" ")[0]
                  : "",
              con.userData.photoUrl,
              canGoBack: true,
              onProfilePressed: () =>
                  NavigationModule.navigateToProfileScreen(context),
              hostoryVisible: true,
              onHistoryPressed: () =>
                  NavigationModule.navigateAndReplaceToHistoryScreen(context),
            ),
          ),
          Expanded(child: Hero(tag: "settings", child: buildBody()))
        ]));
  }

  Widget buildBody() {
    return Material(
        type: MaterialType.transparency,
        child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: buildButton("Delete all data", AppColors.red, () {})),
          Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: buildButton("Source code", AppColors.textBlack,
                  () => con.launchURL("https://github.com/akoszsebe/ludisy"))),
          Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: buildButton(
                  "Contact the developer",
                  AppColors.textBlack,
                  () => con.launchURL(
                      "https://www.linkedin.com/in/zsebe-akos-b581b9139"))),
          Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Container(
                height: 180,
                width: double.infinity,
                padding:
                    EdgeInsets.only(top: 16, left: 38, right: 38, bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.all(const Radius.circular(32.0))),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Support the development",
                      style: GoogleFonts.montserrat(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textBlack),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        buildInAppPourchaseButton(
                            "Water", "0.99", AppSVGAssets.water, 0),
                        buildInAppPourchaseButton(
                            "Coffee", "1.99", AppSVGAssets.coffee, 1),
                        buildInAppPourchaseButton(
                            "Lunch", "2.99", AppSVGAssets.lunch, 2)
                      ],
                    )
                  ],
                ),
              ))
        ])));
  }

  Widget buildButton(String title, Color color, VoidCallback onTap) {
    return Material(
        borderRadius: BorderRadius.all(const Radius.circular(24.0)),
        child: InkWell(
            onTap: onTap,
            customBorder: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(24.0),
            ),
            child: Container(
                height: 48,
                width: double.infinity,
                child: Center(
                  child: Text(
                    title,
                    style: GoogleFonts.montserrat(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: color),
                  ),
                ))));
  }

  Widget buildInAppPourchaseButton(
      String title, String cost, String imageName, int index) {
    return MaterialButton(
      height: 105,
      minWidth: 64,
      padding: EdgeInsets.all(0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 43,
              width: 43,
              child: SvgPicture.asset(
                imageName,
                width: 43,
                fit: BoxFit.scaleDown,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
            ),
            Text(
              title,
              style: GoogleFonts.montserrat(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textGray),
            ),
            Text(
              "$cost \$",
              style: GoogleFonts.montserrat(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textGray),
            ),
          ]),
      onPressed: () {
        con.pay(index);
      },
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
    );
  }
}
