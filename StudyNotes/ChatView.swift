import SwiftData
import SwiftUI

struct ChatView: View {
    @State private var chatState = ChatState()
    @State private var messages: [ChatMessage] = []
    @State private var draft = ""

    var body: some View {
        NavigationStack {
            chat
                .navigationTitle("Ask my notes")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Picker("Mode", selection: $chatState.mode) {
                            Text("Ask").tag(ChatMode.ask)
                            Text("Quiz").tag(ChatMode.quiz)
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 180)
                    }
                }
        }
    }

    private var chat: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }
            .defaultScrollAnchor(.bottom)
            .overlay {
                if messages.isEmpty {
                    ContentUnavailableView(
                        chatState.mode == .ask ? "Ask about your notes" : "Get quizzed on your notes",
                        systemImage: chatState.mode == .ask ? "text.magnifyingglass" : "questionmark.bubble",
                        description: Text(chatState.mode == .ask
                            ? "Try \"What did I write about photosynthesis?\""
                            : "Try \"Quiz me on history\"")
                    )
                }
            }

            Divider()

            HStack(spacing: 12) {
                TextField("Message", text: $draft)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit(submit)
                Button("Send", systemImage: "arrow.up.circle.fill", action: submit)
                    .labelStyle(.iconOnly)
                    .font(.title)
                    .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
        }
    }

    private func submit() {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        draft = ""
        Task { await send(text) }
    }

    // TODO: Part 4
    func send(_ text: String) async {
    }
}

private struct MessageBubble: View {
    let message: ChatMessage

    private var isUser: Bool { message.role == .user }

    var body: some View {
        HStack {
            if isUser { Spacer(minLength: 80) }
            Text(message.text)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(isUser ? AnyShapeStyle(.tint) : AnyShapeStyle(.fill.secondary), in: .rect(cornerRadius: 18))
                .foregroundStyle(isUser ? .white : .primary)
                .textSelection(.enabled)
            if !isUser { Spacer(minLength: 80) }
        }
    }
}

#Preview {
    ChatView()
        .modelContainer(.preview)
        .environment(NoteAssistant())
}
