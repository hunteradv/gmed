import 'dart:js_interop';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gmed/messaging.dart';
import 'package:gmed/model/measure.dart';
import 'package:gmed/repository/drugMeasureRepository.dart';
import 'package:gmed/repository/drugRepository.dart';
import 'package:uuid/uuid.dart';
import 'model/drug.dart';
import 'model/drugDto.dart';

class DrugSchedulerConfigPage extends StatefulWidget {
  const DrugSchedulerConfigPage({super.key});

  @override
  State<DrugSchedulerConfigPage> createState() => _DrugSchedulerConfigPage();
}

class _DrugSchedulerConfigPage extends State<DrugSchedulerConfigPage> {
  var scheduler = <TimeOfDay>[];
  var quantityControllers = <TextEditingController>[];
  List schedulerQuantityList = [];
  var drug = DrugDto();
  var messaging = Messaging();
  var drugRepository = DrugRepository();
  var uuid = const Uuid();
  var measureRepository = DrugMeasureRepository();

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
                    "horários",
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
                      const Center(
                        child: Text(
                          "em quais horários vai tomar o medicamento?",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView(
                                shrinkWrap: true,
                                children: scheduler.map((hour) {
                                  var quantityController =
                                      TextEditingController();
                                  quantityControllers.add(quantityController);
                                  return Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  shape: const CircleBorder()),
                                              onPressed: () {
                                                setState(() {
                                                  scheduler.remove(hour);
                                                });
                                              },
                                              child: const Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                                size: 40,
                                              )),
                                          SizedBox(
                                            height: 40,
                                            width: 100,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white),
                                                onPressed: () async {
                                                  final selectedTime =
                                                      await showTimePicker(
                                                          context: context,
                                                          initialTime:
                                                              TimeOfDay.now());

                                                  setState(() {
                                                    var indexToReplace =
                                                        scheduler.indexWhere(
                                                            (element) =>
                                                                element ==
                                                                hour);

                                                    if (indexToReplace
                                                            .isDefinedAndNotNull &&
                                                        !indexToReplace
                                                            .isNegative) {
                                                      scheduler[
                                                              indexToReplace] =
                                                          selectedTime ??
                                                              TimeOfDay.now();
                                                    }

                                                    var indexSchedulerQuantityToReplace =
                                                        schedulerQuantityList
                                                            .indexWhere(
                                                                (element) =>
                                                                    element ==
                                                                    hour);

                                                    if (indexSchedulerQuantityToReplace
                                                            .isDefinedAndNotNull &&
                                                        !indexSchedulerQuantityToReplace
                                                            .isNegative) {
                                                      schedulerQuantityList[
                                                          indexSchedulerQuantityToReplace] = {
                                                        "hour": selectedTime,
                                                        "quantity":
                                                            quantityController
                                                                .text
                                                      };
                                                    }
                                                  });
                                                },
                                                child: Text(
                                                  hour
                                                      .format(context)
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Color(0xFF585858),
                                                      fontSize: 25),
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Material(
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            borderOnForeground: true,
                                            child: Container(
                                              width: 122,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              child: TextField(
                                                onChanged: (value) => {
                                                  schedulerQuantityList.add({
                                                    "hour": hour,
                                                    "quantity":
                                                        quantityController.text
                                                  })
                                                },
                                                decoration:
                                                    const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(15),
                                                  hintText: 'quantidade',
                                                  hintStyle: TextStyle(
                                                    fontFamily:
                                                        'montserratLight',
                                                    color: Colors.grey,
                                                  ),
                                                  border: InputBorder.none,
                                                ),
                                                controller: quantityController,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r'[0-9]')),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                5, 8, 0, 0),
                                            child: Text(
                                              measureRepository
                                                  .getAbrevTranslatedMeasure(
                                                      drug.measure ??
                                                          Measure.capsule),
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                          )
                                        ],
                                      ));
                                }).toList(),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape: const CircleBorder()),
                                    onPressed: () {
                                      setState(() {
                                        scheduler.add(TimeOfDay.now());
                                      });
                                    },
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 40,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          confirm(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA076F9),
                            fixedSize: const Size(240, 70)),
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

  void confirm(context) async {
    if (scheduler.isEmpty) {
      messaging.showAlertDialog(
          "é necessário adicionar no mínimo 1 horário para lembrete", context);
      return;
    }

    var quantityList =
        schedulerQuantityList.map((e) => e["quantity"].toString()).toList();
    var hourList =
        schedulerQuantityList.map((e) => e["hour"].toString()).toList();

    if (quantityList.length < hourList.length) {
      messaging.showAlertDialog(
          "é necessário inserir a quantidade em todos os registros", context);
    }

    var drugId = uuid.v4();

    var confirmedDrug = Drug(
        name: drug.name ?? "",
        leaflet: drug.leaflet,
        measure: drug.measure ?? Measure.capsule,
        initialDate: drug.initialDate ?? DateTime.now(),
        finaldate:
            drug.finalDate ?? DateTime.now().add(const Duration(days: 1)),
        note: drug.note,
        drugId: drugId);

    var dateList = <DateTime>[];

    for (DateTime date = confirmedDrug.initialDate;
        date.isBefore(confirmedDrug.finaldate) ||
            date.isAtSameMomentAs(confirmedDrug.finaldate);
        date = date.add(const Duration(days: 1))) {
      dateList.add(date);
    }

    drugRepository.addDrug(
        confirmedDrug, dateList, schedulerQuantityList, context);

    Navigator.pushNamedAndRemoveUntil(context, "/drugList", (route) => false);
    messaging.showSnackBar("medicamento cadastrado com sucesso!", context);
  }

  String enumToString(Measure enumValue) {
    return enumValue.toString().split('.').last;
  }
}
