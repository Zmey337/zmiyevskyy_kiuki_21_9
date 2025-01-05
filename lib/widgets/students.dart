import 'package:flutter/material.dart';
import '../models/student.dart';
import 'student_item.dart';

class StudentsScreen extends StatelessWidget {
  final List<Student> students = [
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
    Student(
      firstName: "Emily",
      lastName: "Clark",
      department: Department.medical,
      grade: 92,
      gender: Gender.female,
    ),
    Student(
      firstName: "Michael",
      lastName: "Brown",
      department: Department.law,
      grade: 85,
      gender: Gender.male,
    ),
  ];

  StudentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Students"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return StudentItem(student: students[index]);
        },
      ),
    );
  }
}