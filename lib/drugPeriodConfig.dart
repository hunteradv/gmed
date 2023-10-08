// ignore: file_names
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'messaging.dart';
import 'model/drugDto.dart';

class DrugPeriodConfigPage extends StatefulWidget {
  const DrugPeriodConfigPage({super.key});

  @override
  State<DrugPeriodConfigPage> createState() => _DrugPeriodConfigState();
}

class _DrugPeriodConfigState extends State<DrugPeriodConfigPage> {
  var byPeriod = true;
  var dateFirst = DateTime.now();
  var dateLast = DateTime.now().add(const Duration(days: 1));
  var dateFormat = DateFormat("dd/MM/yyyy");
  Messaging messaging = Messaging();
  late DrugDto drug;

  Future<void> _selectDateFirst(BuildContext context) async {
    var pickedDate = await showDatePicker(
        context: context,
        initialDate: dateFirst,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        locale: const Locale("pt"));
    if (pickedDate != null && pickedDate != dateFirst) {
      setState(() {
        dateFirst = pickedDate;
      });
    }
  }

  Future<void> _selectDateLast(BuildContext context) async {
    var pickedDate = await showDatePicker(
        context: context,
        initialDate: dateLast,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        locale: const Locale("pt"));
    if (pickedDate != null && pickedDate != dateLast) {
      setState(() {
        dateLast = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      drug = arguments['drug'];
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
                    "período",
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
                        height: 40,
                        width: double.infinity,
                      ),
                      const Text(
                        "qual é o período de consumo?",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(height: 30),
                      Visibility(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              width: 195,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                onPressed: () => _selectDateFirst(context),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      "início",
                                      style: TextStyle(
                                          color: Color(0xFF585858),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(dateFormat.format(dateFirst),
                                        style: const TextStyle(
                                          color: Color(0xFF585858),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            Container(
                                width: 195,
                                height: 50,
                                margin: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: () {
                                    _selectDateLast(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text(
                                        "fim",
                                        style: TextStyle(
                                            color: Color(0xFF585858),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        dateFormat.format(dateLast),
                                        style: const TextStyle(
                                            color: Color(0xFF585858)),
                                      )
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 150,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          confirm();
                        },
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

  confirm() {
    if (dateFirst.isUndefinedOrNull || dateLast.isUndefinedOrNull) {
      messaging.showAlertDialog("obrigatório inserir as datas", context);
      return;
    }

    if (dateFirst.isAfter(dateLast)) {
      messaging.showAlertDialog(
          "a data inicial não pode ser maior que a data final", context);
      return;
    }

    drug.initialDate = dateFirst;
    drug.finalDate = dateLast;

    Navigator.pushNamed(context, "/drugSchedulerConfig",
        arguments: {'drug': drug});
  }
}
