import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/department.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/students_provider.dart';

class NewStudent extends ConsumerStatefulWidget {
  const NewStudent({
    super.key,
    this.studentIndex
  });

  final int? studentIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewStudentState();
}

class _NewStudentState extends ConsumerState<NewStudent> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _gradeController = TextEditingController();
  Department _selectedDepartment = departments[0];
  Gender? _selectedGender;

  @override
  void initState() {
    super.initState();
    if (widget.studentIndex != null) {
      final student = ref.read(studentsProvider).students[widget.studentIndex!];
      _nameController.text = student.firstName;
      _surnameController.text = student.lastName;
      _gradeController.text = student.grade.toString();
      _selectedGender = student.gender;
      _selectedDepartment = student.department;
    }
  }

  void _saveStudent() async {
    if (_selectedDepartment == null || _selectedGender == null) return;

    if (widget.studentIndex != null) {
      await ref.read(studentsProvider.notifier).updateStudent(
            widget.studentIndex!,
            _nameController.text.trim(),
            _surnameController.text.trim(),
            _selectedDepartment,
            _selectedGender,
            int.tryParse(_gradeController.text) ?? 0,
          );
    } else {
      await ref.read(studentsProvider.notifier).addStudent(
            _nameController.text.trim(),
            _surnameController.text.trim(),
            _selectedDepartment,
            _selectedGender,
            int.tryParse(_gradeController.text) ?? 0,
          );
    }

    if (!context.mounted) return;

    Navigator.of(context).pop();
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
