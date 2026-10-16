import SwiftData
import SwiftUI

struct NotesListView: View {
    @Environment(\.modelContext) private var context
    @Environment(NoteAssistant.self) private var assistant
    @Query(sort: \Note.updatedAt, order: .reverse) private var notes: [Note]
    @State private var selection: Note?
    @State private var selectedTag: String?
    @State private var isAddingNote = false

    private var allTags: [String] {
        Array(Set(notes.flatMap(\.tags))).sorted()
    }

    private var filteredNotes: [Note] {
        guard let selectedTag else { return notes }
        return notes.filter { $0.tags.contains(selectedTag) }
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                ForEach(filteredNotes) { note in
                    NavigationLink(value: note) {
                        NoteRow(note: note)
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle(selectedTag.map { "#\($0)" } ?? "Notes")
            .overlay {
                if filteredNotes.isEmpty {
                    ContentUnavailableView("No notes", systemImage: "note.text")
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("New note", systemImage: "square.and.pencil") {
                        isAddingNote = true
                    }
                }
                ToolbarItem {
                    tagFilterMenu
                }
            }
        } detail: {
            if let selection {
                NoteDetailView(note: selection)
            } else {
                ContentUnavailableView("Pick a note", systemImage: "note.text")
            }
        }
        .sheet(isPresented: $isAddingNote) {
            NoteEditorView(note: nil)
        }
    }

    private var tagFilterMenu: some View {
        Menu {
            Picker("Tag", selection: $selectedTag) {
                Text("All notes").tag(String?.none)
                ForEach(allTags, id: \.self) { tag in
                    Text("#\(tag)").tag(String?.some(tag))
                }
            }
            if allTags.isEmpty {
                Text("No tags yet")
            }
        } label: {
            Label(
                "Filter by tag",
                systemImage: selectedTag == nil
                    ? "line.3.horizontal.decrease.circle"
                    : "line.3.horizontal.decrease.circle.fill"
            )
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let note = filteredNotes[index]
            if selection == note {
                selection = nil
            }
            context.delete(note)
        }
    }
}

private struct NoteRow: View {
    let note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(note.title)
                .font(.headline)
            Text(note.summary ?? note.body)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            if !note.tags.isEmpty {
                TagChipsView(tags: note.tags)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NotesListView()
        .modelContainer(.preview)
        .environment(NoteAssistant())
}
