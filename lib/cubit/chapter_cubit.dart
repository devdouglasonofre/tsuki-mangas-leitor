import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:tsuki/models/chapter.dart';

part 'chapter_state.dart';

class ChapterCubit extends Cubit<ChapterState> {
  ChapterCubit() : super(ChapterInitial());

  void loadChapters(int mangaID, List<Chapter> chapterList, bool desc) async {
    if (chapterList.isEmpty) {
      emit(ChapterListLoading());
    }
    int page = ((chapterList.length + 1) / 20 + 1).floor();
    String order = desc ? "desc" : "asc";
    String result = await http.read(Uri.parse(
        "https://tsukimangas.com/api/v2/chapters?manga_id=$mangaID&order=$order&page=$page"));
    Map resultJSON = json.decode(result);
    List<Chapter> chaptersListRaw = chapterList.isEmpty ? [] : chapterList;
    for (Map chapter in resultJSON['data']) {
      chaptersListRaw.add(Chapter(
              chapterId: chapter["versions"][0]['id'],
              chapterNumber: chapter['number'])
          //"uploadDate": chapter["versions"][0]['created_at']
          );
    }
    emit(ChapterListLoaded(chaptersList: chaptersListRaw));
  }
}
