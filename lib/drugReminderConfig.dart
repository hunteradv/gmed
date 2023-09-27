// ignore: file_names
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DrugReminderConfigPage extends StatefulWidget {
  const DrugReminderConfigPage({super.key});

  @override
  State<DrugReminderConfigPage> createState() => _DrugReminderConfigState();
}

class _DrugReminderConfigState extends State<DrugReminderConfigPage> {
  var byPeriod = true;
  var buttonByPeriod = const Color(0xFFA076F9);
  var buttonForLife = const Color(0xFFFFFFFF);
  var dateFirst = DateTime.now();
  var dateLast = DateTime.now().add(const Duration(days: 1));
  var dateFormat = DateFormat("dd/MM/yyyy");
  var showDateButtons = true;
  var optionSelected = 1;

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
                    "frequência",
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
                        "qual é a frequência de consumo?",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 50,
                            margin: const EdgeInsets.only(right: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: buttonByPeriod, blurRadius: 15)
                                ]),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF5F5F5)),
                              onPressed: () {
                                selectButton(1);
                              },
                              child: const Text(
                                "por período",
                                style: TextStyle(color: Color(0xFF585858)),
                              ),
                            ),
                          ),
                          Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: buttonForLife, blurRadius: 15)
                                ]),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF5F5F5)),
                                onPressed: () {
                                  selectButton(2);
                                },
                                child: const Text(
                                  "indeterminado",
                                  style: TextStyle(color: Color(0xFF585858)),
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Visibility(
                        visible: showDateButtons,
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
                      const SizedBox(height: 60),
                      SizedBox(
                        height: 50,
                        width: 300,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF63D5FF)),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, "/drugSchedulerConfig");
                          },
                          child: const Text(
                            "configurar frequência",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 200,
                      ),
                      ElevatedButton(
                        onPressed: () => {},
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

  selectButton(option) {
    if (option == 1) {
      optionSelected = 1;
      setState(() {
        buttonByPeriod = const Color(0xFFA076F9);
        buttonForLife = const Color(0xFFFFFFFF);
        showDateButtons = true;
      });
    } else {
      optionSelected = 2;
      setState(() {
        buttonByPeriod = const Color(0xFFFFFFFF);
        buttonForLife = const Color(0xFFA076F9);
        showDateButtons = false;
      });
    }
  }
}
