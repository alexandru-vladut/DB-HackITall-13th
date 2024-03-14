import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';

class ReturoView extends StatefulWidget {
  @override
  _ReturoViewState createState() => _ReturoViewState();
}

class _ReturoViewState extends State<ReturoView> {

     @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.loading,
        text: 'Se încarcă...',
        autoCloseDuration: const Duration(seconds: 3),
      ).then((_) {
        Future.delayed(const Duration(seconds: 1), () {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            title: 'Succes!',
            text: 'Cashback-ul pentru această reciclare îți va fi acordat în zilele următoare.',
          );
        });
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3AAE71),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset('assets/images/returo.jpg'),
            const SizedBox(height: 20),
            const Text(
              'Codul cardului tau GreenGo:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/qr-code.png',
              width: 400,
              height: 400,
            ),
          ],
        ),
      ),
    );
  }
}
