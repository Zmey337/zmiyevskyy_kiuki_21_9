import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';
import '../providers/students_provider.dart';
import '../widgets/student_item.dart';
import '../widgets/new_student.dart';

class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);
    final studentsNotifier = ref.read(studentsProvider.notifier);

    void addOrEditStudent(Student? existingStudent) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: NewStudent(
            existingStudent: existingStudent,
            onSave: (newStudent) {
              if (existingStudent != null) {
                studentsNotifier.updateStudent(existingStudent, newStudent);
              } else {
                studentsNotifier.addStudent(newStudent);
              }
              Navigator.of(ctx).pop();
            },
          ),
        ),
      );
    }

    return Scaffold(
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Dismissible(
            key: ValueKey(student.firstName),
            direction: DismissDirection.endToStart,
            onDismissed: (_) {
              studentsNotifier.removeStudent(student.firstName);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${student.firstName} removed'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: studentsNotifier.undoRemove,
                  ),
                ),
              );
            },
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade300, Colors.deepOrange.shade700],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text("Remove", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            child: InkWell(
              onTap: () => addOrEditStudent(student),
              child: StudentItem(student: student),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => addOrEditStudent(null),
        label: const Text("Add"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
