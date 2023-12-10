// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackitall_singleton/github_utilities/generated/assets.dart';
import 'package:hackitall_singleton/github_utilities/repo/repository.dart';
import 'package:hackitall_singleton/github_utilities/utils/size_config.dart';
import 'package:hackitall_singleton/github_utilities/widgets/buttons.dart';
import 'package:hackitall_singleton/github_utilities/widgets/default_text_field.dart';
import 'package:hackitall_singleton/github_utilities/widgets/my_app_bar.dart';
import 'package:gap/gap.dart';
import 'package:flutter_credit_card_ui/flutter_credit_card_ui.dart';
import 'package:hackitall_singleton/my_utilities/animation/slideleft_toright.dart';
import 'package:hackitall_singleton/my_utilities/constants.dart';
import 'package:hackitall_singleton/screens/bottom_nav.dart';

class AddCard extends StatefulWidget {
  const AddCard({Key? key}) : super(key: key);

  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {

  final user = FirebaseAuth.instance.currentUser!;

  final TextEditingController _cardHolderName = TextEditingController();
  final TextEditingController _cardNumber = TextEditingController();
  final TextEditingController _cardDate = TextEditingController();
  final TextEditingController _cardCvv = TextEditingController();
  
  List paymentCardsList = [
    Assets.cardsVisa,
    Assets.cardsMastercard,
  ];

  int selectedCard = 0;

  void submitCard() async {

    final random = Random();
    int randomCvv = 100 + random.nextInt(899);

    int randomNumber1 = 1000 + random.nextInt(8999);
    int randomNumber2 = 1000 + random.nextInt(8999);
    int randomNumber3 = 1000 + random.nextInt(8999);
    int randomNumber4 = 1000 + random.nextInt(8999);
    String randomNumber = "$randomNumber1 $randomNumber2 $randomNumber3 $randomNumber4";

    int randomMonth = 1 + random.nextInt(11);
    int randomYear = 25 + random.nextInt(4);
    String randomDate;
    if (randomMonth < 10) {
      randomDate = "0$randomMonth/$randomYear";
    } else {
      randomDate = "$randomMonth/$randomYear";
    }

    int randomSold = 400 + 50 * random.nextInt(92);

    loadingAlert(context);

    // UPDATE FIELD IN FIRESTORE DATABASE.
    // Fetch the user document based on the user's UID
    var userDocSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('UID', isEqualTo: user.uid)
        .get();

    // There should be exactly one matching document for each user
    if (userDocSnapshot.docs.isNotEmpty) {
      await userDocSnapshot.docs.first.reference.update({
        'creditCard': {
          'cvv': _cardCvv.text,
          'expirationDate': _cardDate.text,
          'name': _cardHolderName.text,
          'number': _cardNumber.text,
          'type': (selectedCard == 0) ? "Visa" : "MasterCard",
          'sold': randomSold,
        },
        'ecoCard': {
          'cvv': randomCvv,
          'expirationDate': randomDate,
          'name': _cardHolderName.text,
          'number': randomNumber,
          'sold': 0,
        },
      });
    }

    Navigator.push(context, SlideLeftToRight(page: const BottomNav()));
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    _cardHolderName.dispose();
    _cardNumber.dispose();
    _cardDate.dispose();
    _cardCvv.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Add listener to text controller
    _cardHolderName.addListener(() {
      setState(() {});
    });
    _cardNumber.addListener(() {
      setState(() {});
    });
    _cardDate.addListener(() {
      setState(() {});
    });
    _cardCvv.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Repository.bgColor(context),
      appBar: myAppBar(title: 'Add Card', implyLeading: true, context: context),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [

          SizedBox(
            child: CreditCardWidget(
                cardDecoration: CardDecoration(
                  showBirdImage: true,
                ),
                cvvText: (_cardCvv.text == "") ? "XXX" : _cardCvv.text,
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 103, 103, 103),
                    Color.fromARGB(255, 226, 228, 226),
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
                cardHolder: (_cardHolderName.text == "") ? "NAME SURNAME" : _cardHolderName.text,
                cardNumber: (_cardNumber.text == "") ? "1234 5678 9012 3456" : _cardNumber.text,
                cardExpiration: (_cardDate.text == "") ? "MM/YY" : _cardDate.text,
                cardtype: (selectedCard == 0) ? CardType.visa : CardType.masterCard,
                color: Colors.red,
              ),
          ),

          const Gap(15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: paymentCardsList.map<Widget>((paymentCard) {
              return MaterialButton(
                elevation: 0,
                color: Repository.accentColor(context),
                minWidth: 110,
                height: 100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(paymentCard),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const Gap(15),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 700),
                      child: Icon(
                        selectedCard == paymentCardsList.indexOf(paymentCard)
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: selectedCard ==
                                paymentCardsList.indexOf(paymentCard)
                            ? Repository.selectedItemColor(context)
                            : Colors.white.withOpacity(0.5),
                      ),
                    )
                  ],
                ),
                onPressed: () {
                  setState(() {
                    selectedCard = paymentCardsList.indexOf(paymentCard);
                  });
                },
              );
            }).toList(),
          ),

          const Gap(20),

          DefaultTextField(
              controller: _cardHolderName,
              title: 'Card Holder Name'),
          DefaultTextField(
              controller: _cardNumber,
              title: 'Card Number'),
          Row(
            children: [
              Flexible(
                child: DefaultTextField(
                    controller: _cardDate,
                    title: 'Expiry Date'),
              ),
              const Gap(10),
              Flexible(
                child: DefaultTextField(
                    controller: _cardCvv,
                    title: 'CVC/CVV',
                    obscure: true),
              ),
            ],
          ),
          const Gap(10),
          elevatedButton(
            color: Repository.selectedItemColor(context),
            context: context,
            callback: () {
              submitCard();
            },
            text: 'Add Card',
          )
        ],
      ),
    );
  }
}
