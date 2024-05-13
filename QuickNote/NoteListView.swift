import SwiftUI

@main
struct QuickNote: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            NoteListView()
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct NoteListView: View {
    @AppStorage("notes") private var notesData = Data()
    @State private var notes: [Note] = []
    @State private var newNoteTitle: String = ""

    init() {
        _notes = State(initialValue: (try? JSONDecoder().decode([Note].self, from: notesData)) ?? [])
    }

    var body: some View {
        NavigationView {
            List {
                TextField("New note title", text: $newNoteTitle, onCommit: addNote)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                ForEach($notes) { $note in
                    NavigationLink(destination: NoteDetailView(note: $note).animation(.easeInOut, value: note.title)) {
                        Text(note.title)
                    }
                }
                .onDelete(perform: deleteNote)
            }
            .navigationTitle("QuickNote")
            .toolbar {
                EditButton()
            }
        }
    }

    private func addNote() {
        guard !newNoteTitle.isEmpty else { return }
        let newNote = Note(title: newNoteTitle, content: "")
        notes.append(newNote)
        newNoteTitle = ""
        saveNotes()
    }

    private func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        saveNotes()
    }

    private func saveNotes() {
        notesData = (try? JSONEncoder().encode(notes)) ?? Data()
    }
}

struct SettingsView: View {
    @AppStorage("enableNotifications") var enableNotifications: Bool = false
    @AppStorage("useDarkMode") var useDarkMode: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General Settings")) {
                    Toggle("Enable Notifications", isOn: $enableNotifications)
                    Toggle("Use Dark Mode", isOn: $useDarkMode)
                }
            }
            .navigationTitle("Settings")
        }
    }
}



struct NoteDetailView: View {
    @Binding var note: Note
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?

    var body: some View {
        Form {
            TextField("Title", text: $note.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextEditor(text: $note.content)
                .frame(minHeight: 200)
                .placeholder(when: note.content.isEmpty) {
                    Text("Enter content here").foregroundColor(.gray)
                }
            if let imageData = note.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            }
            Button("Select Image") {
                showingImagePicker = true
            }
        }
        .navigationTitle("Edit Note")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            CustomImagePicker(selectedImage: $inputImage)
        }
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }
        note.imageData = inputImage.jpegData(compressionQuality: 1.0)
    }
}

extension View {
    @ViewBuilder
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

