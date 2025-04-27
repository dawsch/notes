import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notatnik/features/notes/presentation/providers/databaseProvider.dart';
import 'package:notatnik/features/notes/domain/useCases/useCases.dart';

final getAllNotesUseCaseProvider = Provider<GetAllNotesUseCase>((ref) {
  final repository = ref.read(databaseProvider);
  return GetAllNotesUseCase(repository);
});

final addNoteUseCaseProvider = Provider<AddNoteUseCase>((ref) {
  final repository = ref.read(databaseProvider);
  return AddNoteUseCase(repository);
});

final editNoteUseCaseProvider = Provider<EditNoteUseCase>((ref) {
  final repository = ref.read(databaseProvider);
  return EditNoteUseCase(repository);
});

final deleteNoteUseCaseProvider = Provider<DeleteNoteUseCase>((ref) {
  final repository = ref.read(databaseProvider);
  return DeleteNoteUseCase(repository);
});