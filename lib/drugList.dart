import 'dart:async';
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gmed/repository/drugMeasureRepository.dart';
import 'package:gmed/repository/drug_repository.dart';
import 'package:intl/intl.dart';
import 'messaging.dart';
import 'package:http/http.dart' as http;
import 'model/drugDto.dart';
import 'model/measure.dart';

// ignore: must_be_immutable
class DrugListPage extends StatelessWidget {
  DrugListPage({super.key});
  var firestore = FirebaseFirestore.instance;
  var messaging = Messaging();

  final GlobalKey<AutoCompleteTextFieldState<String>> autoCompleteKey =
      GlobalKey();
  final _controller = TextEditingController();
  var repository = DrugRepository();
  List<DrugDto> drugs = [];
  List<DrugDto> distinctDrugs = [];
  var measureRepository = DrugMeasureRepository();
  var auth = FirebaseAuth.instance;
  var dateNow = DateTime.now();

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

  Future<List<DrugDto>> getDrug(filter) async {
    drugs = [];
    var url = "https://bula.vercel.app/pesquisar?nome=$filter";
    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    List<dynamic> data = jsonData["content"];

    for (var drugInList in data) {
      var drug = DrugDto(
          name: drugInList["nomeProduto"].toString().toLowerCase(),
          leaflet: drugInList["idBulaPacienteProtegido"]);
      drugs.add(drug);
    }

    distinctDrugs = drugs.fold([], (List<DrugDto> accumulator, DrugDto drug) {
      if (!accumulator.any((existingDrug) =>
          removeDiacritics((existingDrug.name ?? "").toLowerCase()) ==
          removeDiacritics((drug.name ?? "").toLowerCase()))) {
        accumulator.add(drug);
      }
      return accumulator;
    });

    return distinctDrugs;
  }

  @override
  Widget build(BuildContext context) {
    var dateFormat = DateFormat("dd/MM/yyyy");
    var dateFormated = dateFormat.format(dateNow);
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
                      .where((element) =>
                          element.name!.toLowerCase() == suggestion)
                      .first;

                  Navigator.pushNamed(context, '/drugDetail',
                      arguments: {'drug': selectedDrug, "isEdit": false});
                },
                suggestionsCallback: (pattern) async {
                  var list = await getDrug(pattern);
                  var strings =
                      list.map((drug) => drug.name!.toLowerCase()).toList();
                  return strings;
                },
                noItemsFoundBuilder: (context) {
                  return const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
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
                    stream: firestore
                        .collection("drugs")
                        .where("userId", isEqualTo: auth.currentUser!.uid)
                        .where("date", isEqualTo: dateFormated)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      var drugs = snapshot.data!.docs;

                      return ListView(
                        shrinkWrap: true,
                        children: [
                          Column(
                            children: [
                              const Text("não tomados",
                                  style: TextStyle(fontSize: 20)),
                              ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: drugs
                                    .where((drug) {
                                      bool taken = drug.data()['taken'];
                                      return !taken;
                                    })
                                    .map((drug) => Dismissible(
                                          onDismissed: (direction) =>
                                              deleteDrug(drug.id, context),
                                          key: Key(drug.id),
                                          child: Card(
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            child: ListTile(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, '/drugDetail',
                                                    arguments: {
                                                      "drug": drug,
                                                      "isEdit": true
                                                    });
                                              },
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    drug['name'].length <= 15
                                                        ? drug['name']
                                                        : drug['name']
                                                                .substring(
                                                                    0, 15) +
                                                            '...',
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        drug["hour"],
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15),
                                                      ),
                                                      const Text(" | "),
                                                      Text(
                                                        drug["quantity"]
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        measureRepository
                                                            .getAbrevTranslatedMeasure(
                                                                Measure.values[drug[
                                                                    "measure"]]),
                                                        style: const TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              trailing: Checkbox(
                                                onChanged: (bool? value) =>
                                                    setTaken(drug.id),
                                                value: drug['taken'],
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),
                          Column(
                            children: [
                              const Text("tomados",
                                  style: TextStyle(fontSize: 20)),
                              ListView(
                                shrinkWrap: true,
                                physics:
                                    const NeverScrollableScrollPhysics(), // Impede a rolagem desta lista
                                children: drugs
                                    .where((drug) {
                                      bool taken = drug.data()['taken'];
                                      return taken;
                                    })
                                    .map((drug) => Dismissible(
                                          onDismissed: (direction) =>
                                              deleteDrug(drug.id, context),
                                          key: Key(drug.id),
                                          child: Card(
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            child: ListTile(
                                              onTap: () => {
                                                Navigator.pushNamed(
                                                    context, '/drugDetail',
                                                    arguments: {
                                                      "drug": drug,
                                                      "isEdit": true
                                                    })
                                              },
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    drug['name'].length <= 15
                                                        ? drug['name']
                                                        : drug['name']
                                                                .substring(
                                                                    0, 15) +
                                                            '...',
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        drug["hour"],
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15),
                                                      ),
                                                      const Text(" | "),
                                                      Text(
                                                        drug["quantity"]
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        measureRepository
                                                            .getAbrevTranslatedMeasure(
                                                                Measure.values[drug[
                                                                    "measure"]]),
                                                        style: const TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              trailing: Checkbox(
                                                onChanged: (bool? value) => {},
                                                value: drug["taken"],
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ],
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
                onPressed: () {
                  Navigator.pushNamed(context, "/drugDetail",
                      arguments: {"isEdit": false});
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA076F9),
                    fixedSize: const Size(60, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                child: const Icon(Icons.add),
              )
            ],
          ),
        ),
      ),
    );
  }

  deleteDrug(String id, BuildContext context) async {
    var response = await messaging.confirmYesNo(
        "Tem certeza que deseja excluir? ao confirmar, todos os agendamentos desse medicamento serão excluidos",
        context);

    if (response == true) {
      // ignore: use_build_context_synchronously
      repository.deleteDrug(id, context);
      // ignore: use_build_context_synchronously
      messaging.showSnackBar("medicamento excluido", context);
    } else {
      // ignore: use_build_context_synchronously
      messaging.showSnackBar("operação cancelada", context);
      Timer(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: ((context) => DrugListPage())));
      });
    }
  }

  void setTaken(id) {
    firestore.collection('drugs').doc(id).update({'taken': true});
  }
}
