import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xFFF5F5F5),
                  Color(0xFFBD29F1),
                  Color(0xFFBD29F1),
                  Color(0xFFF5F5F5)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.3, 0.6, 1.0])),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: const Text(
                  'GMed',
                  style: TextStyle(
                      color: Color(0xFF585858),
                      fontSize: 50,
                      fontFamily: 'montserratLight'),
                ),
              ),
              const Text(
                'ajudando a cuidar melhor de você',
                style: TextStyle(
                    color: Color(0xFF585858),
                    fontSize: 20,
                    fontFamily: 'montserratLight'),
              ),
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                'assets/images/homeMedicine.png',
                width: 400,
                height: 180,
              ),
              const SizedBox(
                height: 80,
              ),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA076F9),
                    fixedSize: const Size(240, 80)),
                child: const Text(
                  'entrar',
                  style: TextStyle(fontSize: 30, fontFamily: 'montserratLight'),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/register'),
                  child: const Text(
                    'não tem uma conta? clique aqui',
                    style: TextStyle(
                        color: Color(0xFF585858),
                        fontSize: 17,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, '/recoveryPassword'),
                  child: const Text(
                    'esqueceu a senha?',
                    style: TextStyle(
                        color: Color(0xFF585858),
                        fontSize: 17,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
