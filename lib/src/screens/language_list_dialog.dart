import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luva/src/models/sensor_data.dart';
import 'package:luva/src/repositories/language_repository.dart' as language_repository;
import 'package:luva/src/screens/sensor_data_notifier.dart';
import 'dart:async';

import '../models/language.dart';
import '../utils/icon_buttons.dart';

List<Language> linguagens = [
  Language(name: "Libras"),
  Language(name: "Libras 1"),
  Language(name: "Libras 2"),
  Language(name: "Libras 3"),
  Language(name: "Libras 4"),
  Language(name: "Libras 5"),
  Language(name: "Libras 6"),
  Language(name: "Libras 7"),
];


/*
void showLanguageListDialog({required BuildContext context, required Future<List<Language>> futureList, required Future<void> Function(Language) deleteLanguage, required Future<void> Function(String) editLanguage, required void Function() onSelectLanguage, required Future<void> Function(String) addLanguage})
{
  showDialog(
    context: context,
    builder: (context)
    {
      return FutureBuilder<List<Language>>(
        future: futureList,
        builder: (context, snapshot)
        {
          if(!snapshot.hasData)
          {
            return AlertDialog(
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
          
          return StatefulBuilder(
            builder: (context, setState)
            {
              return AlertDialog(
                backgroundColor: Colors.white,
                contentPadding: const EdgeInsets.all(0),
                content: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index)
                  {
                    return Padding(
                      padding: const EdgeInsets.all(4),
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        child: ListTile(
                          title: Text(snapshot.data!.elementAt(index).name),
                          trailing: Wrap(
                            spacing: 12,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              _editButton(()
                              {

                              }),
                              _deleteButton(()
                              {
                                _showDeleteDialog(
                                  context: context,
                                  onDeleteLanguage: deleteLanguage,
                                  languageToDelete: snapshot.data!.elementAt(index)
                                ).then((value) {setState(() {});});
                              })
                            ],
                          )
                        )
                      )
                    );
                  }
                ),
                actions: [
                  ElevatedButton(
                    child: Text("Ok"),
                    onPressed: () {Navigator.pop(context);}
                  ),
                  ElevatedButton(
                    child: Text("Adicionar"),
                    onPressed: () 
                    {
                      _showAddLanguageDialog(context: context, addLanguage: addLanguage).then((value) {setState(() {});});
                    }
                  ) 
                ]
              );
            }
          );
        },
      );
    }
  );
}
*/


/*
void showLanguageListDialog({required BuildContext context, required Future<void> Function(Language) deleteLanguage, required Future<void> Function(Language, String) editLanguage, required void Function(Language) onSelectLanguage, required Future<void> Function(String) addLanguage})
{
  showDialog(
    context: context,
    builder: (innerContext)
    {
      
      return StatefulBuilder(
        builder: (deeperContext, setState)
        {
          Future<List<Language>> languages = language_repository.getAllLanguagesByDevice(DataContainer.of(context).device);
          print("rebuild");
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
                                _editButton(()
                                {
                                  _showEditDialog(
                                    context: context,
                                    language: snapshot.data!.elementAt(index),
                                    editLanguage: editLanguage
                                  ).then((value) {setState(() {});});
                                }),
                                _deleteButton(()
                                {
                                  _showDeleteDialog(
                                    context: context,
                                    onDeleteLanguage: deleteLanguage,
                                    languageToDelete: snapshot.data!.elementAt(index)
                                  ).then((value) {setState(() {});});
                                })
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
                    child: Text("Ok"),
                    onPressed: () {Navigator.pop(context);}
                  ),
                  ElevatedButton(
                    child: Text("Adicionar"),
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
*/



void showLanguageListDialog({required BuildContext context, required Future<void> Function(Language) deleteLanguage, required Future<void> Function(Language, String) editLanguage, required void Function(Language) onSelectLanguage, required Future<void> Function(String) addLanguage})
{
  showDialog(
    context: context,
    builder: (innerContext)
    {
      
      return StatefulBuilder(
        builder: (deeperContext, setState)
        {
          Future<List<Language>> languages = language_repository.getAllLanguagesByDevice(SensorDataNotifier.of(context).device);
          print("rebuild");
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
                    child: Text("Ok"),
                    onPressed: () {Navigator.pop(context);}
                  ),
                  ElevatedButton(
                    child: Text("Adicionar"),
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
        title: Text("Nova Linguagem"),
        content: TextField(
          controller: textController
        ),
        actions: [
          ElevatedButton(
            child: Text("Adicionar"),
            onPressed: ()
            {
              addLanguage.call(textController.text).then((value) {Navigator.pop(context);});
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



Future<void> _showDeleteDialog({required BuildContext context, required Future<void> Function(Language) onDeleteLanguage, required Language languageToDelete}) async
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
              onDeleteLanguage.call(languageToDelete).then((value) {Navigator.pop(context);});
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


Future<void> _showEditDialog({required BuildContext context, required Language language , required Future<void> Function(Language, String) editLanguage}) async
{
  final TextEditingController textController = TextEditingController(text: language.name);
  return showDialog(
    context: context,
    builder: (context)
    {
      return AlertDialog(
        title: Text("Alterar Linguagem"),
        content: TextField(
          controller: textController
        ),
        actions: [
          ElevatedButton(
            child: Text("OK"),
            onPressed: ()
            {
              editLanguage.call(language, textController.text).then((value) {Navigator.pop(context);});
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











/*
Future<void> _showEditDialog({required BuildContext context, required Language language , required Future<void> Function(Language, String) editLanguage}) async
{
  final TextEditingController textController = TextEditingController(text: language.name);
  return showDialog(
    context: context,
    builder: (context)
    {
      return AlertDialog(
        title: Text("Alterar Linguagem"),
        content: TextField(
          controller: textController
        ),
        actions: [
          ElevatedButton(
            child: Text("OK"),
            onPressed: ()
            {
              editLanguage.call(language, textController.text).then((value) {Navigator.pop(context);});
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
*/

Widget _editButton(Function() onPressed) => _button(const Icon(Icons.edit), onPressed, "Editar");
Widget _deleteButton(Function() onPressed) => _button(const Icon(Icons.delete), onPressed, "Excluir");



Widget _button(Widget icon, void Function() onPressed, String tooltip)
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
























Future<void> showAddExpressionDialog({required BuildContext context, required void Function(String) startGatheringData, required void Function() stopGatheringData}) async
{
  final TextEditingController textController = TextEditingController();
  final TextEditingController counterTextController = TextEditingController(text: "01");
  
  return showDialog(
    context: context,
    builder: (context)
    {
      return AlertDialog(
        title: Text("Nova Expressão"),
        content: TextField(
          controller: textController,
        ),
        actions: [
          ElevatedButton(
            child: Text("Adicionar"),
            onPressed: ()
            {
              startGatheringData.call(textController.text);
              _showWaitCollectExpressionDataDialog(
                context: context,
                stopGatheringData: stopGatheringData,
                waitingTime: const Duration(seconds: 10)
              ).then((value) => Navigator.pop(context));
              //addLanguage.call(textController.text).then((value) {Navigator.pop(context);});
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





Future<void> _showWaitCollectExpressionDataDialog({required BuildContext context, required Duration waitingTime, required void Function() stopGatheringData})
{
  return showDialog(
    context: context,
    builder: (context)
    {
      Future.delayed(waitingTime, ()
      {
        stopGatheringData.call();
        Navigator.pop(context);
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