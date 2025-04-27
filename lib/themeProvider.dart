import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider do przechowywania aktualnego trybu motywu
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

final themeModeLoaderProvider = FutureProvider<void>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;

  if (isDarkMode){
    ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
  }else{
    ref.read(themeModeProvider.notifier).state = ThemeMode.light;

  }
});