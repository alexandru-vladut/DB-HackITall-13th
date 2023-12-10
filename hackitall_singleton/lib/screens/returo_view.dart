import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter_banking_app/views/home.dart';

class ReturoView extends StatefulWidget {
  @override
  _ReturoViewState createState() => _ReturoViewState();
}

class _ReturoViewState extends State<ReturoView> {

     @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 10), () {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.loading,
        text: 'Se încarcă...',
        autoCloseDuration: Duration(seconds: 3),
      ).then((_) {
        Future.delayed(Duration(seconds: 3), () {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            text: 'Operația a fost un succes!',
          );
        });
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3AAE71),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset('assets/g4.jpg'),
            SizedBox(height: 20),
            Text(
              'Codul cardului tau GreenGo:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Image.asset(
              'assets/qr-code.png',
              width: 400,
              height: 400,
            ),
          ],
        ),
      ),
    );
  }
}
