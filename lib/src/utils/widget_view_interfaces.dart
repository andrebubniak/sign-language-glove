import 'package:flutter/material.dart';


/// Interface for stateful widget views
///
/// [T1] : Widget
/// 
/// [T2] : State
abstract class StatefulView<T1, T2> extends StatelessWidget 
{
  final T2 state;
  T1 get widget => (state as State).widget as T1;
  const StatefulView(this.state, {Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context);
}

/// Interface for stateless widget views
///
/// [T1] : Widget
abstract class StatelessView<T1> extends StatelessWidget 
{
  final T1 widget;
 
  const StatelessView(this.widget, {Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context);
}

