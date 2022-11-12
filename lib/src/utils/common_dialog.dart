import 'package:flutter/material.dart';


void showCommonDialog({required BuildContext context, required Future<String> futureMessage, String loadingMessage = "", void Function()? onPop})
{
  showDialog(
  barrierDismissible: false,
    context: context,
    builder: (context) 
    {
      return FutureBuilder<String>(
        future: futureMessage,
        builder: (context, snapshot)
        {
          final Widget widgetToDisplay;
          Widget? okButton;

          if(snapshot.hasData)
          {
            loadingMessage = "";

            widgetToDisplay = Text(
              snapshot.data!,
              textAlign: TextAlign.center,
            );

              okButton = ElevatedButton(
                onPressed: ()
                {
                  Navigator.pop(context);
                  onPop?.call();
                },
                child: const Text("OK"),
            );
          }
          else
          {
            widgetToDisplay = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 5),
                  Center(child: Text(loadingMessage))
                ],
              )
            );
          }
          
          final height = MediaQuery.of(context).size.height;
          final width = MediaQuery.of(context).size.width;

          return AlertDialog(
            backgroundColor: Colors.white,
            actionsPadding: const EdgeInsets.only(right: 8),
            contentPadding: const EdgeInsets.only(top: 15),
            content: widgetToDisplay,
            insetPadding: EdgeInsets.symmetric(vertical: height * 0.35, horizontal: width * 0.1),
            actions: (okButton == null)? null : [okButton]
          );
        }
      );
    },
  );
}











/*
void showListDialog({required BuildContext context})
{
  showDialog(
    context: context,
    builder: (context) 
    {
      final Future<String> futureMessage = Future.delayed(Duration(seconds: 2), () => "mensagem");
      String loadingMessage = "Carregando";
      return FutureBuilder<String>(
        future: futureMessage,
        builder: (context, snapshot)
        {
          final Widget widgetToDisplay;
          Widget? okButton;

          if(snapshot.hasData)
          {
            loadingMessage = "";

            widgetToDisplay = Text(
              snapshot.data!,
              textAlign: TextAlign.center,
            );

              okButton = ElevatedButton(
                onPressed: ()
                {
                  Navigator.pop(context);
                  //onPop?.call();
                },
                child: const Text("OK"),
            );
          }
          else
          {
            widgetToDisplay = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 5),
                  Center(child: Text(loadingMessage))
                ],
              )
            );
          }
          
          final height = MediaQuery.of(context).size.height;
          final width = MediaQuery.of(context).size.width;

          return AlertDialog(
            backgroundColor: Colors.white,
            //actionsPadding: const EdgeInsets.all(0),
            contentPadding: const EdgeInsets.all(0),
            content: Container(
              //color: Colors.black26,
              child: ListView.builder(
                itemCount: 15,
                shrinkWrap: true,
                itemBuilder: (context, index)
                {
                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(),
                        borderRadius: BorderRadius.all(Radius.circular(12))
                      ),
                      child: ListTile(
                        title: Text("List Item $index oakjsdokjaksjdlasdaplçsfaslgfgdfghaklf"),
                        trailing: Wrap(
                          spacing: 12,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          //alignment: WrapAlignment.center,
                          //runAlignment: WrapAlignment.start,
                          children: [
                            IconButton(
                              iconSize: 30,
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.all(0),
                              icon: Icon(Icons.delete),
                              splashRadius: 32,
                              onPressed: () {print("DELETE");},
                            ),
                            IconButton(
                              iconSize: 30,
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.all(0),
                              icon: Icon(Icons.edit),
                              splashRadius: 32,
                              onPressed: () {print("EDIT");},
                            )
                          ]
                        )
                      )
                    ),
                  );
                  //return ListTile(
                    //title: Text("List item $index"),
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    /*
                    title: Card(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("List item $index"),
                      )
                    )*/
                  //);
                },
              ),
            ),
            //content: widgetToDisplay,
            //insetPadding: EdgeInsets.symmetric(vertical: height * 0.35, horizontal: width * 0.1),
            actions: (okButton == null)? null : [okButton]
          );
        }
      );
    },
  );
}
*/










List<String> _lista = <String>[];

void _populateList()
{
  for(int i = 0;i < 20;i++)
  {
    _lista.add("Item $i");
  }
}


void _changeList(int index, String newString)
{
  _lista[index] = newString;
}



void _showInputDialog({required BuildContext context, required String text, required int listIndex})
{
  final TextEditingController textController = TextEditingController(text: text);
  showDialog(
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
              _changeList(listIndex, textController.text);
              Navigator.pop(context);
            }
          )
        ]
      );
    }
  );
}


Future<void> _showDeleteDialog({required BuildContext context, required int index}) async
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
              _lista.removeAt(index);
              Navigator.pop(context);
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



void showListDialog({required BuildContext context})
{
  
  _populateList();
  showDialog(
    context: context,
    builder: (context) 
    {
      final Future<String> futureMessage = Future.delayed(Duration(seconds: 2), () => "mensagem");
      String loadingMessage = "Carregando";
      return FutureBuilder<String>(
        future: futureMessage,
        builder: (context, snapshot)
        {
          final Widget widgetToDisplay;
          Widget? okButton;

          if(snapshot.hasData)
          {
            loadingMessage = "";

            widgetToDisplay = Text(
              snapshot.data!,
              textAlign: TextAlign.center,
            );

              okButton = ElevatedButton(
                onPressed: ()
                {
                  Navigator.pop(context);
                  //onPop?.call();
                },
                child: const Text("OK"),
            );
          }
          else
          {
            widgetToDisplay = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 5),
                  Center(child: Text(loadingMessage))
                ],
              )
            );
          }
          
          final height = MediaQuery.of(context).size.height;
          final width = MediaQuery.of(context).size.width;

          return AlertDialog(
            backgroundColor: Colors.white,
            //actionsPadding: const EdgeInsets.all(0),
            contentPadding: const EdgeInsets.all(0),
            content: StatefulBuilder(
              builder: (context, setState)
              {
                return Container(
                  //color: Colors.black26,
                  child: ListView.builder(
                    itemCount: _lista.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index)
                    {
                      return Padding(
                        padding: const EdgeInsets.all(4),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(),
                            borderRadius: BorderRadius.all(Radius.circular(12))
                          ),
                          child: ListTile(
                            title: Text(_lista.elementAt(index)),
                            trailing: Wrap(
                              spacing: 12,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              //alignment: WrapAlignment.center,
                              //runAlignment: WrapAlignment.start,
                              children: [
                                IconButton(
                                  iconSize: 30,
                                  constraints: BoxConstraints(),
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(Icons.delete),
                                  splashRadius: 32,
                                  onPressed: () 
                                  {
                                    _showDeleteDialog(context: context, index: index).then((value) {setState(() {});});
                                  },
                                ),
                                IconButton(
                                  iconSize: 30,
                                  constraints: BoxConstraints(),
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(Icons.edit),
                                  splashRadius: 32,
                                  onPressed: ()
                                  {
                                    _showInputDialog(context: context, text: _lista.elementAt(index), listIndex: index);
                                  },
                                )
                              ]
                            )
                          )
                        ),
                      );
                      //return ListTile(
                        //title: Text("List item $index"),
                        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        /*
                        title: Card(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text("List item $index"),
                          )
                        )*/
                      //);
                    },
                  ),
                );
              } 
            )
            //content: widgetToDisplay,
            //insetPadding: EdgeInsets.symmetric(vertical: height * 0.35, horizontal: width * 0.1),
            //actions: (okButton == null)? null : [okButton]
          );
        }
      );
    }
  );
}













