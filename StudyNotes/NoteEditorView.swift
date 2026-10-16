import SwiftData
import SwiftUI

struct NoteEditorView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(NoteAssistant.self) private var assistant
    let existing: Note?
    @State private var title: String
    @State private var text: String

    init(note: Note?) {
        existing = note
        _title = State(initialValue: note?.title ?? "")
        _text = State(initialValue: note?.body ?? "")
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Photosynthesis", text: $title)
                }
                Section("Note") {
                    TextEditor(text: $text)
                        .frame(minHeight: 320)
                }
            }
            .navigationTitle(existing == nil ? "New note" : "Edit note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .disabled(!canSave)
                }
            }
        }
    }

    private func save() {
        let note = existing ?? Note(title: title, body: text)
        if note.body != text {
            note.summary = nil
        }
        note.title = title
        note.body = text
        note.updatedAt = .now
        if existing == nil {
            context.insert(note)
        }

        dismiss()
    }
}

#Preview("New note") {
    NoteEditorView(note: nil)
        .modelContainer(.preview)
        .environment(NoteAssistant())
}

#Preview("Edit note") {
    NoteEditorView(note: .preview)
        .modelContainer(.preview)
        .environment(NoteAssistant())
}
