part of 'page_cubit.dart';

@immutable
abstract class PageState {}

class PageInitial extends PageState {}

class PageListLoading extends PageState {}

class PageListLoaded extends PageState {
  final List<String> pagesList;
  PageListLoaded({required this.pagesList});
}
