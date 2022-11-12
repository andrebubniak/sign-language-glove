import 'package:flutter/material.dart';

import 'delete_dialog.dart';
import 'edit_dialog.dart';



Widget deleteButton({required BuildContext context, required Object itemToDelete, required StateSetter setState, required Future<void> Function(Object) deleteItem})
{
  return _button(
    icon: const Icon(Icons.delete),
    tooltip: "Excluir",
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



Widget editButton({required BuildContext context, required Object itemToEdit, required String valueToEdit, required StateSetter setState, required Future<void> Function(Object, String) editItem})
{
  return _button(
    icon: const Icon(Icons.edit),
    tooltip: "Editar",
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


Widget _button({required Widget icon, required void Function() onPressed, required String tooltip})
{
  return IconButton(
    tooltip: tooltip,
    icon: icon,
    iconSize: 30,
    constraints: BoxConstraints(),
    padding: EdgeInsets.all(0),
    splashRadius: 32,
    onPressed: onPressed,
  );
}