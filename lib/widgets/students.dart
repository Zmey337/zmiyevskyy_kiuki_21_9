import 'package:flutter/material.dart';
import '../models/student.dart';
import 'student_item.dart';
import 'new_student.dart';

class StudentsScreen extends StatefulWidget {
  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<Student> students = [
    Student(
      firstName: "John",
      lastName: "Doe",
      department: Department.it,
      grade: 95,
      gender: Gender.male,
    ),
    Student(
      firstName: "Jane",
      lastName: "Smith",
      department: Department.finance,
      grade: 88,
      gender: Gender.female,
    ),
  ];

  void _addOrEditStudent(Student? existingStudent) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => NewStudent(
        existingStudent: existingStudent,
        onSave: (newStudent) {
          setState(() {
            if (existingStudent != null) {
              final index = students.indexOf(existingStudent);
              students[index] = newStudent;
            } else {
              students.add(newStudent);
            }
          });
        },
      ),
    );
  }

  void _removeStudent(int index) {
    final removedStudent = students[index];
    setState(() => students.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info, color: Colors.yellow),
            SizedBox(width: 8),
            Expanded(child: Text("Removed ${removedStudent.firstName}")),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        action: SnackBarAction(
          label: "Undo",
          textColor: Colors.yellow,
          onPressed: () {
            setState(() => students.insert(index, removedStudent));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Students"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(students[index]),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => _removeStudent(index),
            background: Container(
              color: Colors.red.shade300,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.delete, color: Colors.white),
                  SizedBox(width: 8),
                  Text("Delete", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            child: InkWell(
              onTap: () => _addOrEditStudent(students[index]),
              child: StudentItem(student: students[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addOrEditStudent(null),
        label: Text("Add"),
        icon: Icon(Icons.add),
        backgroundColor: Colors.teal.shade600,
      ),
    );
  }
}