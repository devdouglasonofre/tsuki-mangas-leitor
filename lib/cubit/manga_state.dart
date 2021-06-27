part of 'manga_cubit.dart';

@immutable
abstract class MangaState {}

class MangaInitial extends MangaState {}

class MangaListLoading extends MangaState {}

class MangaListLoaded extends MangaState {
  final List<Manga> mangasList;
  MangaListLoaded({required this.mangasList});
}
