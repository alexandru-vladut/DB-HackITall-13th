import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackitall_singleton/github_utilities/generated/assets.dart';
import 'package:hackitall_singleton/github_utilities/repo/repository.dart';
import 'package:hackitall_singleton/github_utilities/utils/layouts.dart';
import 'package:hackitall_singleton/github_utilities/utils/size_config.dart';
import 'package:gap/gap.dart';
import 'package:flutter_credit_card_ui/flutter_credit_card_ui.dart';
import 'package:hackitall_singleton/my_utilities/animation/slideright_toleft.dart';
import 'package:hackitall_singleton/my_utilities/constants.dart';
import 'package:hackitall_singleton/screens/add_card.dart';
import 'package:hackitall_singleton/screens/send_money.dart';
import 'package:intl/intl.dart';
import 'package:hackitall_singleton/screens/returo_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  final user = FirebaseAuth.instance.currentUser!;
  List<String> userDetails = [''];
  List<String> creditCardDetails = ['', '', '', '', '', ''];
  List<String> ecoCardDetails = ['', '', '', '', ''];
  String cardType = "credit";
  bool visibleDetails = false;
  List<bool> hasCard = [false];

  List memojis = [Assets.memoji1, Assets.memoji2, Assets.memoji3, Assets.memoji4, Assets.memoji5, Assets.memoji6, Assets.memoji7, Assets.memoji8, Assets.memoji9];

  List transactionList = [];

  void getTransactionList() async {

    final userCollection = await FirebaseFirestore.instance.collection('users').where('UID', isEqualTo: user.uid).get();
    final userDoc = userCollection.docs[0];
    List transactionsRef = userDoc.get('transactions') as List;

    for (int i = 0; i < transactionsRef.length; i++) {
      Map transactionRef = transactionsRef[i] as Map;
      transactionList.add(transactionRef);
    }

    transactionList.sort((a, b) => b['time'].compareTo(a['time']));
    transactionList = transactionList.sublist(0, 3);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserDetails(user, userDetails, ['Nume'], () {setState(() {});});
    getCreditCardDetails(user, creditCardDetails, hasCard, () {setState(() {});});
    getEcoCardDetails(user, ecoCardDetails, () {setState(() {});});
    getTransactionList();
  }

  @override
  Widget build(BuildContext context) {

    SizeConfig.init(context);
    final size = Layouts.getSize(context);

    return Material(

      color: Repository.bgColor(context),
      elevation: 0,

      child: Stack(
        children: [

          Container(
            width: double.infinity,
            height: size.height * 0.585,
            color: Repository.headerColor(context),
          ),

          ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            children: [

              Gap(getProportionateScreenHeight(40)),

              // WELCOME TEXT
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                      Row(
                        children: [
                          Text(
                            'Hi, ',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 26,
                            )
                          ),
                          Text(
                            userDetails[0],
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            )
                          ),
                          Text(
                            '.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 26,
                            )
                          ),
                        ],
                      ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Image.asset(
                      'assets/images/micalbastru.png',
                      width: 30,
                    ),
                  )
                ],
              ),

              const Gap(15),

              //CARD
              (hasCard[0] == false)
              ? SizedBox(
                height: 310,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, SlideRightToLeft(page: const AddCard()));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                            Icons.add_card,
                            size: 70,
                          ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    const Text(
                      "Add new card",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              )
              : (cardType == "credit")
                ? Column(
                    children: [
                      CreditCardWidget(
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
                      ),

                      const Gap(3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (double.parse(creditCardDetails[5])).toStringAsFixed(2),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            )
                          ),
                          const Text(
                            "  RON",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            )
                          ),
                        ],
                      ),
                      const Gap(3),
                    ],
                  )

                : Column(
                    children: [
                      CreditCardWidget(
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

                      const Gap(3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (double.parse(ecoCardDetails[4])).toStringAsFixed(2),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            )
                          ),
                          const Text(
                            "  RON",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            )
                          ),
                        ],
                      ),
                      const Gap(3),
                    ],
                ),

              const Gap(15),

              // MIDDLE MENU
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Repository.accentColor(context),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context, SlideRightToLeft(page: ReturoView()));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red.withOpacity(0.15),
                        ),
                        child: Image.asset('assets/images/qr_code.png', width: 24), // Adjusted image size
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, SlideRightToLeft(page: const SendMoney()));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.withOpacity(0.15),
                        ),
                        // child: Image.asset('assets/images/qr_code.png', width: 24), // Adjusted image size
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.black,
                          size: 25,
                        ),
                      ),
                    ),
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
                          color: Colors.green.withOpacity(0.15), // Set color for the third item
                        ),
                        // child: Image.asset('assets/images/qr_code.png', width: 24), // Adjusted image size
                        child: Icon(
                          (visibleDetails) ? Icons.visibility_off : Icons.visibility,
                          color: Colors.black,
                          size: 25,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (cardType == "eco") {
                            cardType = "credit";
                          } else {
                            cardType = "eco";
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.yellow.withOpacity(0.15),
                        ),
                        // child: Image.asset('assets/images/qr_code.png', width: 24), // Adjusted image size
                        child: const Icon(
                          Icons.swipe_vertical_sharp,
                          color: Colors.black,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Gap(18),
              
              (hasCard[0] == false || transactionList.isEmpty)
              ? const SizedBox(
                height: 180,
                child: Center(
                  child: Text(
                    "No transactions yet.",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              : MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: transactionList.length,
                  itemBuilder: (c, i) {
                    final transaction = transactionList[i];
                    return ListTile(
                      isThreeLine: true,
                      minLeadingWidth: 10,
                      minVerticalPadding: 15,
                      contentPadding: const EdgeInsets.all(0),
                      leading: Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Repository.accentColor(context),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 1),
                                color: Colors.white.withOpacity(0.1),
                                blurRadius: 2,
                                spreadRadius: 1,
                              )
                            ],
                            image: (transaction['type'] == "person")
                                ? DecorationImage(
                                    image: AssetImage(memojis[i % 9]),
                                    fit: BoxFit.cover,
                                  )
                                : (transaction['type'] == "vendor") 
                                ? DecorationImage(
                                    image: AssetImage(vendorLogo[transaction['receiverName']]),
                                    fit: BoxFit.cover,
                                  )
                                : DecorationImage(
                                    image: AssetImage(vendorLogo[transaction['senderName']]),
                                    fit: BoxFit.cover,
                                  ),
                            shape: BoxShape.circle,
                          ),
                          child: const SizedBox()),
                      title: Text(
                        (transaction['senderName'] == userDetails[0])
                        ? transaction['receiverName']
                        : transaction['senderName'],
                        style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500)),
                        
                      subtitle: (transaction['type'] == "cashback")
                      ? const Text(
                          "Eco Cashback",
                          style: TextStyle(color: Colors.green))
                      : Text(
                          DateFormat('d MMMM, HH:mm').format(transaction['time'].toDate()),
                          style: const TextStyle(color: Colors.black)),

                      trailing: (transaction['senderName'] == userDetails[0])
                      ? Text(
                        "-${transaction['amount']}",
                        style: const TextStyle(fontSize: 17, color: Color.fromARGB(255, 184, 12, 0)))
                      : Text(
                        "+${transaction['amount']}",
                        style: const TextStyle(fontSize: 17, color: Colors.black))
                    );
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
