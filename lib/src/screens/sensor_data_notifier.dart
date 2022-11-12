import 'package:flutter/material.dart';
import 'package:luva/src/models/sensor_data.dart';

class SensorDataNotifier extends InheritedNotifier<SensorData>
{
  const SensorDataNotifier({super.key, required SensorData notifier, required Widget child}) : super(notifier: notifier, child: child);

  static SensorData of(BuildContext context)
  {
    SensorData? data = context.dependOnInheritedWidgetOfExactType<SensorDataNotifier>()?.notifier;
    if(data == null)
    {
      throw Exception("Sensor Data Not Found");
    }
    return data;
  }
}