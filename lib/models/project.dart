import 'package:intl/intl.dart';

class LogEntry {
  final String description;
  final double cost;
  final DateTime timestamp;

  LogEntry({
    required this.description,
    required this.cost,
    required this.timestamp,
  });

  String get formattedDate => DateFormat('MMM d, yyyy').format(timestamp);
  String get formattedTime => DateFormat('h:mm a').format(timestamp);

  Map<String, dynamic> toJson() => {
        'description': description,
        'cost': cost,
        'timestamp': timestamp.toIso8601String(),
      };

  factory LogEntry.fromJson(Map<String, dynamic> json) => LogEntry(
        description: json['description'],
        cost: json['cost'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}

class Project {
  final String id;
  final String name;
  final String room;
  final double budget;
  final List<LogEntry> logs;

  Project({
    required this.id,
    required this.name,
    required this.room,
    required this.budget,
    List<LogEntry>? logs,
  }) : logs = logs ?? [];

  double get totalSpent => logs.fold(0.0, (sum, log) => sum + log.cost);

  double get remainingBudget => budget - totalSpent;

  String get formattedBudget => '\$${budget.toStringAsFixed(2)}';
  String get formattedTotalSpent => '\$${totalSpent.toStringAsFixed(2)}';
  String get formattedRemaining => '\$${remainingBudget.toStringAsFixed(2)}';

  Project copyWith({
    String? id,
    String? name,
    String? room,
    double? budget,
    List<LogEntry>? logs,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      room: room ?? this.room,
      budget: budget ?? this.budget,
      logs: logs ?? this.logs,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'room': room,
        'budget': budget,
        'logs': logs.map((log) => log.toJson()).toList(),
      };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['id'],
        name: json['name'],
        room: json['room'],
        budget: (json['budget'] as num).toDouble(),
        logs: (json['logs'] as List<dynamic>)
            .map((logJson) => LogEntry.fromJson(logJson))
            .toList(),
      );
}
