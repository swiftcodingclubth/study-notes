import SwiftData
import SwiftUI

enum SummaryStyle: String, CaseIterable, Identifiable {
    case precise = "Precise"
    case creative = "Creative"

    var id: Self { self }
}

struct NoteDetailView: View {
    @Environment(NoteAssistant.self) private var assistant
    let note: Note
    @State private var style: SummaryStyle = .precise
    @State private var isEditing = false
    @State private var isPlanningReview = false
    @State private var reviewRequest = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                aiButtons

                if let summary = note.summary {
                    GroupBox("Summary") {
                        Text(summary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                // if let card = assistant.card {
                //     StudyCardView(card: card)
                // }

                // if let message = assistant.reviewMessage {
                //     Label(message, systemImage: "bell.badge")
                //         .foregroundStyle(.secondary)
                // }

                Text(note.body)
                    .textSelection(.enabled)
            }
            .padding()
            .frame(maxWidth: 720, alignment: .leading)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle(note.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Edit") {
                isEditing = true
            }
        }
        .sheet(isPresented: $isEditing) {
            NoteEditorView(note: note)
        }
        .alert("Plan review", isPresented: $isPlanningReview) {
            TextField("Remind me tomorrow at 8pm", text: $reviewRequest)
            Button("Cancel", role: .cancel) {
                reviewRequest = ""
            }
            Button("Plan") {
                let request = reviewRequest
                reviewRequest = ""
                Task { try? await assistant.planReview(for: note, request: request) }
            }
        } message: {
            Text("When do you want to review this note?")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(note.title)
                .font(.largeTitle.bold())
            Text(note.updatedAt, format: .dateTime.day().month().year().hour().minute())
                .font(.subheadline)
                .foregroundStyle(.secondary)
            if !note.tags.isEmpty {
                TagChipsView(tags: note.tags)
            }
        }
    }

    private var aiButtons: some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker("Style", selection: $style) {
                ForEach(SummaryStyle.allCases) { style in
                    Text(style.rawValue).tag(style)
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 280)

            HStack {
                Button("Summarize", systemImage: "sparkles") {
                    Task { try? await assistant.summarize(note, creative: style == .creative) }
                }
                Button("Study card", systemImage: "rectangle.on.rectangle.angled") {
                    Task { try? await assistant.makeCard(for: note) }
                }
                Button("Plan review", systemImage: "bell") {
                    isPlanningReview = true
                }
                if assistant.isWorking {
                    ProgressView()
                        .padding(.leading, 4)
                }
            }
            .buttonStyle(.bordered)
            .disabled(assistant.isWorking)
        }
    }
}

#Preview {
    NavigationStack {
        NoteDetailView(note: .preview)
    }
    .modelContainer(.preview)
    .environment(NoteAssistant())
}
