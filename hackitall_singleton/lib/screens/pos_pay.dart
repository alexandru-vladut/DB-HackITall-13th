// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackitall_singleton/github_utilities/repo/repository.dart';
import 'package:hackitall_singleton/github_utilities/utils/size_config.dart';
import 'package:hackitall_singleton/github_utilities/widgets/buttons.dart';
import 'package:hackitall_singleton/github_utilities/widgets/my_app_bar.dart';
import 'package:flutter_credit_card_ui/flutter_credit_card_ui.dart';
import 'package:gap/gap.dart';
import 'package:hackitall_singleton/my_utilities/animation/slideleft_toright.dart';
import 'package:hackitall_singleton/my_utilities/constants.dart';
import 'package:hackitall_singleton/screens/bottom_nav.dart';

class PosPay extends StatefulWidget {
  const PosPay({Key? key}) : super(key: key);

  @override
  _PosPayState createState() => _PosPayState();
}

class _PosPayState extends State<PosPay> {

  final user = FirebaseAuth.instance.currentUser!;
  List<String> userDetails = [''];
  List<String> creditCardDetails = ['', '', '', '', '', ''];
  List<String> ecoCardDetails = ['', '', '', '', ''];
  String cardType = "credit";
  bool visibleDetails = false;
  List<bool> hasCard = [false];

  TextEditingController amountController = TextEditingController(text: '0.00');
  String selectedVendor = 'Nike';
  List vendorList = [];
  List<String> vendorNameList = [];
  void getVendorsList() async {

    vendorList = [];
    vendorNameList = [];
    amountController = TextEditingController(text: '0.00');
    
    dynamic vendorCollection;
    if (cardType == 'credit') {
      vendorCollection = await FirebaseFirestore.instance.collection('Vendors').get();
    } else {
      vendorCollection = await FirebaseFirestore.instance.collection('Vendors').where('EcoFriendly', isEqualTo: true).get();
    }

    for (int i = 0; i < vendorCollection.docs.length; i++) {

      final vendorDoc = vendorCollection.docs[i];
      Map vendor = {
        'CashBack': vendorDoc.get('CashBack').toString(),
        'Category': vendorDoc.get('Category').toString(),
        'EcoFriendly': vendorDoc.get('EcoFriendly').toString(),
        'Name': vendorDoc.get('Name').toString(),
      };
      vendorList.add(vendor);
      vendorNameList.add(vendorDoc.get('Name').toString());
    }

    selectedVendor = "Nike";

    setState(() {});
  }

  void payOnPOS() async {

    loadingAlert(context);

    String isEcoFriendly = "";
    double cashBackPercent = 0;
    for (int i = 0; i < vendorList.length; i++) {
      final currentVendor = vendorList[i];
      if (currentVendor['Name'] == selectedVendor) {
        isEcoFriendly = currentVendor['EcoFriendly'];
        cashBackPercent = double.parse(currentVendor['CashBack']);
        break;
      }
    }

    // ================ SENDER ===================================
    var senderDocSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('UID', isEqualTo: user.uid)
        .get();

    final senderDoc = senderDocSnapshot.docs[0];
    List senderTransactionsArray = senderDoc.get("transactions") as List;
    senderTransactionsArray.add({
      'amount': amountController.text,
      'senderName': userDetails[0],
      'receiverName': selectedVendor,
      'time': Timestamp.fromDate(DateTime.now()),
      'type': "vendor",
    });

    if (cardType == 'credit' && isEcoFriendly == 'false') {

      double senderSold = senderDoc.get("creditCard")['sold'].toDouble();
      senderSold = senderSold - double.parse(amountController.text);

      Map senderCreditCard = senderDoc.get("creditCard") as Map;
      senderCreditCard['sold'] = senderSold;

      if (senderDocSnapshot.docs.isNotEmpty) {
        await senderDocSnapshot.docs.first.reference.update({
          'creditCard': senderCreditCard,
          'transactions': senderTransactionsArray,
        });
      }
    } else if (cardType == 'credit' && isEcoFriendly == 'true') {

      double senderSold = senderDoc.get("creditCard")['sold'].toDouble();
      senderSold = senderSold - double.parse(amountController.text);

      Map senderCreditCard = senderDoc.get("creditCard") as Map;
      senderCreditCard['sold'] = senderSold;

      double cashBackReward = cashBackPercent * double.parse(amountController.text) / 100;
      double senderEcoSold = senderDoc.get("ecoCard")['sold'].toDouble();
      senderEcoSold = senderEcoSold + cashBackReward;

      Map senderEcoCard = senderDoc.get("ecoCard") as Map;
      senderEcoCard['sold'] = senderEcoSold;
      
      if (senderDocSnapshot.docs.isNotEmpty) {
        await senderDocSnapshot.docs.first.reference.update({
          'creditCard': senderCreditCard,
          'ecoCard': senderEcoCard,
          'transactions': senderTransactionsArray,
        });
      }
    } else if (cardType == 'eco') {

      double senderEcoSold = senderDoc.get("ecoCard")['sold'].toDouble();
      senderEcoSold = senderEcoSold - double.parse(amountController.text);

      Map senderEcoCard = senderDoc.get("ecoCard") as Map;
      senderEcoCard['sold'] = senderEcoSold;

      if (senderDocSnapshot.docs.isNotEmpty) {
        await senderDocSnapshot.docs.first.reference.update({
          'ecoCard': senderEcoCard,
          'transactions': senderTransactionsArray,
        });
      }
    }

    Navigator.push(context, SlideLeftToRight(page: const BottomNav()));
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUserDetails(user, userDetails, ['Nume'], () {setState(() {});});
    getCreditCardDetails(user, creditCardDetails, hasCard, () {setState(() {});});
    getEcoCardDetails(user, ecoCardDetails, () {setState(() {});});
    getVendorsList();
  }

  @override
  Widget build(BuildContext context) {

    print(vendorList);
    print(vendorNameList);

    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Repository.bgColor(context),
      appBar: myAppBar(title: 'POS Payment', implyLeading: false, context: context),
      bottomSheet: Container(
        color: Repository.bgColor(context),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: elevatedButton(
          color: Repository.selectedItemColor(context),
          context: context,
          callback: () {
            payOnPOS();
          },
          text: 'Pay',
        ),
      ),
      body: SingleChildScrollView( // Use SingleChildScrollView
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom), // Adjust for keyboard
        child: Column( // Use Column instead of ListView
          children: [

            (cardType == "credit")
            ? CreditCardWidget(
                cardDecoration: CardDecoration(
                  showBirdImage: true,
                ),
                cvvText: (visibleDetails) ? creditCardDetails[0] : "***",
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 106, 106, 106),
                    Color.fromARGB(255, 208, 208, 208),
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
                cardHolder: "Mr. ${creditCardDetails[2]}",
                cardNumber: (visibleDetails) ? creditCardDetails[3] : creditCardDetails[3].replaceRange(5, 14, "**** ****"),
                cardExpiration: creditCardDetails[1],
                cardtype: (creditCardDetails[4] == 'Visa') ? CardType.visa : CardType.masterCard,
                color: Colors.red,
              )

            : CreditCardWidget(
                cardDecoration: CardDecoration(
                  showBirdImage: true,
                ),
                cvvText: (visibleDetails) ? ecoCardDetails[0] : "***",
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 28, 143, 43),
                    Color.fromARGB(255, 4, 62, 9),
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
                cardHolder: "Mr. ${ecoCardDetails[2]}",
                cardNumber: (visibleDetails) ? ecoCardDetails[3] : ecoCardDetails[3].replaceRange(5, 14, "**** ****"),
                cardExpiration: ecoCardDetails[1],
                cardtype: CardType.rupay,
                color: Colors.red,
              ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            visibleDetails = !visibleDetails;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(255, 161, 161, 161).withOpacity(0.15),
                          ),
                          // child: Image.asset('assets/images/qr_code.png', width: 24), // Adjusted image size
                          child: Icon(
                            (visibleDetails) ? Icons.visibility_off : Icons.visibility,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (cardType == "eco") {
                              cardType = "credit";
                            } else {
                              cardType = "eco";
                            }
                            getVendorsList();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(255, 161, 161, 161).withOpacity(0.15),
                          ),
                          // child: Image.asset('assets/images/qr_code.png', width: 24), // Adjusted image size
                          child: const Icon(
                            Icons.swipe_vertical_sharp,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        (cardType == "credit")
                        ? (double.parse(creditCardDetails[5])).toStringAsFixed(2)
                        : (double.parse(ecoCardDetails[4])).toStringAsFixed(2),
                        style: TextStyle(
                          color: Repository.titleColor(context),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        " RON",
                        style: TextStyle(
                          color: Repository.titleColor(context),
                          fontSize: 20,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const Gap(15),

            DropdownButton<String>(
              value: selectedVendor,
              icon: Icon(CupertinoIcons.chevron_down, color: Repository.titleColor(context)),
              underline: Container(height: 2, color: Repository.dividerColor(context)),
              onChanged: (String? newValue) {
                setState(() {
                  selectedVendor = newValue!;
                });
              },
              items: vendorNameList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                      style: TextStyle(
                          color: Repository.titleColor(context),
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                );
              }).toList(),
            ),

            const Gap(15),

            TextFormField(
              textAlign: TextAlign.center,
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(
                  color: Repository.titleColor(context),
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
