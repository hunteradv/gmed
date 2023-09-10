// ignore: file_names
import 'package:flutter/material.dart';
import 'model/drug.dart';
import 'model/measure.dart';

class DrugDetailPage extends StatefulWidget {
  const DrugDetailPage({super.key});

  @override
  State<DrugDetailPage> createState() => _DrugDetailState();
}

// ignore: must_be_immutable
class _DrugDetailState extends State<DrugDetailPage> {
  Drug? drug = Drug(name: "");
  Measure? _selectedItem;
  TextEditingController nameTxt = TextEditingController();

  final Map<Measure, String> measures = {
    Measure.milliliter: 'mililitros',
    Measure.capsule: 'capsula',
    Measure.teaspoon: "colher de chá"
  };

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      drug = arguments['drug'];
    }

    if (drug?.name != "") {
      nameTxt.text = drug!.name;
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
                        child: Column(children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: TextField(
                                controller: nameTxt,
                                decoration: const InputDecoration(
                                    hintText: 'nome',
                                    hintStyle: TextStyle(
                                        fontFamily: 'montserratLight',
                                        color: Colors.grey),
                                    border: InputBorder.none)),
                          )
                        ]),
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
                        child: Column(children: [
                          DropdownButton(
                              isExpanded: true,
                              value: _selectedItem,
                              hint: const Text("unidade de medida"),
                              items: Measure.values.map((Measure value) {
                                return DropdownMenuItem<Measure>(
                                  value: value,
                                  child: Text(measures[value]!),
                                );
                              }).toList(),
                              onChanged: (Measure? newValue) {
                                setState(() {
                                  _selectedItem = newValue!;
                                  nameTxt.text = nameTxt.text;
                                });
                              })
                        ]),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      ElevatedButton(
                        onPressed: () => {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA076F9),
                            fixedSize: const Size(240, 80)),
                        child: const Text(
                          'confirmar',
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
}
