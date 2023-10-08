// ignore: file_names
import 'package:flutter/material.dart';

class DrugSchedulerConfigPage extends StatefulWidget {
  const DrugSchedulerConfigPage({super.key});

  @override
  State<DrugSchedulerConfigPage> createState() => _DrugSchedulerConfigPage();
}

class _DrugSchedulerConfigPage extends State<DrugSchedulerConfigPage> {
  var scheduler = <TimeOfDay>[];
  var quantityControllers = <TextEditingController>[];

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
                      ListView(
                        shrinkWrap: true,
                        children: scheduler.map((hour) {
                          var quantityController = TextEditingController();
                          quantityControllers.add(quantityController);
                          return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                        size: 50,
                                      )),
                                  SizedBox(
                                    height: 40,
                                    width: 150,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white),
                                        onPressed: () async {
                                          final selectedTime =
                                              await showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now());

                                          setState(() {
                                            scheduler.remove(hour);
                                            scheduler.add(selectedTime!);
                                          });
                                        },
                                        child: Text(
                                          hour.format(context).toString(),
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
                                      borderRadius: BorderRadius.circular(5.0),
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
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          hintText: 'quantidade',
                                          hintStyle: TextStyle(
                                            fontFamily: 'montserratLight',
                                            color: Colors.grey,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        controller: quantityController,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(5, 8, 0, 0),
                                    child: const Text(
                                      "ml",
                                      style: TextStyle(fontSize: 22),
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
                              size: 50,
                            )),
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

  void confirm() {}
}
