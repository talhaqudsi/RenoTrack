import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';

class ProjectProvider extends ChangeNotifier {
  final List<Project> _projects = [];

  List<Project> get projects => List.unmodifiable(_projects);

  static const _storageKey = 'projects';

  ProjectProvider() {
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_storageKey) ?? [];
    _projects.clear();
    _projects.addAll(stored.map((e) => Project.fromJson(jsonDecode(e))));
    notifyListeners();
  }

  Future<void> _saveProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _projects.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList(_storageKey, encoded);
  }

  void addProject(Project project) {
    _projects.add(project);
    _saveProjects();
    notifyListeners();
  }

  void addLogEntry(String projectId, LogEntry entry) {
    final index = _projects.indexWhere((p) => p.id == projectId);
    if (index != -1) {
      final project = _projects[index];
      final updatedLogs = List<LogEntry>.from(project.logs)..add(entry);
      _projects[index] = project.copyWith(logs: updatedLogs);
      _saveProjects();
      notifyListeners();
    }
  }

  void updateLogEntry(String projectId, int logIndex, LogEntry updatedEntry) {
    final index = _projects.indexWhere((p) => p.id == projectId);
    if (index != -1 && logIndex < _projects[index].logs.length) {
      final project = _projects[index];
      final updatedLogs = List<LogEntry>.from(project.logs);
      updatedLogs[logIndex] = updatedEntry;
      _projects[index] = project.copyWith(logs: updatedLogs);
      _saveProjects();
      notifyListeners();
    }
  }

  void deleteLogEntry(String projectId, int logIndex) {
    final index = _projects.indexWhere((p) => p.id == projectId);
    if (index != -1 && logIndex < _projects[index].logs.length) {
      final project = _projects[index];
      final updatedLogs = List<LogEntry>.from(project.logs)..removeAt(logIndex);
      _projects[index] = project.copyWith(logs: updatedLogs);
      _saveProjects();
      notifyListeners();
    }
  }

  void deleteProject(String projectId) {
    _projects.removeWhere((p) => p.id == projectId);
    _saveProjects();
    notifyListeners();
  }

  Project? getProjectById(String id) {
    try {
      return _projects.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
