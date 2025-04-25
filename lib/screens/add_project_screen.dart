import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/project.dart';

// Screen for adding a new project
class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

// State class for AddProjectScreen
class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for the project form
  final _nameController =
      TextEditingController(); // Controller for project name input
  final _roomController = TextEditingController(); // Controller for room input
  final _budgetController =
      TextEditingController(); // Controller for budget input

  // Handles form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newProject = Project(
        id: Uuid().v4(), // Generates a unique ID for the project
        name: _nameController.text, // Project name from input
        room: _roomController.text, // Room from input
        budget: double.parse(_budgetController.text), // Budget from input
      );
      Navigator.of(context)
          .pop(newProject); // Returns the new project back to the caller
    }
  }

  @override
  void dispose() {
    // Disposes of the controllers when the widget is destroyed
    _nameController.dispose();
    _roomController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Project'), // AppBar title
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adds padding around the form
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Input for project name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Project Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a name' : null,
              ),
              SizedBox(height: 16),
              // Input for room name
              TextFormField(
                controller: _roomController,
                decoration: InputDecoration(labelText: 'Room'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a room' : null,
              ),
              SizedBox(height: 16),
              // Input for estimated budget
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
              // Button to save the new project
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