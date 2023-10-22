import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

      var formatter = DateFormat("dd/MM/yyyy");
      var measure = drugToAdd.measure.index;

      for (var date in dates) {
        for (var scheduler in schedulerQuantityList) {
          var hour = scheduler["hour"];
          var quantity = scheduler["quantity"];

          var drugData = {
            "name": drugToAdd.name,
            "initialDate": formatter.format(drugToAdd.initialDate),
            "finalDate": formatter.format(drugToAdd.finaldate),
            "leaflet": drugToAdd.leaflet,
            "measure": measure,
            "taken": false,
            "userId": auth.currentUser!.uid,
            "note": drugToAdd.note,
            "date": formatter.format(date),
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

  Future<List> getSchedulerAsync(String drugId, String date) async {
    var docs = firestore.collection("drugs");

    var drugs = await docs
        .where("date", isEqualTo: date)
        .where("drugId", isEqualTo: drugId)
        .get();

    var result = [];

    if (drugs.docs.isEmpty) {
      return result;
    }

    for (var drug in drugs.docs) {
      result.add({"hour": drug["hour"], "quantity": drug["quantity"]});
    }

    return result;
  }

  void updateDrug(Drug confirmedDrug, List<DateTime> dateList,
      List schedulerQuantityList, context, String drugDate) async {
    try {
      if (dateList.isEmpty) {
        throw Exception("erro ao tentar adicionar o medicamento");
      }

      if (schedulerQuantityList.isEmpty) {
        throw Exception("erro ao tentar adicionar o medicamento");
      }

      var formatter = DateFormat("dd/MM/yyyy");
      var measure = confirmedDrug.measure.index;

      var drugsToRemove = await firestore
          .collection("drugs")
          .where("date", isLessThanOrEqualTo: drugDate)
          .get();
      for (var drug in drugsToRemove.docs) {
        await firestore.collection("drugs").doc(drug.id).delete();
      }

      for (var date in dateList) {
        for (var scheduler in schedulerQuantityList) {
          var hour = scheduler["hour"];
          var quantity = scheduler["quantity"];

          var drugData = {
            "name": confirmedDrug.name,
            "initialDate": formatter.format(confirmedDrug.initialDate),
            "finalDate": formatter.format(confirmedDrug.finaldate),
            "leaflet": confirmedDrug.leaflet,
            "measure": measure,
            "taken": false,
            "userId": auth.currentUser!.uid,
            "note": confirmedDrug.note,
            "date": formatter.format(date),
            "hour": formatTimeOfDay(hour),
            "quantity": int.parse(quantity ?? "1"),
            "drugId": confirmedDrug.drugId
          };

          await firestore.collection("drugs").add(drugData);
        }
      }
    } catch (ex) {
      messaging.showAlertDialog(ex.toString(), context);
      rethrow;
    }
  }
}
