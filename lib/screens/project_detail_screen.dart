import 'package:flutter/material.dart';
import '../models/project.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';

// Screen that displays detailed view of a project and its progress logs
class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  // Opens a dialog to edit a specific log entry
  void _editLogEntry(
      BuildContext context, int logIndex, LogEntry initialEntry) async {
    final result = await showDialog<_LogEditResult>(
      context: context,
      builder: (context) => _AddLogDialog(
        initialEntry: initialEntry,
        allowDelete: true,
      ),
    );

    if (!context.mounted) return;

    if (result != null) {
      final provider = Provider.of<ProjectProvider>(context, listen: false);
      if (result.delete) {
        provider.deleteLogEntry(project.id, logIndex); // Deletes log entry
      } else if (result.updatedEntry != null) {
        provider.updateLogEntry(
            project.id, logIndex, result.updatedEntry!); // Updates log entry
      }
    }
  }

  // Opens a dialog to add a new log entry
  void _addLogEntry(BuildContext context) async {
    final newEntry = await showDialog<LogEntry>(
      context: context,
      builder: (context) => _AddLogDialog(),
    );

    if (!context.mounted) return;

    if (newEntry != null) {
      Provider.of<ProjectProvider>(context, listen: false)
          .addLogEntry(project.id, newEntry); // Adds new log entry
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProjectProvider>(context);
    final updatedProject = provider.getProjectById(project.id)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(updatedProject.name),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        titleSpacing: 0, // Reduces title spacing from back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project details section
            Text('Project Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.room_preferences, color: Colors.blue),
                      title: Text('Room: ${updatedProject.room}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Divider(height: 0),
                    ListTile(
                      leading: Icon(Icons.attach_money, color: Colors.green),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Budget:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(updatedProject.formattedBudget,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Spent:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent)),
                              Text(updatedProject.formattedTotalSpent,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Remaining:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal)),
                              Text(updatedProject.formattedRemaining,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Progress logs section
            Text('Progress Logs',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: updatedProject.logs.isEmpty
                  ? Center(
                      child: Text('No updates yet.')) // Shown if no logs exist
                  : ListView.builder(
                      itemCount: updatedProject.logs.length,
                      itemBuilder: (context, index) {
                        final log = updatedProject.logs[index];
                        return Dismissible(
                          key: Key('${project.id}_$index'),
                          direction:
                              DismissDirection.endToStart, // Swipe to delete
                          background: Container(
                            alignment: Alignment.centerRight,
                            color: Colors.red,
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          confirmDismiss: (direction) async {
                            return await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete Log Entry'),
                                content: Text(
                                    'Are you sure you want to delete this progress log?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                          onDismissed: (direction) {
                            Provider.of<ProjectProvider>(context, listen: false)
                                .deleteLogEntry(project.id,
                                    index); // Delete log from provider
                          },
                          child: GestureDetector(
                            onTap: () => _editLogEntry(
                                context, index, log), // Edit log on tap
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                leading: Icon(Icons.check_circle_outline,
                                    color: Colors.green),
                                title: Text(log.description), // Log description
                                subtitle: Text(
                                    '${log.formattedDate} at ${log.formattedTime}'), // Log timestamp
                                trailing: Text(
                                    '\$${log.cost.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontWeight:
                                            FontWeight.bold)), // Log cost
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addLogEntry(context), // Opens add log entry dialog
        backgroundColor: Colors.indigoAccent,
        tooltip: 'Add Progress Log',
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// Helper class to handle edit or delete operations on logs
class _LogEditResult {
  final LogEntry? updatedEntry;
  final bool delete;

  _LogEditResult({this.updatedEntry, this.delete = false});
}

// Dialog widget for adding or editing a log entry
class _AddLogDialog extends StatefulWidget {
  final LogEntry? initialEntry;
  final bool allowDelete;

  const _AddLogDialog({this.initialEntry, this.allowDelete = false});

  @override
  State<_AddLogDialog> createState() => _AddLogDialogState();
}

class _AddLogDialogState extends State<_AddLogDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _description;
  late String _cost;

  @override
  void initState() {
    super.initState();
    _description = widget.initialEntry?.description ?? '';
    _cost = widget.initialEntry?.cost.toString() ?? '';
  }

  // Submits the form for either adding or updating a log entry
  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final entry = LogEntry(
        description: _description,
        cost: double.parse(_cost),
        timestamp: DateTime.now(),
      );
      if (widget.allowDelete) {
        Navigator.of(context).pop(_LogEditResult(updatedEntry: entry));
      } else {
        Navigator.of(context).pop(entry);
      }
    }
  }

  // Handles deletion of a log entry with confirmation
  void _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this log entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (confirm == true) {
      Navigator.of(context).pop(_LogEditResult(delete: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.initialEntry != null ? 'Edit Log Entry' : 'New Progress Log'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _description,
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Enter a description' : null,
              onSaved: (value) => _description = value!,
            ),
            TextFormField(
              initialValue: _cost,
              decoration: InputDecoration(labelText: 'Cost'),
              keyboardType: TextInputType.number,
              validator: (value) {
                final parsed = double.tryParse(value ?? '');
                return (parsed == null || parsed < 0)
                    ? 'Enter a valid number'
                    : null;
              },
              onSaved: (value) => _cost = value!,
            ),
          ],
        ),
      ),
      actions: [
        if (widget.allowDelete)
          TextButton(
            onPressed: _delete,
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(widget.initialEntry != null ? 'Update' : 'Add Log'),
        ),
      ],
    );
  }
}
