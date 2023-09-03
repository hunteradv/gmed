import 'dart:async';

import 'package:flutter/material.dart';

class Messaging {
  void showSnackBar(String message, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showAlertDialog(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Container(
              alignment: Alignment.center,
              child: const Text(
                'erro',
              ),
            ),
            content: SizedBox(
              height: 150,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/warning.png',
                    width: 100,
                    height: 100,
                  ),
                  Text(message)
                ],
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Container(
                    alignment: Alignment.center, child: const Text('ok')),
              ),
            ],
          );
        });
  }

  Future<bool> confirmYesNo(String message, BuildContext context) async {
    Completer<bool> response = Completer<bool>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Não'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Sim'),
            ),
          ],
        );
      },
    ).then((value) => response.complete(value ?? false));

    return response.future;
  }
}
