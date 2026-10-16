import SwiftData
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Notes", systemImage: "note.text") {
                NotesListView()
            }
            Tab("Ask my notes", systemImage: "bubble.left.and.bubble.right") {
                ChatView()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(.preview)
        .environment(NoteAssistant())
}
