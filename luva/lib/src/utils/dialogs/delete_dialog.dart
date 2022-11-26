import 'package:flutter/material.dart';


/// Generic Dialog to confirm deletion of a item
Future<void> showDeleteDialog({required BuildContext context, required Future<void> Function(Object) onDeleteItem, required Object itemToDelete}) async
{
  return showDialog(
    context: context,
    builder: (context)
    {
      return AlertDialog(
        content: const Center(
          child: Text("Deseja excluir item")
        ),
        actions: [
          ElevatedButton(
            child: const Text("OK"),
            onPressed: ()
            {
              onDeleteItem.call(itemToDelete).then((value) {Navigator.pop(context);});
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