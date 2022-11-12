

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:luva/src/screens/language_list_dialog.dart';
import '../models/expression.dart';
import '../repositories/expression_repository.dart' as expression_repository;
import '../utils/icon_buttons.dart';
import 'sensor_data_notifier.dart';

class ExpressionList extends StatefulWidget 
{
  const ExpressionList({super.key});

  @override
  State<ExpressionList> createState() => _ExpressionListState();
}

class _ExpressionListState extends State<ExpressionList> 
{

  Timer? _gatherDataTimer;
  String? _currentExpressionName;

  Future<void> deleteExpression(Expression expression) async => await expression_repository.deleteExpression(expression.id!);


  void startGatheringData(String expressionName)
  {
    _currentExpressionName = expressionName;
    print(expressionName);
    Expression newExpression = Expression(name: expressionName, languageId: SensorDataNotifier.of(context).currentLanguage!.id);
    expression_repository.insertExpression(newExpression);
    _gatherDataTimer = Timer.periodic(const Duration(milliseconds: 10), gatherData);
  }


  int count = 0;

  void gatherData(Timer t)
  {
    count += 1;
    print("gather data => $count");
  }

  void stopTimer()
  {
    _gatherDataTimer?.cancel();
  }


  @override
  Widget build(BuildContext context) 
  {
    /*
    final currentLanguage = DataContainer.of(context).currentLanguage;
    final Future<List<Expression>> expressionList;

    if(currentLanguage == null)
    {
      expressionList = Future.error(Exception("Don't have a current selected language"));
    }
    else
    {
      expressionList = expression_repository.getAllExpressionsByLanguage(currentLanguage);
    }*/

    print("build expression list");

    //final Future<List<Expression>> expressionList = Future.delayed(Duration(seconds: 5), () => expression_repository.);

    final Future<List<Expression>> expressionList = expression_repository.getAllExpressions();

    return FutureBuilder<List<Expression>>(
      future: expressionList,
      builder: (context, snapshot)
      {
        if(snapshot.hasError)
        {
          return Container();
        }

        if(SensorDataNotifier.of(context).currentLanguage == null)
        {
          return const Center(
            child: Text("Nenhuma linguagem Selecionada!")
          );
        }

        if(!snapshot.hasData && !snapshot.hasError)
        {
          return const Center(
            child: CircularProgressIndicator()
          );
        }
        print("color => ${Theme.of(context).backgroundColor}");

        return Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                //height: MediaQuery.of(context).size.height * .6,
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index)
                  {
                    return Padding(
                      padding: const EdgeInsets.all(8),
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
                              deleteButton(
                                context: context,
                                deleteItem: (obj) => deleteExpression.call(obj as Expression),
                                setState: setState,
                                itemToDelete: snapshot.data!.elementAt(index)
                              )
                            ],
                          )
                        ),
                      )
                    );
                  }
                ),
              ),
            ),
            const Divider(
              color: Colors.black,
              height: 1
            ),
            Expanded(
              child: FloatingActionButton(
                onPressed: ()
                {
                  showAddExpressionDialog(
                    context: context,
                    startGatheringData: startGatheringData,
                    stopGatheringData: stopTimer
                  ).then((value) {setState(() {});});
                },
                child: Icon(Icons.add),
                tooltip: "Adicionar Expressao",
              ),
            )
            
          ]
        );
      }
    );

  }
}


final expressoes = [
  Expression(name: "Nome da expressão 1"),
  Expression(name: "Nome da expressão 2"),
  Expression(name: "Nome da expressão 3"),
  Expression(name: "Nome da expressão 4"),
  Expression(name: "Nome da expressão 5"),
  Expression(name: "Nome da expressão 6"),
  Expression(name: "Nome da expressão 7"),
  Expression(name: "Nome da expressão 8"),
  Expression(name: "Nome da expressão"),
];

