import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/department.dart';

class NewStudent extends StatefulWidget {
  final void Function(Student) onSave;
  final Student? existingStudent;

  const NewStudent({Key? key, required this.onSave, this.existingStudent}) : super(key: key);

  @override
  State<NewStudent> createState() => _NewStudentState();
}

class _NewStudentState extends State<NewStudent> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _gradeController = TextEditingController();
  late Department _selectedDepartment;
  Gender? _selectedGender;

  @override
  void initState() {
    super.initState();
    if (widget.existingStudent != null) {
      final student = widget.existingStudent!;
      _nameController.text = student.firstName;
      _surnameController.text = student.lastName;
      _selectedDepartment = student.department;
      _gradeController.text = student.grade.toString();
      _selectedGender = student.gender;
    } else {
      _selectedDepartment = departments[0];
      _gradeController.text = '0';
      _selectedGender = null;
    }
  }

  void _saveStudent() {
    final grade = int.tryParse(_gradeController.text) ?? 0;
    if (_selectedGender != null &&
        _nameController.text.isNotEmpty &&
        _surnameController.text.isNotEmpty) {
      final newStudent = Student(
        firstName: _nameController.text,
        lastName: _surnameController.text,
        department: _selectedDepartment,
        grade: grade,
        gender: _selectedGender!,
      );
      widget.onSave(newStudent);
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'First Name'),
          ),
          TextField(
            controller: _surnameController,
            decoration: const InputDecoration(labelText: 'Last Name'),
          ),
          DropdownButtonFormField<Department>(
            value: _selectedDepartment,
            decoration: const InputDecoration(labelText: 'Department'),
            items: departments
                .map(
                  (dept) => DropdownMenuItem(
                    value: dept,
                    child: Row(
                      children: [
                        Icon(dept.icon, color: dept.color),
                        const SizedBox(width: 8),
                        Text(dept.name),
                      ],
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() => _selectedDepartment = value!);
            },
          ),
          DropdownButtonFormField<Gender>(
            value: _selectedGender,
            decoration: const InputDecoration(labelText: 'Gender'),
            items: Gender.values
                .map(
                  (gender) => DropdownMenuItem(
                    value: gender,
                    child: Text(gender.name),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() => _selectedGender = value);
            },
          ),
          TextField(
            controller: _gradeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Grade'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveStudent,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
