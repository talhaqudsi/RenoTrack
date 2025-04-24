import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renotrack/about.dart';
import 'package:renotrack/screens/add_project_screen.dart';
import 'package:renotrack/screens/project_detail_screen.dart';
import 'package:renotrack/models/project.dart';
import 'package:renotrack/providers/project_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProjectProvider(),
      child: RenoTrackApp(),
    ),
  );
}

class RenoTrackApp extends StatelessWidget {
  const RenoTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RenoTrack',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ProjectManager(),
        '/add_project': (context) => AddProjectScreen(),
        '/about': (context) => About(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/project_detail') {
          final projectId = settings.arguments as String;
          final project = Provider.of<ProjectProvider>(context, listen: false)
              .getProjectById(projectId);
          return MaterialPageRoute(
            builder: (context) => ProjectDetailScreen(project: project!),
          );
        }
        return null;
      },
    );
  }
}

class ProjectManager extends StatelessWidget {
  const ProjectManager({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProjectProvider>(context);
    final projects = provider.projects;

    return Scaffold(
      appBar: AppBar(
        title: Text('RenoTrack Projects'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
        ],
      ),
      body: projects.isEmpty
          ? Center(child: Text('No projects yet. Tap + to add one.'))
          : ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return Dismissible(
                  key: Key(project.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Project'),
                        content: Text(
                            'Are you sure you want to delete this project? All logs will be lost.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) {
                    provider.deleteProject(project.id);
                  },
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/project_detail',
                      arguments: project.id,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      child: ListTile(
                        leading: Icon(Icons.home_repair_service,
                            color: Colors.blue),
                        title: Text(project.name,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Room: ${project.room}'),
                            Text('Budget: ${project.formattedBudget}'),
                            Text('Spent: ${project.formattedTotalSpent}',
                                style: TextStyle(color: Colors.redAccent)),
                            Text('Remaining: ${project.formattedRemaining}',
                                style: TextStyle(color: Colors.teal)),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newProject = await Navigator.push<Project>(
            context,
            MaterialPageRoute(builder: (context) => AddProjectScreen()),
          );
          if (newProject != null) {
            provider.addProject(newProject);
          }
        },
        backgroundColor: Colors.indigoAccent,
        tooltip: 'Add Project',
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
