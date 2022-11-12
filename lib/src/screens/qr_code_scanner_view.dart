


import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:luva/src/database/database.dart';
import 'package:luva/src/models/device.dart';
import 'package:luva/src/repositories/device_repository.dart' as device_repository;
import 'package:luva/src/utils/common_dialog.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> 
{

  final qrKey = GlobalKey();
  QRViewController? controller;
  late Future<String> _errorToDisplay;
  bool _qrCodeScanned = false;
  Completer<String> _errorToDisplayCompleter = Completer<String>();


  //arruma o hot reload da camera (tira no final)
  /*
  @override
  void reassemble() 
  {
    
    if(Platform.isAndroid)
    {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
    super.reassemble();

  }
  */


  @override
  void dispose()
  {
    controller?.dispose();
    super.dispose();
  }

  void _onQrViewCreated(QRViewController controller)
  {
    setState(() {
      this.controller = controller;
    });

    controller.pauseCamera();
    controller.resumeCamera();

    controller.scannedDataStream.listen(
      (value) async
      {
        if(_qrCodeScanned) return;
        _qrCodeScanned = true;

        final Completer<String> messageToDisplayCompleter = Completer<String>();
        
        //_showDialog();
        showCommonDialog(context: context, futureMessage: messageToDisplayCompleter.future, loadingMessage: "Carregando...", onPop: () {_qrCodeScanned = false;});
        //await Future.delayed(Duration(seconds: 3));
        //_errorToDisplay = Future.value("VALOR");
        //_errorToDisplayCompleter.complete("VALORRR");
        //return;
        Device newDevice;
        //teste = Future.delayed(Duration(seconds: 3), () => true);
        try
        {
          //print(value.code!);
          final json = jsonDecode(value.code!);
          //json.forEach((key, value) {print("[$key => $value]");});
          newDevice = Device.fromMap(json);
          final devices = await device_repository.getAllDevices();
          for(Device d in devices)
          {
            if(d == newDevice)
            {
              //_errorToDisplayCompleter.complete("Dispositivo Já Existente");
              messageToDisplayCompleter.complete("Dispositivo Já Existente");
              return;
            }
          }
          final bool result = await device_repository.insertDevice(newDevice);
          //_errorToDisplayCompleter.complete( (result)? "Dispositivo Inserido com Sucesso" : "Erro ao Inserir Dispositivo" );
          messageToDisplayCompleter.complete( (result)? "Dispositivo Inserido com Sucesso" : "Erro ao Inserir Dispositivo" );
          //print(newDevice.toString());
        }
        catch(e)
        {
          print("Erro => $e");
          //_errorToDisplayCompleter.complete("QR Code Inválido");
          messageToDisplayCompleter.complete("QR Code Inválido");
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adicionar Dispositivo")
      ),
      body: QRView(
        key: qrKey,
        formatsAllowed: const [
          BarcodeFormat.qrcode
        ],
        onQRViewCreated: _onQrViewCreated,
        overlay: QrScannerOverlayShape(
          cutOutSize: MediaQuery.of(context).size.width * .75,
          borderColor: Colors.white,
          borderWidth: 16,
          borderLength: 24,
          borderRadius: 10
        ),
      )
    );
  }
}