// ignore: file_names
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'messaging.dart';

// ignore: must_be_immutable
class MedicineListPage extends StatelessWidget {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Messaging messaging = Messaging();

  MedicineListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFA076F9),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "medicamentos do dia",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 60, 30, 20),
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: firestore.collection('drugs').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      var drugs = snapshot.data!.docs;

                      return ListView(
                        shrinkWrap: true,
                        children: drugs
                            .map((drug) => Dismissible(
                                  onDismissed: (direction) =>
                                      deleteDrug(drug.id, context),
                                  key: Key(drug.id),
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: const Color.fromARGB(
                                          255, 233, 233, 233),
                                    ),
                                    child: ListTile(
                                      onTap: () {},
                                      title: Text(drug['name']),
                                    ),
                                  ),
                                ))
                            .toList(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 80,
        child: Container(
          margin: const EdgeInsets.fromLTRB(35, 0, 35, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA076F9),
                    fixedSize: const Size(60, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                child: const Icon(Icons.camera_alt),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA076F9),
                    fixedSize: const Size(60, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }

  deleteDrug(String id, BuildContext context) async {
    var response = await messaging.confirmYesNo(
        "Tem certeza que deseja excluir?", context);

    if (response == true) {
      firestore.collection('drugs').doc(id).delete();
      // ignore: use_build_context_synchronously
      messaging.showSnackBar("medicamento excluido", context);
    } else {
      // ignore: use_build_context_synchronously
      messaging.showSnackBar("operação cancelada", context);
      // ignore: use_build_context_synchronously
      Timer(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => MedicineListPage())));
      });
    }
  }
}
