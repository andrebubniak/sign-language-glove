import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ml_algo/ml_algo.dart';
import 'package:ml_dataframe/ml_dataframe.dart';

import 'bluetooth.dart';
import '../models/models.dart';

import 'package:console_flutter/console_flutter.dart' as flutter_console;


/// Class that holds all the important data as well as the translation logic
class SensorData extends ChangeNotifier
{
  late final BluetoothConnectionHandler _btHandler;
  BluetoothConnectionState get currentBluetoothConnectionState => _btHandler.currentBluetoothConnectionState;

  final Device device;
  Language? _currentLanguage;
  Language? get currentLanguage => _currentLanguage;
  set currentLanguage(Language? newLanguage)
  {
    _currentLanguage = newLanguage;
    _translationSetup();
    notifyListeners();
  }

  int _flex1 = 0;
  int _flex2 = 0;
  int _flex3 = 0;
  int _flex4 = 0;
  int _flex5 = 0;
  double _mpuAccX = 0;
  double _mpuAccY = 0;
  double _mpuAccZ = 0;

  int get flex1 => _flex1;
  int get flex2 => _flex2;
  int get flex3 => _flex3;
  int get flex4 => _flex4;
  int get flex5 => _flex5;
  double get mpuAccX => _mpuAccX;
  double get mpuAccY => _mpuAccY;
  double get mpuAccZ => _mpuAccZ;


  late final StreamController<String> _translationStreamController;
  Stream<String> get translationStream => _translationStreamController.stream;

  Timer? _translationTimer;
  List<Expression>? _currentExpressions;
  DecisionTreeClassifier? _currentModel;

  DecisionTreeClassifier? get currentModel => _currentModel;

  SensorData({required this.device})
  {
    _translationStreamController = StreamController<String>.broadcast();
    _btHandler = BluetoothConnectionHandler(device: device, onReceiveData: sensorDataCallback, mtuSize: 135);
    _btHandler.addListener(()
    {  
      _translationSetup();
      flutter_console.log("Bluetooth Connection State => ${_btHandler.currentBluetoothConnectionState}");
      notifyListeners();
    });

    _btHandler.connect();    
  }


  void _translationSetup() 
  {
    _translationTimer?.cancel();
    _translationStreamController.sink.add('');
    if(_currentLanguage == null || _btHandler.currentBluetoothConnectionState != BluetoothConnectionState.deviceConnected) return;
    
    final String? modelJson = _currentLanguage!.machineLearningModel;

    _currentModel = (modelJson == null)? null : DecisionTreeClassifier.fromJson(modelJson);

    if(_currentModel == null) return;

    Expression.getAllByLanguage(_currentLanguage!).then(
      (value)
      {
        _currentExpressions = value;
        _translationTimer = Timer.periodic(const Duration(seconds: 1), _translate);
      }
    );
  }

  void _translate(Timer t) async
  {
    if(_currentLanguage == null || 
      _btHandler.currentBluetoothConnectionState != BluetoothConnectionState.deviceConnected ||
      _currentExpressions == null || _currentExpressions!.isEmpty ||
      _currentModel == null
    ) return;

    DataFrame predictionDataFrame = DataFrame(
      [
        ["flex1", "flex2", "flex3", "flex4", "flex5", "accX", "accY", "accZ"],
        [_flex1, _flex2, _flex3, _flex4, _flex5, _mpuAccX, _mpuAccY, _mpuAccZ]
      ]
    );
    
    try
    {
      Map<String, Object?> prediction = _currentModel!.predict(predictionDataFrame).toJson();

      List<double> predictions = (prediction["R"]! as List<List>).first as List<double>;
      
      Expression? translated = await Expression.get(predictions.first.toInt()); 

      _translationStreamController.sink.add(translated!.name);

      flutter_console.log("translated ${[_flex1, _flex2, _flex3, _flex4, _flex5, _mpuAccX, _mpuAccY, _mpuAccZ]} => ${translated.name}");
    }
    catch(err)
    {
      flutter_console.logError("Error to translate => $err");
    }

  }

  void reconnectBluetooth()
  {
    _btHandler.connect();
  }

  @override
  void dispose()
  {
    disconnectBluetooth();
    _btHandler.dispose();
    super.dispose();
  }

  void disconnectBluetooth() => _btHandler.disconnect();


  sensorDataCallback(String value)
  {
    try
    {
      final Map<String, dynamic> map = jsonDecode(value);

      final flexList = map["flex"]!;
      final accList = map["aceleracao"]!;

      _flex1 = int.tryParse(flexList[0].toString()) ?? 0;
      _flex2 = int.tryParse(flexList[1].toString()) ?? 0;
      _flex3 = int.tryParse(flexList[2].toString()) ?? 0;
      _flex4 = int.tryParse(flexList[3].toString()) ?? 0;
      _flex5 = int.tryParse(flexList[4].toString()) ?? 0;

      _mpuAccX = double.tryParse(accList[0].toString()) ?? 0;
      _mpuAccY = double.tryParse(accList[1].toString()) ?? 0;
      _mpuAccZ = double.tryParse(accList[2].toString()) ?? 0;  

    }
    catch(err)
    {
      flutter_console.logError("Error on receiving data => $err");
    }
  }
}