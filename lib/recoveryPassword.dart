import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RecoveryPasswordPage extends StatelessWidget {
  TextEditingController emailTxt = TextEditingController();
  final BuildContext parentContext;

  RecoveryPasswordPage(this.parentContext, {super.key});
  void showAlertDialog(message) {
    showDialog(
        context: parentContext,
        builder: (context) {
          return AlertDialog(
            title: Container(
              alignment: Alignment.center,
              child: const Text(
                'erro',
              ),
            ),
            content: SizedBox(
              height: 150,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/warning.png',
                    width: 100,
                    height: 100,
                  ),
                  Text(message)
                ],
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Container(
                    alignment: Alignment.center, child: const Text('ok')),
              ),
            ],
          );
        });
  }

  Future sendMail(email) async {
    if (email.isEmpty) {
      return showAlertDialog('e-mail é obrigatório');
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // ignore: use_build_context_synchronously
      await Navigator.pushNamed(parentContext, '/login');
    } on Exception catch (e) {
      if (e.toString().contains('email address is badly formatted')) {
        showAlertDialog('e-mail inválido');
        return;
      }

      if (e.toString().contains('user-not-found')) {
        showAlertDialog('usuário não encontrado com o e-mail fornecido');
        return;
      }

      showAlertDialog(e.toString());
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                    "redefinir senha",
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
                        height: 60,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(35, 0, 19.5, 30),
                        child: const Center(
                          child: Text(
                              'enviaremos um e-mail com mais informações sobre a redefinição de sua senha',
                              style: TextStyle(
                                fontSize: 17,
                                color: Color(0xFF585858),
                              )),
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
                            boxShadow: const [
                              BoxShadow(
                                  color: Color(0xFFA076F9),
                                  blurRadius: 4,
                                  offset: Offset(0, 2))
                            ]),
                        child: Column(children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: TextField(
                                controller: emailTxt,
                                decoration: const InputDecoration(
                                    hintText: 'e-mail',
                                    hintStyle: TextStyle(
                                        fontFamily: 'montserratLight',
                                        color: Colors.grey),
                                    border: InputBorder.none)),
                          )
                        ]),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                        onPressed: () => sendMail(emailTxt.text),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA076F9),
                            fixedSize: const Size(240, 80)),
                        child: const Text(
                          'enviar e-mail',
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
