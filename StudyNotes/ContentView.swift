import SwiftData
import SwiftUI

struct ContentView: View {
    var body: some View {
        NotesListView()
    }
}

#Preview {
    ContentView()
        .modelContainer(.preview)
        .environment(NoteAssistant())
}
