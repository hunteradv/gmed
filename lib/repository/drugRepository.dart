import 'dart:js';
import 'dart:js_interop';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../messaging.dart';
import '../model/drug.dart';

class DrugRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Messaging messaging = Messaging();

  void addDrug(Drug drugToAdd, List<DateTime> dates,
      List<dynamic> schedulerQuantityList, BuildContext context) async {
    try {
      if (dates.isEmpty) {
        throw Exception("erro ao tentar adicionar o medicamento");
      }

      if (schedulerQuantityList.isEmpty) {
        throw Exception("erro ao tentar adicionar o medicamento");
      }

      if (drugToAdd.isUndefinedOrNull) {
        throw Exception("erro ao tentar adicionar o medicamento");
      }

      var measure = drugToAdd.measure.index;

      for (var date in dates) {
        for (var scheduler in schedulerQuantityList) {
          var hour = scheduler["hour"];
          var quantity = scheduler["quantity"];

          var drugData = {
            "name": drugToAdd.name,
            "initialDate": drugToAdd.initialDate,
            "finalDate": drugToAdd.finaldate,
            "leaflet": drugToAdd.leaflet,
            "measure": measure,
            "taken": false,
            "userId": auth.currentUser!.uid,
            "note": drugToAdd.note,
            "date": date,
            "hour": formatTimeOfDay(hour),
            "quantity": int.parse(quantity ?? "1"),
            "drugId": drugToAdd.drugId
          };

          await firestore.collection("drugs").add(drugData);
        }
      }
    } catch (ex) {
      messaging.showAlertDialog(ex.toString(), context);
      rethrow;
    }
  }

  void deleteDrug(id, context) {
    firestore.collection('drugs').doc(id).delete();
  }

  String formatTimeOfDay(TimeOfDay time) {
    final String hour = time.hour.toString().padLeft(2, '0');
    final String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
