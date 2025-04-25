# RenoTrack

RenoTrack is a mobile application built with Flutter designed to help homeowners, contractors, and renovators track the progress and expenses of home renovation projects. The app allows users to create projects, log updates, manage budgets, and monitor overall project status in an organized and intuitive way.

---

## Features

- Create, edit, and delete renovation projects
- Log progress updates with descriptions, timestamps, and costs
- Automatically calculate total spent and remaining budget
- View detailed project summaries and progress logs
- Swipe to delete projects and logs
- Persistent data storage using Shared Preferences
- Modern, responsive design with Material 3 theming
- Dummy data generation for testing and demonstration
- Custom splash screen and app launcher icon

---

## Screens

- **Project Manager Screen**: View all existing projects with quick budget summaries
- **Add Project Screen**: Create a new project by entering project name, associated room, and estimated budget
- **Project Detail Screen**: View project details and progress logs; add, edit, or delete logs
- **About Screen**: Brief overview of the app's purpose

---

## Technology Stack

- Flutter 3.19+
- Dart 3.6+
- Provider for state management
- Shared Preferences for local storage
- UUID package for unique ID generation
- Intl package for date and time formatting

---

## Installation

1. Ensure Flutter SDK is installed and properly configured.
2. Clone the repository:
   ```
   git clone <repository_url>
   cd renotrack
   ```
3. Install dependencies:
   ```
   flutter pub get
   ```
4. Run the app:
   ```
   flutter run
   ```

---

## Project Structure

```
lib/
├── models/                # Data models (Project, LogEntry)
├── providers/             # State management (ProjectProvider)
├── screens/               # UI screens (AboutScreen, AddProjectScreen, ProjectDetailScreen)
├── utils/                 # Utility scripts (populateDummyData)
├── assets/                # App icons and logos
└── main.dart              # Application entry point
```

---

## Development Notes

- **App Icon and Splash**: Managed using `flutter_launcher_icons` and `flutter_native_splash` packages.
- **Persistence**: Project data is serialized to JSON and stored locally using Shared Preferences.
- **State Management**: Provider is used to manage the project list and notify UI of changes.
- **Validation**: Form fields include input validation to ensure reliable project and log creation.

---

## Future Enhancements

- Add project categories and tags
- Export logs to PDF or CSV
- Cloud sync and multi-device support
- Notification reminders for project deadlines
- Enhanced dashboard and reporting

---

## License

This project is for educational and demonstration purposes. Contact the project owner for licensing inquiries if intended for production use.

---