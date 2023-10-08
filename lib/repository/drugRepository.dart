import 'dart:js';
import 'dart:js_interop';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import '../messaging.dart';
import '../model/drug.dart';

class DrugRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Messaging messaging = Messaging();

  Future<String> addDrug(Drug drugToAdd, BuildContext context) async {
    try {
      if (drugToAdd.isUndefinedOrNull) {
        throw Exception("erro ao tentar adicionar o medicamento");
      }

      var measure = drugToAdd.measure.index;

      var drugData = {
        "name": drugToAdd.name,
        "initialDate": drugToAdd.initialDate,
        "finalDate": drugToAdd.finaldate,
        "leaflet": drugToAdd.leaflet,
        "measure": measure,
        "taken": false,
        "userId": auth.currentUser!.uid,
        "note": drugToAdd.note
      };

      DocumentReference<Map<String, dynamic>> docReference =
          await firestore.collection("drugs").add(drugData);

      return docReference.id;
    } catch (ex) {
      messaging.showAlertDialog(ex.toString(), context);
      rethrow;
    }
  }

  void deleteDrug(id, context) {
    firestore.collection('drugs').doc(id).delete();
  }
}
