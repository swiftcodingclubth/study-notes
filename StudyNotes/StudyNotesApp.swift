import SwiftData
import SwiftUI

@main
struct StudyNotesApp: App {
    let container: ModelContainer
    @State private var assistant = NoteAssistant()

    init() {
        do {
            container = try ModelContainer(for: Note.self)
        } catch {
            fatalError("Could not open the notes database: \(error)")
        }
        Note.seedIfNeeded(in: container.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
        .environment(assistant)
    }
}
