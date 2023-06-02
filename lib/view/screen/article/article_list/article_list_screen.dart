import 'package:capstone_project/model/article_model.dart';
import 'package:capstone_project/utils/components/appbar/custom_appbar.dart';
import 'package:capstone_project/utils/components/buttons/floating_button.dart';
import 'package:capstone_project/utils/components/modal_bottom_sheet/custom_bottom_sheet_builder.dart';

import 'package:capstone_project/utils/components/text_box/search_text_box.dart';
import 'package:capstone_project/utils/my_color.dart';
import 'package:capstone_project/utils/my_size.dart';
import 'package:capstone_project/view/screen/article/article_detail/article_detail_screen.dart';
import 'package:capstone_project/view/screen/article/article_list/article_list_view_model.dart';
import 'package:capstone_project/view/screen/article/article_list/widgets/bottomsheet_content.dart';
import 'package:capstone_project/view/screen/article/widget/save_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArticleListScreen extends StatefulWidget {
  static const String routename = '/article_list_screen';
  const ArticleListScreen({super.key});

  @override
  State<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedText =
        Provider.of<ArticleListProvider>(context, listen: false).selectedText;
    // final selectedSortBy =
    //     Provider.of<ArticleListProvider>(context).selectedSortBy;
    // String selectedText = '';

    // switch (selectedSortBy) {
    //   case SortBy.mostViewed:
    //     selectedText = 'Most Viewed';
    //     break;
    //   case SortBy.newest:
    //     selectedText = 'Newest';
    //     break;
    //   case SortBy.older:
    //     selectedText = 'Older';
    //     break;
    // }
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: CustomAppBar(
          preferredSize: Size(MySize.screenWidth(context), double.maxFinite),
          home: false,
          judul: 'Article',
          searchField: true,
          tabBar: true,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Mental Health'),
            Tab(text: 'Self Improvement'),
            Tab(text: 'Spiritual'),
          ],
          searchTextBox: SearchTextBox(
            textEditingController: _searchController,
            onChanged: (value) {
              Provider.of<ArticleListProvider>(context, listen: false)
                  .changeSearchString(value);
            },
          ),
        ),
        body: Consumer<ArticleListProvider>(
          builder: (context, provider, child) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            provider.selectedText,
                            style: TextStyle(
                              color: MyColor.neutralMediumLow,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Consumer<ArticleListProvider>(
                              builder: (context, provider, child) {
                            final articleList = provider.articles;
                            return ListView.builder(
                              itemBuilder: ((context, index) {
                                final Articles articles = articleList[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ArticleDetailsScreen(
                                                articles: articles),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(3),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Image.asset(
                                            articles.image,
                                            width: 135,
                                            height: 128,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  articles.title,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                                Text(
                                                  articles.author,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        MyColor.neutralMedium,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                                Text(
                                                  articles.date,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        MyColor.neutralMedium,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                                useRootNavigator: true,
                                                isScrollControlled: true,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Wrap(children: const [
                                                    SaveContent()
                                                  ]);
                                                });
                                          },
                                          icon:
                                              const Icon(Icons.bookmark_border),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                              itemCount: articleList.length,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: SizedBox(
          height: 50,
          width: 130,
          child: FloatingButton(
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  useRootNavigator: true,
                  context: context,
                  builder: (BuildContext context) {
                    return CustomBottomSheetBuilder(
                      tinggi: MediaQuery.of(context).size.height * 0.8,
                      isi: const [
                        BottomSheetContent(),
                      ],
                      header: true,
                      judul: 'Sort By',
                    );
                  });
            },
            teks: 'Sort By',
            widget: const Icon(Icons.sort),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}