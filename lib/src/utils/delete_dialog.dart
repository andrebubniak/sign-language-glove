import 'package:flutter/material.dart';


Future<void> showDeleteDialog({required BuildContext context, required Future<void> Function(Object) onDeleteItem, required Object itemToDelete}) async
{
  return showDialog(
    context: context,
    builder: (context)
    {
      return AlertDialog(
        content: Center(
          child: Text("Deseja excluir item")
        ),
        actions: [
          ElevatedButton(
            child: Text("OK"),
            onPressed: ()
            {
              onDeleteItem.call(itemToDelete).then((value) {Navigator.pop(context);});
            }
          ),
          ElevatedButton(
            child: Text("Cancelar"),
            onPressed: () {Navigator.pop(context);}
          )
        ]
      );
    }
  );
}