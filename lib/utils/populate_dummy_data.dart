import 'package:provider/provider.dart';
import '../models/project.dart';
import '../providers/project_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

void populateDummyData(context) {
  final provider = Provider.of<ProjectProvider>(context, listen: false);
  final uuid = Uuid();
  final random = Random();

  List<String> roomNames = [
    'Kitchen',
    'Bathroom',
    'Living Room',
    'Bedroom',
    'Garage',
    'Office',
    'Basement'
  ];

  List<String> logDescriptions = [
    'Painted walls',
    'Installed new lights',
    'Fixed plumbing issue',
    'Laid new flooring',
    'Replaced cabinets',
    'Mounted shelves',
    'Installed smart thermostat'
  ];

  for (int i = 0; i < 3; i++) {
    final project = Project(
      id: uuid.v4(),
      name: 'Project ${i + 1}',
      room: roomNames[random.nextInt(roomNames.length)],
      budget: (5000 + random.nextInt(5000)).toDouble(),
      logs: List.generate(
        random.nextInt(5) + 1, // Between 1 and 5 logs
        (index) => LogEntry(
          description: logDescriptions[random.nextInt(logDescriptions.length)],
          cost: (50 + random.nextInt(450)).toDouble(),
          timestamp:
              DateTime.now().subtract(Duration(days: random.nextInt(60))),
        ),
      ),
    );

    provider.addProject(project);
  }
}
