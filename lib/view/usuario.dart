import 'package:flutter/material.dart';

class Usuario extends StatelessWidget {

  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      body: body(),
    );
  }

  Widget body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Insira o seu usuário'),
          Container(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            width: 400,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text('João Guilherme', style: TextStyle(
                  fontSize: 15,
                color: Colors.white,
              ),),
            ),
          ),
        ],
      ),
    );
  }
}
