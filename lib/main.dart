import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renotrack/screens/about_screen.dart';
import 'package:renotrack/screens/add_project_screen.dart';
import 'package:renotrack/screens/project_detail_screen.dart';
import 'package:renotrack/models/project.dart';
import 'package:renotrack/providers/project_provider.dart';
import 'package:renotrack/utils/populate_dummy_data.dart';

// Entry point of the application
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) =>
          ProjectProvider(), // Provides ProjectProvider to the widget tree
      child: RenoTrackApp(),
    ),
  );
}

// Main application widget
class RenoTrackApp extends StatelessWidget {
  const RenoTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      title: 'RenoTrack', // Application title
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo), // Application color theme
      ),
      initialRoute: '/', // Initial route when the app starts
      routes: {
        '/': (context) => ProjectManager(), // Home screen
        '/add_project': (context) => AddProjectScreen(), // Add project screen
        '/about': (context) => AboutScreen(), // About page
      },
      onGenerateRoute: (settings) {
        // Check if the requested route is '/project_detail'
        if (settings.name == '/project_detail') { // Retrieve the project ID passed as an argument
          final projectId = settings.arguments as String;
          final project = Provider.of<ProjectProvider>(context, listen: false)
              .getProjectById(projectId); // Fetch the corresponding project from the provider
          return MaterialPageRoute(
            builder: (context) => ProjectDetailScreen(project: project!), // Navigate to the ProjectDetailScreen
          );
        }
        return null;
      },
    );
  }
}

// Main screen that lists all projects
class ProjectManager extends StatelessWidget {
  const ProjectManager({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProjectProvider>(context);
    final projects = provider.projects;

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            populateDummyData(
                context); // Populates dummy data when title is tapped
          },
          child: Row(
            children: [
              Image.asset(
                'assets/icon/app_icon.png', // Displays app logo
                height: 32,
              ),
              SizedBox(width: 12),
              Text('Projects'), // Title next to the logo
            ],
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => Navigator.pushNamed(
                context, '/about'), // Navigates to About screen
          ),
        ],
      ),
      body: projects.isEmpty
          ? Center(
              child: Text(
                  'No projects yet. Tap + to add one.')) // Message when no projects
          : ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return Dismissible(
                  key: Key(project.id),
                  direction: DismissDirection.endToStart, // Swipe to delete
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
                            onPressed: () => Navigator.of(context)
                                .pop(false), // Cancel deletion
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context)
                                .pop(true), // Confirm deletion
                            child: Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) {
                    provider.deleteProject(project.id);
                    ScaffoldMessenger.of(context).showSnackBar( // Snackbar deletion confirmation message
                      SnackBar(content: Text('Deleted Project: "${project.name}"')),
                    );
                  },
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/project_detail',
                      arguments:
                          project.id, // Navigates to project detail screen
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      child: ListTile(
                        leading: Icon(Icons.home_repair_service,
                            color: Colors.blue), // Icon for each project
                        title: Text(project.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold)), // Project name
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Room: ${project.room}'), // Room information
                            Text(
                                'Budget: ${project.formattedBudget}'), // Budget amount
                            Text('Spent: ${project.formattedTotalSpent}',
                                style: TextStyle(
                                    color: Colors.redAccent)), // Amount spent
                            Text('Remaining: ${project.formattedRemaining}',
                                style: TextStyle(
                                    color: Colors.teal)), // Remaining budget
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            size: 16), // Forward arrow
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
            MaterialPageRoute(
                builder: (context) =>
                    AddProjectScreen()), // Opens add project screen
          );
          if (newProject != null) {
            provider
                .addProject(newProject); // Adds the new project to the provider
          }
        },
        backgroundColor: Colors.indigoAccent,
        tooltip: 'Add Project',
        child: Icon(Icons.add, color: Colors.white), // Add project button
      ),
    );
  }
}
