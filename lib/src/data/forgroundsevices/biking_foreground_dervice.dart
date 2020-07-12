import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:ludisy/src/data/forgroundsevices/base_forground_service.dart';
import 'package:ludisy/src/data/model/workout_model.dart';

class BikingForegroundService extends BaseForegroundService{

  static String channelName = "biking";

  static Future<List<BikingObj>> getSavedData() async {
    try {
      var result = await platform.invokeMethod('biking/getdata');
      if (result != null) {
        return List<BikingObj>.from(jsonDecode(result)
            .map((i) => BikingObj.fromJson(i.cast<String, dynamic>()))
            .toList());
      }
    } on Exception catch (e) {
      print("-- mmak ---" + e.toString());
    }
    return [];
  }

  static Future<void> startFGS() async {
    try {
      await platform.invokeMethod('$channelName/start');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  static Future<void> stopFGS() async {
    try {
      await platform.invokeMethod('$channelName/stop');
    } on PlatformException catch (e) {
      print("-- mmak ---" + e.details);
    }
  }

  static Future<bool> removeSavedData() async {
    try {
      var result = await platform.invokeMethod('$channelName/removedata');
      return result;
    } on Exception catch (e) {
      print("-- mmak ---" + e.toString());
    }
    return false;
  }
}