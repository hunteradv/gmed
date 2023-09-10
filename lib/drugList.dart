// ignore: file_names
import 'dart:async';
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'messaging.dart';
import 'package:http/http.dart' as http;

import 'model/drug.dart';

// ignore: must_be_immutable
class DrugListPage extends StatelessWidget {
  DrugListPage({super.key});
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Messaging messaging = Messaging();

  final GlobalKey<AutoCompleteTextFieldState<String>> autoCompleteKey =
      GlobalKey();
  final TextEditingController _controller = TextEditingController();
  List<Drug> drugs = [];
  List<Drug> distinctDrugs = [];

  Future<List<Drug>> getDrug(filter) async {
    drugs = [];
    var url = "https://bula.vercel.app/pesquisar?nome=$filter";
    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    List<dynamic> data = jsonData["content"];

    for (var drugInList in data) {
      var drug = Drug(
          name: drugInList["nomeProduto"],
          leaflet: drugInList["idBulaPacienteProtegido"]);
      drugs.add(drug);
    }

    distinctDrugs = drugs.fold([], (List<Drug> accumulator, Drug drug) {
      if (!accumulator.any((existingDrug) =>
          existingDrug.name.toLowerCase() == drug.name.toLowerCase())) {
        accumulator.add(drug);
      }
      return accumulator;
    });

    return distinctDrugs;
  }

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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
              decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(20)),
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _controller,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 15,
                      ),
                      prefixIconConstraints:
                          BoxConstraints(maxHeight: 20, minWidth: 25),
                      border: InputBorder.none,
                      hintText: "Adicionar",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
                itemBuilder: (context, itemData) {
                  return ListTile(title: Text(itemData.toString()));
                },
                onSuggestionSelected: (suggestion) {
                  var selectedDrug = distinctDrugs
                      .where((element) => element.name == suggestion)
                      .first;

                  Navigator.pushNamed(context, '/drugDetail',
                      arguments: {'drug': selectedDrug});
                },
                suggestionsCallback: (pattern) async {
                  var list = await getDrug(pattern);
                  var strings = list.map((drug) => drug.name).toList();
                  return strings;
                },
                noItemsFoundBuilder: (context) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Nenhum resultado encontrado",
                      style: TextStyle(fontSize: 15),
                    ),
                  );
                },
              ),
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
                                          255, 223, 194, 194),
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
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: ((context) => DrugListPage())));
      });
    }
  }
}