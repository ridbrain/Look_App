import 'dart:collection';

import 'package:look_app/services/answer.dart';
import 'package:look_app/services/constants.dart';
import 'package:look_app/services/extensions.dart';
import 'package:look_app/services/network.dart';
import 'package:look_app/widgets/app_bar.dart';
import 'package:look_app/widgets/empty_banner.dart';
import 'package:look_app/widgets/masters_table.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> suggestions = [];
  var controller = TextEditingController();
  var message = "Мастеров по Вашим параметрам к сожалению не найдено";
  var search = "";

  void updateSearch() async {
    var value = await NetHandler.getSearch();
    if (value == null) return;

    HashMap<String, int> suggs = HashMap();

    value.forEach((element) {
      element.removeOther().split(" ").forEach((word) {
        if (word.length > 1) {
          suggs.putIfAbsent(word.capitalLetter(), () => 0);
        }
      });
    });

    setState(() {
      suggs.forEach((key, value) {
        suggestions.add(key);
      });
    });
  }

  Future<List<Master>> searchMasters() async {
    if (search.isEmpty) {
      message =
          "Начните вводить запрос и выберите подходящее значение из списка";
      return [];
    }
    var value = await NetHandler.searchMasters(search);
    message = "Мастеров по Вашим параметрам к сожалению не найдено";
    return value ?? [];
  }

  Widget getMastersTable() {
    return FutureBuilder(
      future: searchMasters(),
      builder: (context, AsyncSnapshot<List<Master>> snap) {
        if (snap.hasData) {
          if (snap.data!.isNotEmpty) {
            return MastersTable(
              masters: snap.data!,
              update: () {},
            );
          }
          return SliverToBoxAdapter(
            child: EmptyBanner(
              description: message,
            ),
          );
        }
        return LoadingMastersTable();
      },
    );
  }

  @override
  void initState() {
    updateSearch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          slivers: [
            StandartAppBar(
              title: Text("Поиск"),
            ),
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  Container(
                    height: 48,
                    margin: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: Constants.radius,
                    ),
                    child: SearchField(
                      controller: controller,
                      suggestions: suggestions,
                      itemHeight: 45,
                      maxSuggestionsInViewPort: 4,
                      searchInputDecoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(15, 0, 45, 0),
                        hintText: "Название услуги или имя мастера",
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      suggestionsDecoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: Constants.radius,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 1),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                      ),
                      marginColor: Colors.transparent,
                      onTap: (value) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          search = value ?? "";
                        });
                      },
                    ),
                  ),
                  Positioned(
                    top: 14,
                    right: 25,
                    child: InkWell(
                      onTap: () {
                        controller.clear();
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        child: Icon(
                          Icons.cancel,
                          size: 25,
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            getMastersTable(),
            SliverToBoxAdapter(
              child: Container(
                height: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
