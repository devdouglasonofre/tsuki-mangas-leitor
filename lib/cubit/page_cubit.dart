import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:tsuki/models/chapter.dart';

part 'page_state.dart';

class PageCubit extends Cubit<PageState> {
  PageCubit() : super(PageInitial());

  void loadPages(int chapterID, String chapterNumber, int mangaID) async {
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

    var previousChapter;
    var nextChapter;

    String resultListOfChapters = await http.read(
        Uri.parse("https://tsukimangas.com/api/v2/chapters/$mangaID/all"));
    List resultListOfChaptersJSON = json.decode(resultListOfChapters);

    for (var i = 0; i < resultListOfChaptersJSON.length; i++) {
      if (resultListOfChaptersJSON[i]['number'] == chapterNumber) {
        if (i == 0) {
          previousChapter = Chapter(
              chapterId: resultListOfChaptersJSON[i]["versions"][0]['id'],
              chapterNumber: resultListOfChaptersJSON[i]['number']);
          nextChapter = Chapter(
              chapterId: resultListOfChaptersJSON[i + 1]["versions"][0]['id'],
              chapterNumber: resultListOfChaptersJSON[i + 1]['number']);
        } else if (i == resultListOfChaptersJSON.length - 1) {
          previousChapter = Chapter(
              chapterId: resultListOfChaptersJSON[i - 1]["versions"][0]['id'],
              chapterNumber: resultListOfChaptersJSON[i - 1]['number']);
          nextChapter = Chapter(
              chapterId: resultListOfChaptersJSON[i]["versions"][0]['id'],
              chapterNumber: resultListOfChaptersJSON[i]['number']);
        } else {
          previousChapter = Chapter(
              chapterId: resultListOfChaptersJSON[i - 1]["versions"][0]['id'],
              chapterNumber: resultListOfChaptersJSON[i - 1]['number']);
          nextChapter = Chapter(
              chapterId: resultListOfChaptersJSON[i + 1]["versions"][0]['id'],
              chapterNumber: resultListOfChaptersJSON[i + 1]['number']);
        }
      }
    }

    emit(PageListLoaded(
        pagesList: pageListRaw,
        previousChapter: previousChapter,
        nextChapter: nextChapter));
  }
}
