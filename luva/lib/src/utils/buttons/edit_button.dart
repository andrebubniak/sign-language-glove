import 'package:flutter/material.dart';
import '../dialogs/edit_dialog.dart';

/// Generic button to edit an item
Widget editButton({required BuildContext context, required Object itemToEdit, required String valueToEdit, required StateSetter setState, required Future<void> Function(Object, String) editItem})
{

  return IconButton(
    tooltip: "Editar",
    icon: const Icon(Icons.edit),
    iconSize: 30,
    constraints: const BoxConstraints(),
    padding: const EdgeInsets.all(0),
    splashRadius: 32,
    onPressed: ()
    {
      showEditDialog(
        context: context,
        editItem: editItem,
        itemToEdit: itemToEdit,
        valueToEdit: valueToEdit,
      ).then((value) {setState(() {});});
    }
  );
}
