import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:luva/src/models/device.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:console_flutter/console_flutter.dart' as flutter_console;

import '../utils/dialogs/dialogs.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> 
{

  final qrKey = GlobalKey();
  QRViewController? controller;
  bool _qrCodeScanned = false;

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
        flutter_console.log("QR Code Scanned => ${value.code!}");

        if(_qrCodeScanned) return;
        _qrCodeScanned = true;

        final Completer<String> messageToDisplayCompleter = Completer<String>();
        
        showCommonDialog(context: context, futureMessage: messageToDisplayCompleter.future, loadingMessage: "Carregando...", onPop: () {_qrCodeScanned = false;});
        Device newDevice;
        try
        {
          final json = jsonDecode(value.code!);
          newDevice = Device.fromMap(json);
          final devices = await Device.getAll();
          for(Device d in devices)
          {
            if(d == newDevice)
            {
              messageToDisplayCompleter.complete("Dispositivo Já Existente");
              return;
            }
          }
          final bool result = await Device.insert(newDevice);
          messageToDisplayCompleter.complete( (result)? "Dispositivo Inserido com Sucesso" : "Erro ao Inserir Dispositivo" );
        }
        catch(e)
        {
          flutter_console.logError("Error to scan QR Code => $e");
          messageToDisplayCompleter.complete("QR Code Inválido");
          _qrCodeScanned = false;
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