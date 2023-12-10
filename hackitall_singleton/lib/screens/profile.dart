import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackitall_singleton/auth/login_page.dart';
import 'package:hackitall_singleton/github_utilities/generated/assets.dart';
import 'package:hackitall_singleton/github_utilities/json/shortcut_list.dart';
import 'package:hackitall_singleton/github_utilities/repo/repository.dart';
import 'package:hackitall_singleton/github_utilities/widgets/custom_list_tile.dart';
import 'package:hackitall_singleton/github_utilities/utils/iconly/iconly_bold.dart';
import 'package:hackitall_singleton/github_utilities/widgets/my_app_bar.dart';
import 'package:gap/gap.dart';
import 'package:hackitall_singleton/my_utilities/animation/slideleft_toright.dart';
import 'package:hackitall_singleton/my_utilities/animation/slideright_toleft.dart';
import 'package:hackitall_singleton/my_utilities/constants.dart';
import 'package:hackitall_singleton/screens/donate_money.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {

  final user = FirebaseAuth.instance.currentUser!;
  List<String> userDetails = ['', ''];

  @override
  void initState() {
    super.initState();
    getUserDetails(user, userDetails, ['Nume', "Email"], () {setState(() {});});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Repository.bgColor(context),
      appBar: myAppBar(title: 'Profile', implyLeading: false, context: context),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          const Gap(40),
          Stack(
            children: [
              Container(
                height: 280,
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 230,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Repository.accentColor(context),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Gap(60),
                      Center(
                          child: Text(
                            userDetails[0],
                            style: TextStyle(
                                  color: Repository.textColor(context), fontSize: 20, fontWeight: FontWeight.bold))),
                      const Gap(10),
                      Text(userDetails[1],
                          style:
                              TextStyle(color: Repository.subTextColor(context))),
                      const Gap(25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: profilesShortcutList.map<Widget>((e) {
                          return GestureDetector(
                            onTap: () {
                              loadingAlert(context);

                              FirebaseAuth.instance.signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                SlideLeftToRight(page: const LoginPage()),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 15),
                              padding: const EdgeInsets.all(13),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Icon(e['icon'], color: e['color']),
                            ),
                          );
                        }).toList(),
                      ),
                      const Gap(25)
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 30,
                right: 30,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFE486DD),
                  ),
                  child: Transform.scale(
                    scale: 0.55,
                    child: Image.asset(Assets.memoji6),
                  ),
                ),
              )
            ],
          ),
          const Gap(35),
          GestureDetector(
            onTap: () {
              Navigator.push(context, SlideRightToLeft(page: const DonateMoney()));
            },
            child: CustomListTile(
                icon: Icons.health_and_safety_rounded,
                color: Color.fromARGB(255, 201, 0, 71),
                title: 'Donate', context: context),
          ),
          CustomListTile(
              icon: IconlyBold.Shield_Done,
              color: const Color(0xFF229e76),
              title: 'Security', context: context),
          CustomListTile(
              icon: IconlyBold.Message,
              color: const Color(0xFFe17a0a),
              title: 'Contact us', context: context),
          CustomListTile(
              icon: IconlyBold.Document,
              color: const Color(0xFF064c6d),
              title: 'Support', context: context),
        ],
      ),
    );
  }
}

