import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';

// Provider class responsible for managing the list of projects
class ProjectProvider extends ChangeNotifier {
  final List<Project> _projects = []; // Internal list of projects

  // Public getter to access an unmodifiable view of the projects list
  List<Project> get projects => List.unmodifiable(_projects);

  static const _storageKey =
      'projects'; // Key for storing projects in SharedPreferences

  // Constructor that loads projects when the provider is initialized
  ProjectProvider() {
    _loadProjects();
  }

  // Loads the projects from SharedPreferences
  Future<void> _loadProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_storageKey) ?? [];
    _projects.clear();
    _projects.addAll(stored.map(
        (e) => Project.fromJson(jsonDecode(e)))); // Deserialize each project
    notifyListeners(); // Notify UI listeners after loading
  }

  // Saves the current list of projects to SharedPreferences
  Future<void> _saveProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _projects
        .map((p) => jsonEncode(p.toJson()))
        .toList(); // Serialize each project
    await prefs.setStringList(_storageKey, encoded);
  }

  // Adds a new project to the list
  void addProject(Project project) {
    _projects.add(project);
    _saveProjects();
    notifyListeners();
  }

  // Adds a new log entry to a specific project
  void addLogEntry(String projectId, LogEntry entry) {
    final index = _projects.indexWhere((p) => p.id == projectId);
    if (index != -1) {
      final project = _projects[index];
      final updatedLogs = List<LogEntry>.from(project.logs)
        ..add(entry); // Clone and update logs
      _projects[index] = project.copyWith(
          logs: updatedLogs); // Replace the project with updated logs
      _saveProjects();
      notifyListeners();
    }
  }

  // Updates an existing log entry for a specific project
  void updateLogEntry(String projectId, int logIndex, LogEntry updatedEntry) {
    final index = _projects.indexWhere((p) => p.id == projectId);
    if (index != -1 && logIndex < _projects[index].logs.length) {
      final project = _projects[index];
      final updatedLogs = List<LogEntry>.from(project.logs);
      updatedLogs[logIndex] = updatedEntry; // Update the specific log
      _projects[index] = project.copyWith(logs: updatedLogs);
      _saveProjects();
      notifyListeners();
    }
  }

  // Deletes a specific log entry from a project
  void deleteLogEntry(String projectId, int logIndex) {
    final index = _projects.indexWhere((p) => p.id == projectId);
    if (index != -1 && logIndex < _projects[index].logs.length) {
      final project = _projects[index];
      final updatedLogs = List<LogEntry>.from(project.logs)
        ..removeAt(logIndex); // Remove the log
      _projects[index] = project.copyWith(logs: updatedLogs);
      _saveProjects();
      notifyListeners();
    }
  }

  // Deletes an entire project based on its ID
  void deleteProject(String projectId) {
    _projects.removeWhere((p) => p.id == projectId);
    _saveProjects();
    notifyListeners();
  }

  // Retrieves a project by its ID, or returns null if not found
  Project? getProjectById(String id) {
    try {
      return _projects.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
