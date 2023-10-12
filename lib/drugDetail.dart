import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:gmed/messaging.dart';
import 'model/drugDto.dart';
import 'model/measure.dart';

class DrugDetailPage extends StatefulWidget {
  const DrugDetailPage({super.key});

  @override
  State<DrugDetailPage> createState() => _DrugDetailState();
}

// ignore: must_be_immutable
class _DrugDetailState extends State<DrugDetailPage> {
  DrugDto? drug = DrugDto(name: "", leaflet: "");
  DateTime? dateFirst;
  DateTime? dateLast;
  Measure? _selectedMeasure;
  var nameTxt = TextEditingController();
  var noteTxt = TextEditingController();
  Messaging messaging = Messaging();
  String? leaflet;

  final Map<Measure, String> measures = {
    Measure.milliliter: 'mililitro(s)',
    Measure.capsule: 'capsula(s)',
    Measure.teaspoon: "colher(es) de chá",
    Measure.pill: "pilula(s)"
  };

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      drug = arguments['drug'];
    }

    if (drug.isDefinedAndNotNull && drug!.name!.isNotEmpty) {
      nameTxt.text = drug!.name ?? "";
      leaflet = drug!.leaflet;
    }

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
                    "detalhes",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: 'montserratLight'),
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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 35,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color(0xFF585858), width: 0.5)),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: TextField(
                              controller: nameTxt,
                              decoration: const InputDecoration(
                                  hintText: 'nome',
                                  hintStyle: TextStyle(
                                      fontFamily: 'montserratLight',
                                      color: Colors.grey),
                                  border: InputBorder.none)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color(0xFF585858), width: 0.5)),
                        child: DropdownButton(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            isExpanded: true,
                            value: _selectedMeasure,
                            underline: Container(),
                            hint: const Text("unidade de medida"),
                            items: Measure.values.map((Measure value) {
                              return DropdownMenuItem<Measure>(
                                value: value,
                                child: Text(measures[value]!),
                              );
                            }).toList(),
                            onChanged: (Measure? newValue) {
                              setState(() {
                                _selectedMeasure = newValue!;
                                nameTxt.text = nameTxt.text;
                              });
                            }),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color(0xFF585858), width: 0.5)),
                        child: TextField(
                          controller: noteTxt,
                          maxLines: 10,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(12, 10, 0, 0),
                              border: InputBorder.none,
                              hintText: "Observações",
                              hintStyle: TextStyle(fontSize: 15)),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                        onPressed: () => {confirm(context)},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA076F9),
                            fixedSize: const Size(240, 70)),
                        child: const Text(
                          'seguir',
                          style: TextStyle(
                              fontSize: 24, fontFamily: 'montserratLight'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  confirm(context) {
    if (nameTxt.text.isUndefinedOrNull || nameTxt.text.isEmpty) {
      messaging.showAlertDialog("é obrigatório definir um nome", context);
      return;
    }

    if (_selectedMeasure.isUndefinedOrNull) {
      messaging.showAlertDialog(
          "é obrigatório selecionar a unidade de medida", context);
      return;
    }

    drug = DrugDto(
        name: nameTxt.text,
        leaflet: leaflet,
        measure: _selectedMeasure,
        note: noteTxt.text);

    Navigator.pushNamed(context, "/drugPeriodConfig",
        arguments: {'drug': drug});
  }
}
