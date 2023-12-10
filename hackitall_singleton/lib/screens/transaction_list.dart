import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackitall_singleton/github_utilities/generated/assets.dart';
import 'package:hackitall_singleton/github_utilities/repo/repository.dart';
import 'package:hackitall_singleton/github_utilities/widgets/my_app_bar.dart';
import 'package:hackitall_singleton/my_utilities/constants.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({Key? key}) : super(key: key);

  @override
  State<TransactionList> createState() => _TransactionListState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _TransactionListState extends State<TransactionList> {

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
    return Scaffold(
      appBar: myAppBar(title: 'All Transactions', implyLeading: false, context: context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child:
            ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: transactionList.length,
              itemBuilder: (c, i) {
                final transaction = transactionList[i];
                return ListTile(
                  isThreeLine: true,
                  minLeadingWidth: 10,
                  minVerticalPadding: 20,
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
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                    
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
      ),
    );
  }
}