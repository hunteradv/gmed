// ignore: file_names
import 'package:flutter/material.dart';

class DrugReminderConfigPage extends StatefulWidget {
  const DrugReminderConfigPage({super.key});

  @override
  State<DrugReminderConfigPage> createState() => _DrugReminderConfigState();
}

class _DrugReminderConfigState extends State<DrugReminderConfigPage> {
  var byPeriod = true;
  var buttonByPeriod = const Color(0xFFFFFFFF);
  var buttonForLife = const Color(0xFFFFFFFF);
  var dateFirst = DateTime.now();
  var dateLast = DateTime.now();

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
                      Row(
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
                              onPressed: () {},
                              child: Row(
                                children: [
                                  const Text(
                                    "início",
                                    style: TextStyle(
                                        color: Color(0xFF585858),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(dateFirst.toString(),
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
                                onPressed: () {},
                                child: const Row(
                                  children: [
                                    Text(
                                      "fim",
                                      style: TextStyle(
                                          color: Color(0xFF585858),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      )
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
      setState(() {
        buttonByPeriod = const Color(0xFFA076F9);
        buttonForLife = const Color(0xFFFFFFFF);
      });
    } else {
      setState(() {
        buttonForLife = const Color(0xFFA076F9);
        buttonByPeriod = const Color(0xFFFFFFFF);
      });
    }
  }
}
