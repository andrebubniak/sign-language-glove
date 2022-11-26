import 'package:flutter/material.dart';
import 'sensor_data.dart';


/// Notifier that is used as wrap for Home Widget
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