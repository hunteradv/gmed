import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  TextEditingController passwordTxt = TextEditingController();
  TextEditingController confirmPasswordTxt = TextEditingController();
  TextEditingController emailTxt = TextEditingController();
  TextEditingController nameTxt = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    passwordTxt = TextEditingController();
    confirmPasswordTxt = TextEditingController();
  }

  @override
  void dispose() {
    passwordTxt.dispose();
    confirmPasswordTxt.dispose();
    super.dispose();
  }

  void showAlertDialog(message) {
    showDialog(
        context: context,
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

  void confirm() async {
    if (emailTxt.value.text.isEmpty) {
      showAlertDialog('e-mail não pode ser vazio');
      return;
    }

    if (passwordTxt.value.text.isEmpty) {
      showAlertDialog('senha não pode ser vazia');
      return;
    }

    if (confirmPasswordTxt.value.text.isEmpty) {
      showAlertDialog('confirmação de senha não pode ser vazia');
      return;
    }

    if (passwordTxt.value.text != confirmPasswordTxt.value.text) {
      showAlertDialog('senhas não podem ser diferentes');
      return;
    }

    if (passwordTxt.value.text.length < 6) {
      showAlertDialog('senha precisa ter no mínimo 6 caracteres');
      return;
    }

    if (nameTxt.value.text.isEmpty) {
      showAlertDialog('nome não pode ser vazio');
      return;
    }

    try {
      await auth.createUserWithEmailAndPassword(
          email: emailTxt.text, password: passwordTxt.text);

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushNamed('/login');
    } on Exception catch (e) {
      if (e.toString().contains('wrong-password')) {
        showAlertDialog('senha incorreta');
        return;
      }

      if (e.toString().contains('email address is badly formatted')) {
        showAlertDialog('e-mail inválido');
        return;
      }

      showAlertDialog(e.toString());
      return;
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
                    "cadastrar",
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
                        height: 30,
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
                        child: Row(children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: TextField(
                                  controller: passwordTxt,
                                  obscureText: hidePassword,
                                  decoration: const InputDecoration(
                                      hintText: 'senha',
                                      hintStyle: TextStyle(
                                          fontFamily: 'montserratLight',
                                          color: Colors.grey),
                                      border: InputBorder.none)),
                            ),
                          ),
                          IconButton(
                              onPressed: () => setState(() {
                                    hidePassword = !hidePassword;
                                  }),
                              icon: const Icon(
                                Icons.visibility,
                                color: Color(0xFF585858),
                              ))
                        ]),
                      ),
                      const SizedBox(
                        height: 30,
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
                        child: Row(children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: TextField(
                                  controller: confirmPasswordTxt,
                                  obscureText: hideConfirmPassword,
                                  decoration: const InputDecoration(
                                      hintText: 'confirme a senha',
                                      hintStyle: TextStyle(
                                          fontFamily: 'montserratLight',
                                          color: Colors.grey),
                                      border: InputBorder.none)),
                            ),
                          ),
                          IconButton(
                              onPressed: () => setState(() {
                                    hideConfirmPassword = !hideConfirmPassword;
                                  }),
                              icon: const Icon(
                                Icons.visibility,
                                color: Color(0xFF585858),
                              ))
                        ]),
                      ),
                      const SizedBox(
                        height: 30,
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
                                controller: nameTxt,
                                decoration: const InputDecoration(
                                    hintText: 'seu nome',
                                    hintStyle: TextStyle(
                                        fontFamily: 'montserratLight',
                                        color: Colors.grey),
                                    border: InputBorder.none)),
                          )
                        ]),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      ElevatedButton(
                        onPressed: () => confirm(),
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
