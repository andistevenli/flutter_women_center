import 'package:capstone_project/view/screen/saved/detail_reading_list/detail_reading_list_view_model.dart';
import 'package:capstone_project/view/screen/saved/search/search_saved_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/components/appbar/custom_appbar.dart';
import '../../../../utils/components/buttons/primary_button.dart';
import '../../../../utils/components/loading/loading.dart';
import '../../../../utils/components/modal_bottom_sheet/custom_bottom_sheet_builder.dart';
import '../../../../utils/components/text_box/search_text_box.dart';
import '../../../../utils/my_color.dart';
import '../../../../utils/my_size.dart';
import '../../../../utils/state/finite_state.dart';
import '../detail_reading_list/detail_reading_list_screen.dart';
import '../widgets/horizontal_article_card.dart';
import '../widgets/saved_card.dart';
import 'package:capstone_project/utils/components/text_box/regular_text_box/text_box.dart';

class SearchSavedScreen extends StatefulWidget {
  const SearchSavedScreen({super.key});

  static const String routeName = '/search_saved_screen';

  @override
  State<SearchSavedScreen> createState() => _SearchSavedScreen();
}

class _SearchSavedScreen extends State<SearchSavedScreen> {
  final TextEditingController _listNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _listNameNode = FocusNode();
  final FocusNode _descriptionNode = FocusNode();
  final TextEditingController _editListNameController = TextEditingController();
  final TextEditingController _editDescriptionController =
      TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _editListNameNode = FocusNode();
  final FocusNode _editDescriptionNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final SearchSavedViewModel provider;

  @override
  void initState() {
    provider = Provider.of<SearchSavedViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider.showReadingListByName(name: '');
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        preferredSize: Size(MySize.bodyWidth(context), double.maxFinite),
        home: false,
        searchField: true,
        tabBar: false,
        judul: 'Search Reading List',
        searchTextBox: SearchTextBox(
          autoFocus: true,
          textEditingController: _searchController,
          onChanged: (value) {
            provider.showReadingListByName(name: value);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: RefreshIndicator(
          strokeWidth: 2,
          color: MyColor.primaryMain,
          onRefresh: () {
            return provider.showReadingListByName(name: '');
          },
          child: Consumer<SearchSavedViewModel>(
              builder: (context, searchSavedProvider, _) {
            if (searchSavedProvider.state == MyState.loading) {
              return Center(
                child: CircularProgressIndicator(
                  color: MyColor.primaryMain,
                  strokeWidth: 2,
                ),
              );
            } else {
              if (_searchController.text.isEmpty ||
                  searchSavedProvider.allReadingListData.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/nothing_here.png'),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Woops! Sorry, no result found.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: MyColor.neutralHigh,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return ListView.separated(
                  itemCount: searchSavedProvider.allReadingListData.length,
                  itemBuilder: (context, indexList) {
                    return Consumer<DetailReadingListViewmodel>(
                        builder: (context, detailReadingListProvider, _) {
                      return GestureDetector(
                        onTap: () {
                          detailReadingListProvider.showReadingList(
                              id: searchSavedProvider
                                  .allReadingListData[indexList].id!);
                          Navigator.pushNamed(
                            context,
                            DetailReadingListScreen.routeName,
                          );
                        },
                        child: SavedCard(
                          deleteEvent: () {
                            searchSavedProvider.removeReadingList(
                                id: searchSavedProvider
                                    .allReadingListData[indexList].id!);
                            _searchController.clear();
                            searchSavedProvider.showReadingListByName(
                                name: _searchController.text);
                            Navigator.pop(context);
                          },
                          editReadingListBottomSheetBuilder: (context) {
                            return CustomBottomSheetBuilder(
                              header: true,
                              tinggi: 680,
                              judul: 'Edit List Info',
                              isi: [
                                Form(
                                  key: _formKey,
                                  child: SizedBox(
                                    height: 680,
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'List Name',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: MyColor.neutralHigh,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextBox(
                                          textEditingController:
                                              _editListNameController,
                                          hintText:
                                              'Ex : How to heal my traumatized inner child',
                                          currentFocus: _editListNameNode,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Wajib diisi';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Text(
                                          'Description (optional)',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: MyColor.neutralHigh,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextBox(
                                          textEditingController:
                                              _editDescriptionController,
                                          last: true,
                                          hintText:
                                              'Ex : This is an important list',
                                          currentFocus: _editDescriptionNode,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Wajib diisi';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        PrimaryButton(
                                          teks: 'Save Changes',
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              searchSavedProvider
                                                  .updateReadingList(
                                                id: searchSavedProvider
                                                    .allReadingListData[
                                                        indexList]
                                                    .id!,
                                                name: _editListNameController
                                                    .text,
                                                description:
                                                    _editDescriptionController
                                                        .text,
                                              );
                                              _searchController.clear();
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                                searchSavedProvider
                                                    .showReadingListByName(
                                                        name: _searchController
                                                            .text);
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              cancelEvent: () {
                                _editListNameController.clear();
                                _editDescriptionController.clear();
                                Navigator.pop(context);
                              },
                            );
                          },
                          judulList: searchSavedProvider
                                      .allReadingListData[indexList].name ==
                                  null
                              ? '-'
                              : searchSavedProvider
                                  .allReadingListData[indexList].name!,
                          totalArtikel: searchSavedProvider
                                  .allReadingListData[indexList].articleTotal ??
                              0,
                          deskripsi: searchSavedProvider
                                  .allReadingListData[indexList].description ??
                              '-',
                          editListNameTextEditingController:
                              _editListNameController,
                          editDescriptionTextEditingController:
                              _editDescriptionController,
                          editListNameFocusNode: _editListNameNode,
                          editDescriptionFocusNode: _editDescriptionNode,
                          daftarArtikel: searchSavedProvider
                                      .allReadingListData[indexList]
                                      .articleTotal! ==
                                  0
                              ? null
                              : ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: searchSavedProvider
                                      .allReadingListData[indexList]
                                      .articleTotal!,
                                  itemBuilder: (context, indexArticle) {
                                    return HorizontalArticleCard(
                                      urlGambarArtikel: searchSavedProvider
                                                  .allReadingListData[indexList]
                                                  .readingListArticles ==
                                              null
                                          ? '-'
                                          : searchSavedProvider
                                              .allReadingListData[indexList]
                                              .readingListArticles![
                                                  indexArticle]
                                              .article!
                                              .image!,
                                      kategoriArtikel: searchSavedProvider
                                                  .allReadingListData[indexList]
                                                  .readingListArticles ==
                                              null
                                          ? '-'
                                          : searchSavedProvider
                                              .allReadingListData[indexList]
                                              .readingListArticles![
                                                  indexArticle]
                                              .article!
                                              .category!,
                                      judulArtikel: searchSavedProvider
                                                  .allReadingListData[indexList]
                                                  .readingListArticles ==
                                              null
                                          ? '-'
                                          : searchSavedProvider
                                              .allReadingListData[indexList]
                                              .readingListArticles![
                                                  indexArticle]
                                              .article!
                                              .title!,
                                    );
                                  },
                                  separatorBuilder: (context, indexArticle) {
                                    return const SizedBox(
                                      width: 8,
                                    );
                                  },
                                ),
                          cancelEvent: () {
                            _editListNameController.clear();
                            _descriptionController.clear();
                            Navigator.pop(context);
                          },
                        ),
                      );
                    });
                  },
                  separatorBuilder: (context, indexList) {
                    return const SizedBox(
                      height: 8,
                    );
                  },
                );
              }
            }
          }),
        ),
      ),
    );
  }
}