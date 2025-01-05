import 'package:flutter/material.dart';

class Department {
  final String id;
  final String name;
  final Color color;
  final IconData icon;

  Department({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });
}

final List<Department> departments = [
  Department(
    id: '1',
    name: 'Finance',
    color: Colors.blue,
    icon: Icons.trending_up,
  ),
  Department(
    id: '2',
    name: 'Law',
    color: Colors.red,
    icon: Icons.gavel,
  ),
  Department(
    id: '3',
    name: 'IT',
    color: Colors.green,
    icon: Icons.computer,
  ),
  Department(
    id: '4',
    name: 'Medical',
    color: Colors.orange,
    icon: Icons.local_hospital,
  ),
];