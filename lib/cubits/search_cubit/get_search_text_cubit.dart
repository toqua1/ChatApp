import 'package:bloc/bloc.dart';

class SearchCubit extends Cubit<String> {
  SearchCubit() : super('');

  void updateSearchText(String searchText) => emit(searchText);
}
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// abstract class SearchState {}
//
// class SearchInitial extends SearchState {}
//
// class SearchUpdated extends SearchState {
//   final String searchText;
//
//   SearchUpdated(this.searchText);
// }
//
// class SearchCubit extends Cubit<SearchState> {
//   SearchCubit() : super(SearchInitial());
//
//   void updateSearchText(String searchText) => emit(SearchUpdated(searchText));
// }
