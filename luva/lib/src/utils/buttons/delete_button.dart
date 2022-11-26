import 'package:flutter/material.dart';

import '../dialogs/delete_dialog.dart';


/// Generic IconButton to delete an item
Widget deleteButton({required BuildContext context, required Object itemToDelete, required StateSetter setState, required Future<void> Function(Object) deleteItem})
{

  return IconButton(
    tooltip: "Excluir",
    icon: const Icon(Icons.delete),
    iconSize: 30,
    constraints: const BoxConstraints(),
    padding: const EdgeInsets.all(0),
    splashRadius: 32,
    onPressed: ()
    {
      showDeleteDialog(
        context: context,
        onDeleteItem: deleteItem,
        itemToDelete: itemToDelete
      ).then((value) {setState(() {});});
    }
  );
}
