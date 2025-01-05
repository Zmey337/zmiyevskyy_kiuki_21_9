import 'package:flutter/material.dart';
import '../models/department.dart';
import '../widgets/department_item.dart';

class DepartmentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      children: departments
          .map((dept) => DepartmentItem(department: dept))
          .toList(),
    );
  }
}
