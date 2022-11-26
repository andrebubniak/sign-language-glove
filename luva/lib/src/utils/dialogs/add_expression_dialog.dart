import 'package:flutter/material.dart';

Future<void> showAddExpressionDialog({required BuildContext context, required void Function(String) startGatheringData, required Future<void> Function() stopGatheringData}) async
{
  final TextEditingController textController = TextEditingController();
  
  return showDialog(
    context: context,
    builder: (context)
    {
      return AlertDialog(
        title: const Text("Nova Expressão"),
        content: TextField(
          controller: textController,
        ),
        actions: [
          ElevatedButton(
            child: const Text("Adicionar"),
            onPressed: ()
            {
              startGatheringData.call(textController.text);
              _showWaitCollectExpressionDataDialog(
                context: context,
                stopGatheringData: stopGatheringData,
                waitingTime: const Duration(seconds: 7, milliseconds: 500)
              ).then((value) => Navigator.pop(context));
              //addLanguage.call(textController.text).then((value) {Navigator.pop(context);});
            }
          ),
          ElevatedButton(
            child: const Text("Cancelar"),
            onPressed: () {Navigator.pop(context);}
          )
        ]
      );
    }
  );
}




Future<bool?> showAddNoneExpressionDialog({required BuildContext context, required void Function(String) startGatheringData, required Future<void> Function() stopGatheringData}) async
{
  
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context)
    {
      return AlertDialog(
        title: const Text("Adicionar Posição Relaxada"),
        actions: [
          ElevatedButton(
            child: const Text("Adicionar"),
            onPressed: ()
            {
              startGatheringData.call("relaxado");
              _showWaitCollectExpressionDataDialog(
                context: context,
                stopGatheringData: stopGatheringData,
                waitingTime: const Duration(seconds: 7, milliseconds: 500)
              ).then((value) => Navigator.pop<bool>(context, true));
            }
          ),
          ElevatedButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop<bool>(context, false)
          )
        ]
      );

    }
  );
}






Future<void> _showWaitCollectExpressionDataDialog({required BuildContext context, required Duration waitingTime, required Future<void> Function() stopGatheringData})
{
  return showDialog(
    context: context,
    builder: (context)
    {
      Future.delayed(waitingTime, ()
      {
        stopGatheringData.call().then((val) =>Navigator.pop(context));
      });
      return AlertDialog(
        title: const Text("Adicionando Expressão"),
        content: Column(
          children: const [
            CircularProgressIndicator(),
            Text("Adicionando Expressão"),
            Text("Mantenha a posição")
          ],
        )
      );
    }
  );
}