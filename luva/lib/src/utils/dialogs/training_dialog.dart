import 'package:flutter/material.dart';

/// Dialog that display a waiting message [loadingMessage]
/// until the model complete the training [futureMapPerformance] to allow the user dismiss the dialog.

void showTrainingDialog({required BuildContext context, required Future<Map<String, double>> futureMapPerformance, String loadingMessage = ""})
{
  showDialog(
  barrierDismissible: false,
    context: context,
    builder: (context) 
    {
      return FutureBuilder<Map>(
        future: futureMapPerformance,
        builder: (context, snapshot)
        {
          final Widget widgetToDisplay;

          List<Widget> dialogActions = [];

          if(snapshot.hasData)
          {
            loadingMessage = "";

            widgetToDisplay = Column(
              children: [
                const Text("Modelo Treinado: "),
                Text("Acurácia: ${(snapshot.data!["accuracy"] as double).toStringAsFixed(10)}", textAlign: TextAlign.center),
                Text("Precisão: ${(snapshot.data!["precision"] as double).toStringAsFixed(10)}", textAlign: TextAlign.center),
                Text("Duração: ${(snapshot.data!["elapsed"] as double).toStringAsFixed(2)} minutos", textAlign: TextAlign.center,)
              ],
            );

            dialogActions = [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK")
              )
            ];
          }

          else if(snapshot.hasError)
          {
            widgetToDisplay = const Text("Erro ao treinar modelo", textAlign: TextAlign.center);
            dialogActions = [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK")
              )
            ];
          }

          else
          {
            widgetToDisplay = Center(
              child: Text(loadingMessage)
            );

          }
          
          final height = MediaQuery.of(context).size.height;
          final width = MediaQuery.of(context).size.width;

          return AlertDialog(
            backgroundColor: Colors.white,
            actionsPadding: const EdgeInsets.only(right: 8),
            contentPadding: const EdgeInsets.only(top: 15),
            content: widgetToDisplay,
            insetPadding: EdgeInsets.symmetric(vertical: height * 0.35, horizontal: width * 0.1),
            actions: dialogActions
          );
        }
      );
    },
  );
}