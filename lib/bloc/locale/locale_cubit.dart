import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/localization/app_localizations.dart';

class LocaleState {
  final Locale locale;
  
  LocaleState(this.locale);
}

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(LocaleState(const Locale('en'))) {
    _loadSavedLocale();
  }
  
  Future<void> _loadSavedLocale() async {
    final locale = await AppLocalizations.getSavedLocale();
    emit(LocaleState(locale));
  }
  
  Future<void> setLocale(Locale locale) async {
    await AppLocalizations.saveLocale(locale);
    emit(LocaleState(locale));
  }
}
