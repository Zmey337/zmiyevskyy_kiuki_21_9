import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';

class StudentsNotifier extends StateNotifier<List<Student>> {
  StudentsNotifier() : super([]);

  Student? _lastRemovedStudent;
  int? _lastRemovedIndex;

  void addStudent(Student student) {
    state = [...state, student];
  }

  void updateStudent(Student oldStudent, Student newStudent) {
    final index = state.indexOf(oldStudent);
    if (index != -1) {
      final updatedState = [...state];
      updatedState[index] = newStudent;
      state = updatedState;
    }
  }

  void removeStudent(String id) {
    final index = state.indexWhere((student) => student.firstName == id);
    if (index != -1) {
      _lastRemovedStudent = state[index];
      _lastRemovedIndex = index;
      state = state.where((student) => student.firstName != id).toList();
    }
  }

  void undoRemove() {
    if (_lastRemovedStudent != null && _lastRemovedIndex != null) {
      final tempList = [...state];
      tempList.insert(_lastRemovedIndex!, _lastRemovedStudent!);
      state = tempList;
      _lastRemovedStudent = null;
      _lastRemovedIndex = null;
    }
  }
}

final studentsProvider = StateNotifierProvider<StudentsNotifier, List<Student>>((ref) => StudentsNotifier());
