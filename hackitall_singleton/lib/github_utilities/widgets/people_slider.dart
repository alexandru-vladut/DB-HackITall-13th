import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackitall_singleton/github_utilities/repo/repository.dart';
import 'package:hackitall_singleton/github_utilities/utils/layouts.dart';
import 'package:hackitall_singleton/github_utilities/utils/size_config.dart';

class PeopleSlider extends StatefulWidget {

  final List usersList;
  final Function(int) onValueChanged;

  const PeopleSlider({Key? key, required this.usersList, required this.onValueChanged}) : super(key: key);

  @override
  _PeopleSliderState createState() => _PeopleSliderState();
}

class _PeopleSliderState extends State<PeopleSlider> {

  final user = FirebaseAuth.instance.currentUser!;

  var controller = ScrollController();
  var currentPage = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final theme = Layouts.getTheme(context);
    final size = Layouts.getSize(context);
    controller.addListener(() {
      setState(() {
        //currentPage = controller.page!.round();
      });
    });
    return _body(size.height, theme);
  }

  _body(double height, ThemeData theme) {
    double _height = height * 0.19;
    return SizedBox(
      height: _height,
      child: ListView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: widget.usersList.length,
        itemBuilder: (context, index) {
          final item = widget.usersList[index];
          return InkWell(
            onTap: () {
              setState(() {
                currentPage = index;
              });

              widget.onValueChanged(index);
              
              print(controller.offset);
              double itemWidth = 20; // Assuming each item has a width of 100 pixels
              double offset = index * itemWidth;
              controller.animateTo(offset,
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.elasticOut);
              //controller.animateToPage(index, duration: Duration(milliseconds: 700), curve: Curves.elasticOut);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: (index == currentPage) ? 100 : 65,
                  width: (index == currentPage) ? 100 : 65,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item['color'],
                  ),
                  child: Transform.scale(
                      scale: 0.55, child: Image.asset(item['avatar'])),
                ),
                const SizedBox(height: 8),
                (index == currentPage)
                    ? Text(item['name'],
                        style: TextStyle(color: Repository.textColor(context), fontSize: 16, fontWeight: FontWeight.w500))
                    : const Text('')
              ],
            ),
          );
        },
      ),
    );
  }
}
