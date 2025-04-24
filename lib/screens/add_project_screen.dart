import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/project.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roomController = TextEditingController();
  final _budgetController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newProject = Project(
        id: Uuid().v4(),
        name: _nameController.text,
        room: _roomController.text,
        budget: double.parse(_budgetController.text),
      );
      Navigator.of(context).pop(newProject);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roomController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Project'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Project Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a name' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _roomController,
                decoration: InputDecoration(labelText: 'Room'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a room' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Estimated Budget'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter a budget';
                  final number = double.tryParse(value);
                  return (number == null || number < 0)
                      ? 'Enter a valid number'
                      : null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Save Project'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
