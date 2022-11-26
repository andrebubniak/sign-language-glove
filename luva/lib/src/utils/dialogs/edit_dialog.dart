import 'package:flutter/material.dart';


/// Generic Dialog to edit an item (String)
Future<void> showEditDialog({required BuildContext context, required Object itemToEdit, required String valueToEdit, required Future<void> Function(Object, String) editItem}) async
{
  final TextEditingController textController = TextEditingController(text: valueToEdit);
  return showDialog(
    context: context,
    builder: (context)
    {
      return AlertDialog(
        title: const Text("Editar"),
        content: TextField(
          controller: textController
        ),
        actions: [
          ElevatedButton(
            child: const Text("OK"),
            onPressed: ()
            {
              editItem.call(itemToEdit, textController.text).then((value) {Navigator.pop(context);});
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