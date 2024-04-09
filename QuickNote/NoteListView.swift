import SwiftUI

@main
struct QuickNote: App {
    var body: some Scene {
        WindowGroup {
            NoteListView()
        }
    }
}

struct NoteListView: View {
    @AppStorage("notes") private var notesData = Data()
    @State private var notes: [Note] = []
    @State private var newNoteTitle: String = ""

    // Initialize notes from stored data
    init() {
        _notes = State(initialValue: (try? JSONDecoder().decode([Note].self, from: notesData)) ?? [])
    }

    var body: some View {
        NavigationView {
            List {
                TextField("New note title", text: $newNoteTitle, onCommit: addNote)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                ForEach($notes) { $note in
                    NavigationLink(destination: NoteDetailView(note: $note).animation(.easeInOut)) {
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
        print("Adding note: \(newNoteTitle)") // Debug print
        newNoteTitle = ""
        print("New note title cleared: \(newNoteTitle)") // Debug print
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

struct NoteDetailView: View {
    @Binding var note: Note
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?

    var body: some View {
        Form {
            TextField("Title", text: $note.title)
            TextEditor(text: $note.content)
                .frame(minHeight: 200)
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
