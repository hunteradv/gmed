import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gmed/messaging.dart';
import 'package:gmed/model/measure.dart';
import 'package:gmed/notification_manager.dart';
import 'package:gmed/repository/drugMeasureRepository.dart';
import 'package:gmed/repository/drug_repository.dart';
import 'package:gmed/repository/leaflet_repository.dart';
import 'package:uuid/uuid.dart';
import 'model/drug.dart';
import 'model/drugDto.dart';

class DrugSchedulerConfigPage extends StatefulWidget {
  const DrugSchedulerConfigPage({super.key});

  @override
  State<DrugSchedulerConfigPage> createState() => _DrugSchedulerConfigPage();
}

class _DrugSchedulerConfigPage extends State<DrugSchedulerConfigPage> {
  List schedulerQuantityList = [];
  var drug = DrugDto();
  var messaging = Messaging();
  var drugRepository = DrugRepository();
  var uuid = const Uuid();
  var measureRepository = DrugMeasureRepository();
  var leafletRepository = LeafletRepository();
  var isEdit = false;
  var indexList = 0;
  final _notificationManager = NotificationManager();

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      drug = arguments['drug'];
      isEdit = arguments["isEdit"];
      if (drug.drugId != null) {
        var scheduler =
            await drugRepository.getSchedulerAsync(drug.drugId!, drug.date!);

        for (var item in scheduler) {
          item = {
            "hour": item["hour"],
            "quantity": item["quantity"],
            "index": indexList + 1
          };
        }
        setState(() {
          schedulerQuantityList = scheduler;
        });
      }
    }
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
                                children: schedulerQuantityList.map((item) {
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
                                                  schedulerQuantityList
                                                      .remove(item);
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
                                                  if (selectedTime != null) {
                                                    setState(() {
                                                      var quantity =
                                                          item["quantity"];
                                                      var indexSchedulerQuantityToReplace =
                                                          schedulerQuantityList
                                                              .indexWhere((element) =>
                                                                  element[
                                                                      "index"] ==
                                                                  item[
                                                                      "index"]);

                                                      if (!indexSchedulerQuantityToReplace
                                                          .isNegative) {
                                                        schedulerQuantityList[
                                                            indexSchedulerQuantityToReplace] = {
                                                          "hour": selectedTime,
                                                          "quantity": quantity,
                                                          "index": item["index"]
                                                        };
                                                      }
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                  item["hour"]
                                                      .format(context)
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Color(0xFF585858),
                                                      fontSize: 20),
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
                                              width: 110,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              child: TextField(
                                                onChanged: (value) {
                                                  setState(() {
                                                    var index =
                                                        schedulerQuantityList
                                                            .indexWhere((element) =>
                                                                element[
                                                                    "index"] ==
                                                                item["index"]);

                                                    schedulerQuantityList[
                                                        index] = {
                                                      "index": item["index"],
                                                      "hour": item["hour"],
                                                      "quantity": value
                                                    };
                                                  });
                                                },
                                                decoration:
                                                    const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(15),
                                                  hintText: 'quantidade',
                                                  hintStyle: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily:
                                                        'montserratLight',
                                                    color: Colors.grey,
                                                  ),
                                                  border: InputBorder.none,
                                                ),
                                                controller:
                                                    TextEditingController(
                                                        text: item["quantity"]
                                                            .toString()),
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
                                        indexList = indexList + 1;
                                        schedulerQuantityList.add({
                                          "index": indexList,
                                          "hour": TimeOfDay.now(),
                                          "quantity": ""
                                        });
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
    if (schedulerQuantityList.isEmpty) {
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

    var confirmedDrug = Drug(
        name: drug.name ?? "",
        leaflet: isEdit
            ? drug.leaflet
            : await leafletRepository.getLeafletLink(drug.leaflet ?? ""),
        measure: drug.measure ?? Measure.capsule,
        initialDate: drug.initialDate ?? DateTime.now(),
        finaldate:
            drug.finalDate ?? DateTime.now().add(const Duration(days: 1)),
        note: drug.note,
        drugId: isEdit ? drug.drugId! : uuid.v4());

    var dateList = <DateTime>[];

    for (DateTime date = confirmedDrug.initialDate;
        date.isBefore(confirmedDrug.finaldate) ||
            date.isAtSameMomentAs(confirmedDrug.finaldate);
        date = date.add(const Duration(days: 1))) {
      dateList.add(date);
    }

    if (isEdit) {
      drugRepository.updateDrug(
          confirmedDrug, dateList, schedulerQuantityList, context, drug.date!);
      await _notificationManager
          .cancelNotificationsByPayload(confirmedDrug.drugId);
      messaging.showSnackBar("medicamento atualizado com sucesso!", context);
    } else {
      drugRepository.addDrug(
          confirmedDrug, dateList, schedulerQuantityList, context);
      messaging.showSnackBar("medicamento cadastrado com sucesso!", context);
    }

    var schedulerCount = 0;
    for (var date in dateList) {
      for (var item in schedulerQuantityList) {
        schedulerCount = schedulerCount + 1;
        var hour = item["hour"];
        final scheduledTime =
            DateTime(date.year, date.month, date.day, hour.hour, hour.minute);
        _notificationManager.scheduleNotification(
            id: schedulerCount,
            title: "Lembre-se de tomar seu medicamento",
            body:
                "${confirmedDrug.name} - ${item["quantity"]}${measureRepository.getAbrevTranslatedMeasure(confirmedDrug.measure)}",
            scheduledNotificationDateTime: scheduledTime,
            payLoad: confirmedDrug.drugId);
      }
    }

    Navigator.pushNamedAndRemoveUntil(context, "/drugList", (route) => false);
  }

  String enumToString(Measure enumValue) {
    return enumValue.toString().split('.').last;
  }
}
