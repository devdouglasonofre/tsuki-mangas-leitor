import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:tsuki/models/manga.dart';

part 'manga_state.dart';

class MangaCubit extends Cubit<MangaState> {
  MangaCubit() : super(MangaInitial());

  void loadMangaList() async {
    emit(MangaListLoading());
    String result = await http
        .read(Uri.parse("https://tsukimangas.com/api/v2/mangas?title="));
    Map resultJSON = json.decode(result);
    List<Manga> mangasList = [];
    for (Map manga in resultJSON['data']) {
      mangasList.add(Manga(
          id: manga['id'],
          title: manga['title'],
          cover: manga['cover'],
          poster: manga['poster'],
          artist: manga['artist'],
          author: manga['author'],
          synopsis: manga['synopsis'],
          chaptersCount: manga['chapters_count']));
    }
    emit(MangaListLoaded(mangasList: mangasList));
  }

  void loadMangaListByName(String name) async {
    name = name.replaceAll(" ", "+").toLowerCase();
    emit(MangaListLoading());
    String result = await http
        .read(Uri.parse("https://tsukimangas.com/api/v2/mangas?title=$name"));
    Map resultJSON = json.decode(result);
    List<Manga> mangasList = [];
    for (Map manga in resultJSON['data']) {
      mangasList.add(Manga(
          id: manga['id'],
          title: manga['title'],
          cover: manga['cover'],
          poster: manga['poster'],
          artist: manga['artist'],
          author: manga['author'],
          synopsis: manga['synopsis'],
          chaptersCount: manga['chapters_count']));
    }
    emit(MangaListLoaded(mangasList: mangasList));
  }
}
