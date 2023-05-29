import 'package:capstone_project/utils/components/appbar/custom_appbar.dart';
import 'package:capstone_project/utils/my_size.dart';
import 'package:capstone_project/view/screen/forum/join_forum_discussion_screen.dart';
import 'package:capstone_project/utils/components/text_box/search_text_box.dart';
import 'package:capstone_project/utils/my_size.dart';
import 'package:capstone_project/view/screen/article/article_list/article_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/utils/my_size.dart';
import 'package:capstone_project/view/screen/auth/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/login/login_view_model.dart';

import '../../../utils/components/buttons/circle_button.dart';
import '../../../utils/components/text_box/search_text_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchHomeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        preferredSize: Size(MySize.bodyWidth(context), double.maxFinite),
        judul: 'Home',
        home: true,
        searchField: true,
        tabBar: false,
        searchTextBox: SearchTextBox(
          textEditingController: _searchHomeController,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleButton(
                widget: const Icon(
                  Icons.article_rounded,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              CircleButton(
                widget: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              CircleButton(
                widget: const Icon(
                  Icons.work_rounded,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              CircleButton(
                widget: const Icon(
                  Icons.chat_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    JoinForumDiscussionScreen.routeName,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
