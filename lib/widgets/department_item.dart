import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/department.dart';
import '../providers/students_provider.dart';

class DepartmentItem extends ConsumerWidget {
  final Department department;

  const DepartmentItem({Key? key, required this.department}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);
    final studentCount = students.where((student) => student.department == department).length;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            department.color.withOpacity(0.7),
            department.color,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: GridTile(
        header: Center(
          child: Text(
            department.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        footer: Center(
          child: Text('$studentCount Students'),
        ),
        child: Icon(
          department.icon,
          size: 50,
        ),
      ),
    );
  }
}
