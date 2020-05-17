import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:zmgestion/src/themes/AppTheme.dart';
import 'package:zmgestion/src/bloc/ThemeEvent.dart';
import 'package:zmgestion/src/bloc/ThemeState.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  @override
  ThemeState get initialState =>
      // Everything is accessible from the appThemeData Map.
      ThemeState(themeData: appThemeData[AppTheme.Light]);

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is ThemeChanged) {
      yield ThemeState(themeData: appThemeData[event.theme]);
    }
  }
}