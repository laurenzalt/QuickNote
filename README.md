# QuickNote

## Author
Laurenz Altendorfer

QuickNote is a simple SwiftUI application designed to efficiently manage notes. It offers basic functionalities such as adding, deleting, and editing notes, with the added ability to attach images to each note. Additionally, the app includes a settings view where users can toggle app settings like notifications and dark mode.

## Features

1. **Note Management**
   - **File**: `NoteListView.swift`
   - Users can add, delete, and view notes within a list. Each note supports a title and content.
   - **Suggested Grade**: 50% for fully functional CRUD operations on notes.

2. **Image Attachment**
   - **File**: `NoteDetailView.swift`
   - Allows users to attach and display images within notes, enhancing the detail and context for each note entry.
   - **Suggested Grade**: 20% for integrating image handling in notes.

3. **Settings Configuration**
   - **File**: `SettingsView.swift`
   - Provides settings that allow users to toggle notifications and dark mode preferences, stored in UserDefaults for persistence.
   - **Suggested Grade**: 10% for implementing user-configurable settings with persistence.

4. **Tab Navigation**
   - **File**: `ContentView.swift`
   - Utilizes a `TabView` for easy navigation between the notes list and settings, improving the user interface and accessibility.
   - **Suggested Grade**: 20% for clean and effective UI navigation.
