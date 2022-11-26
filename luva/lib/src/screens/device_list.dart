import 'package:flutter/material.dart';
import 'package:luva/src/screens/qr_code_scanner_view.dart';
import 'package:luva/src/screens/home.dart';

import '../utils/sensor_data.dart';

import '../models/models.dart';
import '../utils/sensor_data_notifier.dart';



class DeviceList extends StatefulWidget {
  const DeviceList({super.key});

  @override
  State<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> 
{
  
  late Future<List<Device>> _deviceList;
  

  @override
  void initState()
  {
    _initDeviceList();
    super.initState();
  }

  void _initDeviceList() => _deviceList = Device.getAll();

  void navigateToQrCodeScreen()
  {   
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const QrCodeScanner())).then(
      (value)
      {
        _initDeviceList();
        setState(() {});
      }
    );
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
        onPressed: navigateToQrCodeScreen,
        tooltip: "Adicionar Dispositivo",
        child: const Icon(Icons.add)
      ),
    );
  }
}

