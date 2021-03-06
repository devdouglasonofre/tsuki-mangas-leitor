part of 'chapter_cubit.dart';

@immutable
abstract class ChapterState {}

class ChapterInitial extends ChapterState {}

class ChapterListLoading extends ChapterState {}

class ChapterListLoaded extends ChapterState {
  final List<Chapter> chaptersList;
  ChapterListLoaded({required this.chaptersList});
}
