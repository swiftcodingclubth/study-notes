import Foundation
import Observation

@Observable @MainActor
final class NoteAssistant {
    var isWorking = false

    // TODO: Part 1
    func summarize(_ note: Note, creative: Bool) async throws {
    }

    // TODO: Part 2a
    func makeCard(for note: Note) async throws {
    }

    // TODO: Part 2b
    func planReview(for note: Note, request: String) async throws {
    }

    // TODO: Part 3
    func tag(_ note: Note) async {
    }

    // TODO: Part 4 (ChatView.swift and StudyChat.swift)
}
