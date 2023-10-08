import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: implementation_imports
import 'package:flutter/src/material/time.dart';

class DrugSchedulerRepository {
  var firestore = FirebaseFirestore.instance;

  void addDrugSchedule(String drugId, List<DateTime> dateList,
      List<dynamic> schedulerQuantityList, context) async {
    if (dateList.isEmpty) {
      throw Exception("erro ao tentar adicionar o medicamento");
    }

    if (schedulerQuantityList.isEmpty) {
      throw Exception("erro ao tentar adicionar o medicamento");
    }

    for (var date in dateList) {
      for (var hour in schedulerQuantityList) {
        var data = {
          "drugId": drugId,
          "date": date,
          "hour": "${hour["hour"].minute}:${hour["minute"].minute}",
          "quantity": hour["quantity"]
        };

        await firestore.collection("scheduler").add(data);
      }
    }
  }
}
