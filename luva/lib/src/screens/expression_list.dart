import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ml_algo/ml_algo.dart';
import 'package:ml_dataframe/ml_dataframe.dart';
import '../models/models.dart';
import '../utils/buttons/buttons.dart';
import '../utils/dialogs/dialogs.dart';
import '../utils/sensor_data_notifier.dart';
import 'package:console_flutter/console_flutter.dart' as flutter_console;

class ExpressionList extends StatefulWidget 
{
  const ExpressionList({super.key});

  @override
  State<ExpressionList> createState() => _ExpressionListState();
}

class _ExpressionListState extends State<ExpressionList> 
{

  Timer? _gatherDataTimer;

  Expression? _currentExpression;

  final List<TrainingData> _currentTrainingData = [];

  void startGatheringData(String expressionName) async
  {
    if(!mounted || SensorDataNotifier.of(context).currentLanguage == null) return;

    if(expressionName == "relaxado")
    {
      final expressions = await Expression.getAllByLanguage(SensorDataNotifier.of(context).currentLanguage!);

      final relaxedExpression = expressions.where( (expression) => expression.name == "relaxado" );

      if(relaxedExpression.isNotEmpty)
      {
        Expression.delete(relaxedExpression.first.id!);
      }
    }

    if(!mounted) return;

    Expression newExpression = Expression(name: expressionName, languageId: SensorDataNotifier.of(context).currentLanguage!.id);
    final expressionId = await Expression.insert(newExpression);
    
    _currentExpression = await Expression.get(expressionId);
    
    _currentTrainingData.clear();
    _gatherDataTimer = Timer.periodic(const Duration(milliseconds: 15), gatherData);
  }

  void gatherData(Timer t)
  {
    if(!mounted) return;
    final sensorData = SensorDataNotifier.of(context);
    final TrainingData data = TrainingData(
      expressionId: _currentExpression?.id,
      flex1: sensorData.flex1,
      flex2: sensorData.flex2,
      flex3: sensorData.flex3,
      flex4: sensorData.flex4,
      flex5: sensorData.flex5,
      mpuAccX: sensorData.mpuAccX,
      mpuAccY: sensorData.mpuAccY,
      mpuAccZ: sensorData.mpuAccZ
    );

    _currentTrainingData.add(data);
    flutter_console.log("Gathering Data => $data");
  }

  Future<void> stopTimer() async
  {
    _gatherDataTimer?.cancel();
    await TrainingData.insertList(_currentTrainingData);
    _currentTrainingData.clear();
  }


  Future<Map<String, double>> trainModel() async
  {
    try
    {
      final stopwatch = Stopwatch()..start();

      final List<Expression> expressions = await Expression.getAllByLanguage(SensorDataNotifier.of(context).currentLanguage!);
      final List<List<Object?>> trainingDataList = [];
      
      for(var exp in expressions)
      {
        final list = await TrainingData.getAllByExpression(exp);
        
        trainingDataList.addAll(
          list.map(
            (data)
            {
              return [
                data.flex1,
                data.flex2,
                data.flex3,
                data.flex4,
                data.flex5,
                data.mpuAccX,
                data.mpuAccY,
                data.mpuAccZ,
                data.expressionId
              ];
            }
          )
        );
      }

      final List<List> data = [];
      data.add(["flex1", "flex2", "flex3", "flex4", "flex5", "accX", "accY", "accZ", "expression"]);

      data.addAll(trainingDataList);

      final dataFrame = DataFrame(
        data,
      ).shuffle();

      final splits = splitData(dataFrame, [0.8]);

      final tree = DecisionTreeClassifier(
        splits[0],
        "expression",
        maxDepth: expressions.length,
        minError: 0.1
      );

      
      if(!mounted)
      {
        stopwatch.stop();
        return Future.error(Exception());
      }

      final machineLearningModel = jsonEncode(tree.toJson());
      final precision = tree.assess(splits[1], MetricType.precision);
      final accuracy = tree.assess(splits[1], MetricType.accuracy);

      flutter_console.log("Model Trained: ");
      flutter_console.log("Precision: $precision");
      flutter_console.log("Accuracy: $accuracy");
      flutter_console.log("Model: $machineLearningModel");
      flutter_console.log("Elapsed Milliseconds: ${stopwatch.elapsedMilliseconds}");

      Language languageToUpdate = Language(
        id: SensorDataNotifier.of(context).currentLanguage!.id,
        name: SensorDataNotifier.of(context).currentLanguage!.name,
        deviceId: SensorDataNotifier.of(context).currentLanguage!.deviceId,
        machineLearningModel: machineLearningModel
      );

      await Language.update(languageToUpdate);
      final updatedLanguage = await Language.get(languageToUpdate.id!);

      stopwatch.stop();

      if(!mounted) return Future.error(Exception());

      SensorDataNotifier.of(context).currentLanguage = updatedLanguage;

      return {
        "precision": precision,
        "accuracy": accuracy,
        "elapsed": (stopwatch.elapsedMilliseconds / 60000).toDouble()
      };
    }
    catch(err)
    {
      flutter_console.logError("Error on training model => $err");
      return Future.error(Exception());
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    final Future<List<Expression>> expressionList = Expression.getAllByLanguage(SensorDataNotifier.of(context).currentLanguage)
      .then((list)
      {
        list.removeWhere((expression) => expression.name == "relaxado");
        return list;
      });

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

        return Column(
          children: [
            Expanded(
              flex: 5,
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
                              deleteItem: (obj) => Expression.delete.call((obj as Expression).id!),
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
            const Divider(
              color: Colors.black,
              height: 1
            ),
            Expanded(
              child: Wrap(
                spacing: 12,
                children: [
                  FloatingActionButton(
                    onPressed: ()
                    {
                      showAddExpressionDialog(
                        context: context,
                        startGatheringData: startGatheringData,
                        stopGatheringData: stopTimer
                      ).then((value) {setState(() {});});
                    },
                    tooltip: "Adicionar Expressao",
                    child: const Icon(Icons.add),
                  ),
                  ElevatedButton(
                    onPressed: (snapshot.data!.isNotEmpty)? () 
                    {
                      showAddNoneExpressionDialog(
                        context: context,
                        startGatheringData: startGatheringData,
                        stopGatheringData: stopTimer
                      ).then((value)
                      {
                        if(!value!) return;

                        showTrainingDialog(
                          context: context,
                          loadingMessage: "Treinando Modelo...",
                          futureMapPerformance: trainModel(),
                        );
                      }); 
                    } : null,
                    child: const Text("Treinar Modelo"),
                  )
                ]
              ),
            )      
          ]
        );
      }
    );
  }
}

