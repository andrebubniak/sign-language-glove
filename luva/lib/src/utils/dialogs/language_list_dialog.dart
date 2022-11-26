import 'package:flutter/material.dart';
import 'package:luva/src/utils/sensor_data_notifier.dart';
import 'dart:async';

import '../../models/language.dart';
import '../buttons/buttons.dart';


void showLanguageListDialog({required BuildContext context, required Future<void> Function(Language) deleteLanguage, required Future<void> Function(Language, String) editLanguage, required void Function(Language) onSelectLanguage, required Future<void> Function(String) addLanguage})
{
  showDialog(
    context: context,
    builder: (innerContext)
    {
      
      return StatefulBuilder(
        builder: (deeperContext, setState)
        {
          Future<List<Language>> languages = Language.getAllByDevice(SensorDataNotifier.of(context).device);
          return FutureBuilder<List<Language>>(
            future: languages,
            builder: (context, snapshot)
            {
              if(!snapshot.hasData)
              {
                return AlertDialog(
                  title: const Text("Linguagens"),
                  backgroundColor: Colors.white,
                  content: const Center(child: CircularProgressIndicator()),
                  actions: [
                    ElevatedButton(
                      child: const Text("Cancelar"),
                      onPressed: () {Navigator.pop(context);}
                    )
                  ]
                );
              }
              
              int currentSelectedIndex = -1;
              return AlertDialog(
                title: const Text("Linguagens"),
                backgroundColor: Colors.white,
                contentPadding: const EdgeInsets.all(0),
                content: StatefulBuilder(
                  builder: (context, listSetState)
                  {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index)
                      {
                        return Padding(
                          padding: const EdgeInsets.all(4),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: (currentSelectedIndex == index)? 2 : 1
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(12))
                            ),
                            selected: (currentSelectedIndex == index),
                            onTap: ()
                            {
                              currentSelectedIndex = index;
                              onSelectLanguage.call(snapshot.data!.elementAt(index));
                              listSetState((){});
                            },
                            title: Text(snapshot.data!.elementAt(index).name),
                            trailing: Wrap(
                              spacing: 12,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                editButton(
                                  context: context,
                                  editItem: (obj, value) => editLanguage.call(obj as Language, value),
                                  itemToEdit: snapshot.data!.elementAt(index),
                                  setState: setState,
                                  valueToEdit: snapshot.data!.elementAt(index).name
                                ),
                                deleteButton(
                                  context: context,
                                  deleteItem: (obj) => deleteLanguage.call(obj as Language),
                                  setState: setState,
                                  itemToDelete: snapshot.data!.elementAt(index)
                                )
                              ],
                            )
                          )
                        );
                      }
                    );
                  }
                ),
                actions: [
                  ElevatedButton(
                    child: const Text("Ok"),
                    onPressed: () {Navigator.pop(context);}
                  ),
                  ElevatedButton(
                    child: const Text("Adicionar"),
                    onPressed: () 
                    {
                      _showAddLanguageDialog(context: context, addLanguage: addLanguage).then((value) {setState(() {});});
                    }
                  ) 
                ]
              );
            },
          );
        }
      );
    }
  );
}



Future<void> _showAddLanguageDialog({required BuildContext context, required Future<void> Function(String) addLanguage}) async
{
  final TextEditingController textController = TextEditingController();
  return showDialog(
    context: context,
    builder: (context)
    {
      return AlertDialog(
        title: const Text("Nova Linguagem"),
        content: TextField(
          controller: textController
        ),
        actions: [
          ElevatedButton(
            child: const Text("Adicionar"),
            onPressed: ()
            {
              addLanguage.call(textController.text).then((value) {Navigator.pop(context);});
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
