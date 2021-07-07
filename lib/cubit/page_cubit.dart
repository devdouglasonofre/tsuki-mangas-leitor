import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'page_state.dart';

class PageCubit extends Cubit<PageState> {
  PageCubit() : super(PageInitial());

  void loadPages(int chapterID) async {
    String result = await http.read(Uri.parse(
        "https://tsukimangas.com/api/v2/chapter/versions/$chapterID"));
    Map resultJSON = json.decode(result);
    List<String> pageListRaw = [];
    var response = await http.get(Uri.parse(
        "https://cdn2.tsukimangas.com${resultJSON['pages'][0]['url']}"));
    String cdn = response.statusCode == 404 ? "cdn1" : "cdn2";
    for (Map page in resultJSON['pages']) {
      pageListRaw.add("https://$cdn.tsukimangas.com${page['url']}");
    }
    emit(PageListLoaded(pagesList: pageListRaw));
  }
}
