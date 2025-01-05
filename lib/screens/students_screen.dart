import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/students_provider.dart';
import '../widgets/student_item.dart';
import '../widgets/new_student.dart';

class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);
    final studentsNotifier = ref.read(studentsProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (students.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              students.errorMessage!,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    if (students.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } 

    void addOrEditStudent({int? index}) {
      showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: NewStudent(studentIndex: index),
        );
      },
    );
    }

    return Scaffold(
      body: ListView.builder(
        itemCount: students.students.length,
        itemBuilder: (context, index) {
          final student = students.students[index];
          return Dismissible(
            key: ValueKey(student.firstName),
            direction: DismissDirection.endToStart,
            onDismissed: (_) {
              final container = ProviderScope.containerOf(context);
              studentsNotifier.removeStudent(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${student.firstName} removed'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: studentsNotifier.undoRemove,
                  ),
                ),
              ).closed.then((value) {
                if (value != SnackBarClosedReason.action) {
                  container.read(studentsProvider.notifier).delete();
                }
              });
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
              onTap: () => addOrEditStudent(index: index),
              child: StudentItem(student: student),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => addOrEditStudent(),
        label: const Text("Add"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
