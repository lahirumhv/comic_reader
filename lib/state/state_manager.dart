import 'package:comic_reader/models/chapters.dart';
import 'package:comic_reader/models/comic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Providers are declared globally and specifies how to create a state
final comicSelected = StateProvider((ref) => Comic());
final chapterSelected = StateProvider((ref) => Chapters());
final isSearch = StateProvider((ref) => false);
