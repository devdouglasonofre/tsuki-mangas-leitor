part of 'page_cubit.dart';

@immutable
abstract class PageState {}

class PageInitial extends PageState {}

class PageListLoading extends PageState {}

class PageListLoaded extends PageState {
  final Chapter previousChapter;
  final Chapter nextChapter;
  final List<String> pagesList;
  PageListLoaded(
      {required this.pagesList,
      required this.previousChapter,
      required this.nextChapter});
}
