import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luva/src/utils/common_dialog.dart';
import 'package:luva/src/screens/qr_code_scanner_view.dart';
import 'package:luva/src/screens/home.dart';
import 'package:path_provider/path_provider.dart';

import '../models/sensor_data.dart';
import '../repositories/device_repository.dart' as device_repository;

import '../models/device.dart';
import 'sensor_data_notifier.dart';


import 'package:ml_algo/ml_algo.dart';
import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';


class DeviceList extends StatefulWidget {
  const DeviceList({super.key});

  @override
  State<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> 
{
  
  //late final Teste test;
  late Future<List<Device>> _deviceList;
  
  //late final TesteBluetooth testeBluetooth;

  @override
  void initState()
  {
    //test = Teste();
    print("INIT STATE");
    //_deviceList = dr.getAll();
    //device_repository.deleteDevice(1);
    //_deviceList = device_repository.getAllDevices();
    _initDeviceList();
    //_deviceList = Future.delayed(Duration(seconds: 3), () => _lista);
    /*
    testeBluetooth = TesteBluetooth(Device(
      name: "ESP32_LUVA",
      flex1UUID: "9e7ea8e3-c41b-4e40-9837-f9cdd6c5cb9d",
      flex2UUID: "eb02d864-0af9-11ed-861d-0242ac120002",
      mpuXUUID: "4e96bfb0-6a0b-46e8-9af6-af016920d1e4",
      mpuYUUID: "0d3a7e90-0a33-11ed-861d-0242ac120002",
      mpuZUUID: "b3d1aa30-3f09-47fc-b040-0172b2e0b367",
      sendDataUUID: "081ab48e-0a33-11ed-861d-0242ac120002",
      serviceUUID: "f6467fe0-3af7-4bdb-b5a5-4c9a5dec1568"
    ));
    */
    super.initState();
  }

  void _initDeviceList() => _deviceList = device_repository.getAllDevices();

  void navigateToQrCode() async
  {

    
    final A = 0;
    final B = 1;
    final C = 2;

    final data = 
    [
      ["flex1", "flex2", "flex3", "flex4", "flex5", "accX", "accY", "letra"],
      [792.48, 730.31, 689.97, 683.38, 824.35, -16137.94, -1768.51, A],
      [806.15, 715.15, 724.27, 648.2, 913.31, -15758.0, -1682.36, A],
      [780.19, 760.28, 788.79, 737.03, 901.58, -14175.99, -2017.9, A],
      [744.78, 803.59, 723.65, 653.61, 815.71, -14707.1, -1784.61, A],
      [696.7, 804.28, 682.4, 712.89, 861.91, -14266.43, -1820.36, A],
      [555.42, 482.88, 544.48, 538.86, 937.19, -16989.26, -641.15, B],
      [472.68, 554.58, 522.24, 481.17, 926.24, -16622.36, -652.53, B],
      [530.0, 551.57, 526.43, 545.66, 857.52, -17072.96, -704.51, B],
      [492.92, 533.8, 478.6, 491.26, 826.48, -14921.44, -621.58, B],
      [513.8, 550.12, 474.93, 536.66, 916.8, -14278.54, -690.43, B],
      [626.46, 677.74, 604.32, 577.52, 895.77, -14853.67, -235.35, C],
      [628.64, 629.08, 590.8, 573.59, 923.47, -16136.78, -201.02, C],
      [562.64, 678.79, 649.37, 675.6, 833.25, -15662.71, -218.33, C],
      [617.51, 571.0, 566.73, 669.11, 887.98, -17811.21, -234.79, C],
      [626.7, 570.05, 615.13, 592.87, 878.16, -17329.14, -211.19, C]
    ];

    final lista = 
    [
      792.48, 730.31, 689.97, 683.38, 824.35, -16137.94, -1768.51,
      806.15, 715.15, 724.27, 648.2, 913.31, -15758.0, -1682.36,
      780.19, 760.28, 788.79, 737.03, 901.58, -14175.99, -2017.9,
      696.7, 804.28, 682.4, 712.89, 861.91, -14266.43, -1820.36,
      626.46, 677.74, 604.32, 577.52, 895.77, -14853.67, -235.35,
      628.64, 629.08, 590.8, 573.59, 923.47, -16136.78, -201.02,
      617.51, 571.0, 566.73, 669.11, 887.98, -17811.21, -234.79,
      626.7, 570.05, 615.13, 592.87, 878.16, -17329.14, -211.19,
      617.51, 571.0, 566.73, 669.11, 887.98, -17811.21, -234.79,
    ];

    final lista_resultado = [0, 1, 2];


    final List<List<dynamic>> dados = [];

    final datas = [];

    dados.add(["flex1", "flex2", "flex3", "flex4", "flex5", "accX", "accY", "letra"]);

    for(int i = 0;i < 2000;i++)
    {
      dados.add(
        [
          lista.elementAt(Random().nextInt(lista.length)),
          lista.elementAt(Random().nextInt(lista.length)),
          lista.elementAt(Random().nextInt(lista.length)),
          lista.elementAt(Random().nextInt(lista.length)),
          lista.elementAt(Random().nextInt(lista.length)),
          lista.elementAt(Random().nextInt(lista.length)),
          lista.elementAt(Random().nextInt(lista.length)),
          lista_resultado.elementAt(Random().nextInt(lista_resultado.length)),
        ]
      );
    }

    //splitData(data, ratios)

    //Pipeline().

    final timer = Stopwatch()..start();
    

    print("comecou");
    final dataFrame = DataFrame(
      dados
    ).shuffle();

    
    final tree = DecisionTreeClassifier(
      dataFrame,
      "letra",
      minError: 0.1,
    );
    print("terminou => ${timer.elapsedMilliseconds}");

    timer.stop();

    final test = DataFrame([
      ["flex1", "flex2", "flex3", "flex4", "flex5", "accX", "accY", "letra"],
      [754.58, 747.51, 744.64, 719.41, 858.10, -15557.58, -1840.04, A],
      [511.52, 510.90, 508.09, 511.18, 903.05, -15816.73, -672.97, B],
      [582.22, 628.07, 614.12, 623.98, 884.06, -16345.37, -214.06, C]
    ]);


    print("ACURACIA => ${tree.assess(test, MetricType.accuracy)}");
    print("PRECISAO => ${tree.assess(test, MetricType.precision)}");


    //print("predict => ${tree.predict(test)}");


    //final d = await getExternalStorageDirectory();
    //print("dir => ${d!.path}");
    //print(tree.assess(dataFrame, MetricType.accuracy));
    //tree.saveAsJson("${d.path}/tree.json");
    //tree.saveAsSvg("${d.path}/tree.svg");
    
    

    /*
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const QrCodeScanner())).then(
      (value)
      {
        _initDeviceList();
        setState(() {});
      }
    );
    */
    
        
    
    //showListDialog(context: context);
    //print("COUNTER => ${test.counter}");
  }

  void navigateToTranslationScreen(Device device)
  {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context)
        {
          return SensorDataNotifier(
            notifier: SensorData(device: device),
            child: const Home()
          );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dispositivos"),
      ),
      body: FutureBuilder<List<Device>>(
        future: _deviceList,
        builder: (context, snapshot)
        {
          if(snapshot.hasData)
          {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index)
              {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.black,
                        width: 2
                      ),
                    ),
                    child: ListTile(
                      title: Text(snapshot.data!.elementAt(index).name, textAlign: TextAlign.left),
                      leading: const Icon(
                        Icons.front_hand
                      ),
                      onTap: () => navigateToTranslationScreen(snapshot.data!.elementAt(index))
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToQrCode,
        tooltip: "Adicionar Dispositivo",
        child: const Icon(Icons.add)
      ),
    );
  }
}

