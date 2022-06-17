import 'package:flutter/material.dart';

class  ResidentPaymentsCreatePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text(
          'Mi Orden',
          style: TextStyle(
              color: Colors.black
          ),
        ),
      ),
      body: Center(
        child: Text('ResidentPaymentsCreatePage'),
      ),
    );
  }
}
