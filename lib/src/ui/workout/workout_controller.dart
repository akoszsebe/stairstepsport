import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:pedometer/pedometer.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:stairstepsport/src/data/model/user_model.dart';
import 'package:stairstepsport/src/data/model/workout_model.dart';
import 'package:stairstepsport/src/data/persitance/database.dart';
import 'package:stairstepsport/src/util/calory_calculator.dart';
import 'package:stairstepsport/src/util/navigation_module.dart';
import 'package:stairstepsport/src/util/shared_pref.dart';

class WorkOutController extends ControllerMVC {
  factory WorkOutController(appDatabase) =>
      _this ??= WorkOutController._(appDatabase);
  static WorkOutController _this;
  WorkOutController._(this._appDatabase);
  final AppDatabase _appDatabase;

  int stepCountValue = 0;
  double calCounterValue = 0;
  bool isWorkoutStarted = false;
  int targetSteps = 0;
  UserModel userData = UserModel();
  double percentageValue = 0;
  int durationSeconds = 0;

  Pedometer _pedometer;
  StreamSubscription<int> _subscription;
  int _offset = 0;
  Timer _timer;

  Future<void> initPlatformState() async {
    userData = await SharedPrefs.getUserData();
    _pedometer = Pedometer();
    _offset = await _pedometer.pedometerStream.first;
    print("start from = $_offset");
    startListening();
  }

  Future<void> startListening() async {
    startTimer();
    _subscription = _pedometer.pedometerStream.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: true);
    isWorkoutStarted = true;
    refresh();
    // mock();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      durationSeconds++;
      refresh();
    });
  }

  Future<void> mock() async {
    print("target = $targetSteps");
    for (var i = 0; i < targetSteps + 10; i += 10) {
      calCounterValue = CaloriCalculator.calculateEnergyExpenditure(
          userData.height.toDouble(),
          DateTime(userData.bithDate),
          userData.weight.toDouble(),
          userData.gender == "Male" ? 0 : 1,
          durationSeconds,
          stepCountValue,
          0.4);
      stepCountValue = i;
      percentageValue = stepCountValue / targetSteps;
      if (percentageValue > 1) {
        percentageValue = 1;
      }
      if (percentageValue == 1) {
        FlutterRingtonePlayer.playNotification();
        doneWorkout((steps, stepsPlaned, cal, duration) {
          NavigationModule.navigateToWorkoutDoneScreen(
              context, steps, stepsPlaned, cal, duration);
        });
      }
      refresh();
      if (!isWorkoutStarted) {
        break;
      }
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  void stopListening() {
    isWorkoutStarted = false;
    if (_subscription != null) {
      _subscription.cancel();
    }
    if (_timer != null) {
      _timer.cancel();
    }
    refresh();
  }

  void _onData(int stepCountValue) async {
    print("OnData pedometer tracking ${stepCountValue - _offset}");
    calCounterValue = CaloriCalculator.calculateEnergyExpenditure(
        userData.height.toDouble(),
        DateTime(userData.bithDate),
        userData.weight.toDouble(),
        userData.gender == "Male" ? 0 : 1,
        durationSeconds,
        stepCountValue,
        0.4);
    this.stepCountValue = stepCountValue - _offset;
    percentageValue = this.stepCountValue / targetSteps;
    if (percentageValue > 1) {
      percentageValue = 1;
    }
    if (percentageValue == 1) {
      FlutterRingtonePlayer.playNotification();
      doneWorkout((steps, stepsPlaned, cal, duration) {
        NavigationModule.navigateToWorkoutDoneScreen(
            context, steps, stepsPlaned, cal, duration);
      });
    }
    refresh();
  }

  void _onDone() => print("Finished pedometer tracking");

  void _onError(error) => print("Flutter Pedometer Error: $error");

  void setupTargetSteps(int stepPlan) {
    targetSteps = stepPlan;
    durationSeconds = 0;
    percentageValue = 0;
    stepCountValue = 0;
    calCounterValue = 0;
  }

  void replanWorkOut(VoidCallback callback) {
    stopListening();
    durationSeconds = 0;
    stepCountValue = 0;
    calCounterValue = 0;
    callback();
  }

  Future<void> doneWorkout(Function(int, int, double, int) callback) async {
    isWorkoutStarted = false;
    if (_subscription != null) {
      _subscription.cancel();
    }
    if (_timer != null) {
      _timer.cancel();
    }

    await _appDatabase.workoutDao.insertWorkOut(WorkOut(
        null,
        stepCountValue,
        calCounterValue,
        durationSeconds,
        DateTime.now().millisecondsSinceEpoch));
    callback(stepCountValue, targetSteps, calCounterValue, durationSeconds);
  }
}
