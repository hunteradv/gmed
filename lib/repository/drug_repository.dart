import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../messaging.dart';
import '../model/drug.dart';
import '../model/drugDto.dart';
import 'package:http/http.dart' as http;

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

  void deleteDrug(id, context) async {
    var drugsToRemove = await firestore
        .collection("drugs")
        .where("drugId", isEqualTo: id)
        .get();

    for (var drug in drugsToRemove.docs) {
      await firestore.collection("drugs").doc(drug.id).delete();
    }
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
      result.add({
        "hour": _parseTimeOfDay(drug["hour"]),
        "quantity": drug["quantity"]
      });
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
          .where("date", isGreaterThanOrEqualTo: drugDate)
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
            "quantity": int.parse(quantity.toString()),
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

  TimeOfDay _parseTimeOfDay(String timeString) {
    List<String> parts = timeString.split(':');

    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  String removeDiacritics(String str) {
    var withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;
  }

  Future<List<DrugDto>> getSearchAutoDrug(String searchText) async {
    List<DrugDto> drugs = [];
    var url = "https://bula.vercel.app/pesquisar?nome=$searchText";
    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    List<dynamic> data = jsonData["content"];

    for (var drugInList in data) {
      var drug = DrugDto(
          name: drugInList["nomeProduto"].toString().toLowerCase(),
          leaflet: drugInList["idBulaPacienteProtegido"]);
      drugs.add(drug);
    }

    List<DrugDto> distinctDrugs =
        drugs.fold([], (List<DrugDto> accumulator, DrugDto drug) {
      if (!accumulator.any((existingDrug) =>
          removeDiacritics((existingDrug.name ?? "").toLowerCase()) ==
          removeDiacritics((drug.name ?? "").toLowerCase()))) {
        accumulator.add(drug);
      }
      return accumulator;
    });

    return distinctDrugs;
  }
}
