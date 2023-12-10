// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackitall_singleton/github_utilities/generated/assets.dart';
import 'package:hackitall_singleton/github_utilities/repo/repository.dart';
import 'package:hackitall_singleton/github_utilities/utils/size_config.dart';
import 'package:hackitall_singleton/github_utilities/widgets/buttons.dart';
import 'package:hackitall_singleton/github_utilities/widgets/my_app_bar.dart';
import 'package:hackitall_singleton/github_utilities/widgets/people_slider.dart';
import 'package:flutter_credit_card_ui/flutter_credit_card_ui.dart';
import 'package:gap/gap.dart';
import 'package:hackitall_singleton/my_utilities/animation/slideleft_toright.dart';
import 'package:hackitall_singleton/my_utilities/constants.dart';
import 'package:hackitall_singleton/screens/bottom_nav.dart';

class SendMoney extends StatefulWidget {
  const SendMoney({Key? key}) : super(key: key);

  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {

  final user = FirebaseAuth.instance.currentUser!;
  List<String> userDetails = [''];
  List<String> creditCardDetails = ['', '', '', '', '', ''];
  List<String> ecoCardDetails = ['', '', '', '', ''];
  String cardType = "credit";
  bool visibleDetails = false;
  List<bool> hasCard = [false];

  int selectedPersonIndex = 0;

  void updateSelectedPersonIndex(int newValue) {
    setState(() {
      selectedPersonIndex = newValue;
    });
  }

  List usersList = [];
  List memojis = [Assets.memoji1, Assets.memoji2, Assets.memoji3, Assets.memoji4, Assets.memoji5, Assets.memoji6, Assets.memoji7, Assets.memoji8, Assets.memoji9];
  List colors = [const Color(0xFFECDCC1), const Color(0xFFDDA8CF), Colors.lightBlueAccent.shade200, const Color(0xFFD6F2CD), const Color(0xFFEC9F9B)];

  void getUsersList() async {

    final userCollection = await FirebaseFirestore.instance.collection('users').where('UID', isNotEqualTo: user.uid).get();
    
    int j = 0;

    for (int i = 0; i < userCollection.docs.length; i++) {

      final userDoc = userCollection.docs[i];
      final userName = userDoc.get("Nume").toString();
      usersList.add({
        'color': colors[j % 9],
        'avatar': memojis[j % 9],
        'name': userName,
      });

      j++;
    }

    setState(() {});
  }

  final ScrollController _scrollController = ScrollController();
  TextEditingController amountController = TextEditingController(text: '0.00');
  String selectedCurrency = 'RON';
  List<String> currencies = ['RON', 'EUR', 'USD'];

  void transferMoney() async {

    loadingAlert(context);

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
      'receiverName': usersList[selectedPersonIndex]['name'],
      'time': Timestamp.fromDate(DateTime.now()),
      'type': "person",
    });

    double senderSold = senderDoc.get("creditCard")['sold'].toDouble();
    senderSold = senderSold - double.parse(amountController.text);

    Map senderCreditCard = senderDoc.get("creditCard") as Map;
    senderCreditCard['sold'] = senderSold;

    // There should be exactly one matching document for each user
    if (senderDocSnapshot.docs.isNotEmpty) {
      await senderDocSnapshot.docs.first.reference.update({
        'creditCard': senderCreditCard,
        'transactions': senderTransactionsArray,
      });
    }

    final collection = FirebaseFirestore.instance.collection('transactions');
    await collection.add({
      'sender': userDetails[0],
      'receiver': usersList[selectedPersonIndex]['name'],
      'amount': amountController.text,
      'type': "personal",
      'time': Timestamp.fromDate(DateTime.now()),
    });

    // ================ RECEIVER ===================================
    var receiverDocSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('Nume', isEqualTo: usersList[selectedPersonIndex]['name'])
        .get();

    final receiverDoc = receiverDocSnapshot.docs[0];
    List receiverTransactionsArray = receiverDoc.get("transactions") as List;
    receiverTransactionsArray.add({
      'amount': amountController.text,
      'senderName': userDetails[0],
      'receiverName': usersList[selectedPersonIndex]['name'],
      'time': Timestamp.fromDate(DateTime.now()),
      'type': "person",
    });

    double receiverSold = receiverDoc.get("creditCard")['sold'].toDouble();
    receiverSold = receiverSold + double.parse(amountController.text);

    Map receiverCreditCard = receiverDoc.get("creditCard") as Map;
    receiverCreditCard['sold'] = receiverSold;

    // There should be exactly one matching document for each user
    if (receiverDocSnapshot.docs.isNotEmpty) {
      await receiverDocSnapshot.docs.first.reference.update({
        'creditCard': receiverCreditCard,
        'transactions': receiverTransactionsArray,
      });
    }

    Navigator.push(context, SlideLeftToRight(page: const BottomNav()));
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      print(_scrollController.offset);
    });
    super.initState();
    getUserDetails(user, userDetails, ['Nume'], () {setState(() {});});
    getCreditCardDetails(user, creditCardDetails, hasCard, () {setState(() {});});
    getEcoCardDetails(user, ecoCardDetails, () {setState(() {});});
    getUsersList();
  }

  @override
  void dispose() {
    amountController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print("SELECTED PERSON INDEX: $selectedPersonIndex");

    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Repository.bgColor(context),
      appBar: myAppBar(title: 'Send Money', implyLeading: true, context: context),
      bottomSheet: Container(
        color: Repository.bgColor(context),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: elevatedButton(
          color: Repository.selectedItemColor(context),
          context: context,
          callback: () {
            transferMoney();
          },
          text: 'Send Money',
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

            PeopleSlider(usersList: usersList, onValueChanged: updateSelectedPersonIndex),

            const Gap(15),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Repository.accentColor2(context),
                border: Border.all(color: Repository.accentColor(context))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
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
                        ),
                        DropdownButton<String>(
                          value: selectedCurrency,
                          icon: Icon(CupertinoIcons.chevron_down, color: Repository.titleColor(context)),
                          underline: Container(height: 2, color: Repository.dividerColor(context)),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCurrency = newValue!;
                            });
                          },
                          items: currencies.map<DropdownMenuItem<String>>((String value) {
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
