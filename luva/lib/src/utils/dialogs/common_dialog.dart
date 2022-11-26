import 'package:flutter/material.dart';

/// Generic Dialog that display a waiting message [loadingMessage]
/// until a future message [futureMessage] arrives to allow the user dismiss the dialog.
/// 
/// The [onPop] function is called after the dialog disappears

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