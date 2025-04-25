import 'package:intl/intl.dart';

// Represents a single progress log entry within a project
class LogEntry {
  final String description; // Description of the log entry
  final double cost; // Cost associated with this log entry
  final DateTime timestamp; // Timestamp when the log entry was recorded

  LogEntry({
    required this.description,
    required this.cost,
    required this.timestamp,
  });

  // Returns the date formatted as 'Month day, year' (e.g., Apr 24, 2025)
  String get formattedDate => DateFormat('MMM d, yyyy').format(timestamp);

  // Returns the time formatted as 'hour:minute AM/PM' (e.g., 4:30 PM)
  String get formattedTime => DateFormat('h:mm a').format(timestamp);

  // Serializes the LogEntry to a JSON-compatible Map
  Map<String, dynamic> toJson() => {
        'description': description,
        'cost': cost,
        'timestamp': timestamp.toIso8601String(),
      };

  // Creates a LogEntry instance from a JSON map
  factory LogEntry.fromJson(Map<String, dynamic> json) => LogEntry(
        description: json['description'],
        cost: json['cost'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}

// Represents a project that contains multiple progress logs
class Project {
  final String id; // Unique identifier for the project
  final String name; // Name of the project
  final String room; // Room associated with the project
  final double budget; // Budget allocated for the project
  final List<LogEntry> logs; // List of progress logs for the project

  Project({
    required this.id,
    required this.name,
    required this.room,
    required this.budget,
    List<LogEntry>? logs,
  }) : logs = logs ?? [];

  // Calculates the total amount spent based on the logs
  double get totalSpent => logs.fold(0.0, (sum, log) => sum + log.cost);

  // Calculates the remaining budget after spending
  double get remainingBudget => budget - totalSpent;

  // Formats the total budget as a currency string
  String get formattedBudget => '\$${budget.toStringAsFixed(2)}';

  // Formats the total spent amount as a currency string
  String get formattedTotalSpent => '\$${totalSpent.toStringAsFixed(2)}';

  // Formats the remaining budget as a currency string
  String get formattedRemaining => '\$${remainingBudget.toStringAsFixed(2)}';

  // Creates a copy of the project with optional overrides
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

  // Serializes the Project into a JSON-compatible Map
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'room': room,
        'budget': budget,
        'logs': logs.map((log) => log.toJson()).toList(),
      };

  // Creates a Project instance from a JSON map
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
