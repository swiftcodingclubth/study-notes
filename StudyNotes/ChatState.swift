import Foundation
import Observation

enum ChatMode { case ask, quiz }

@Observable final class ChatState { var mode: ChatMode = .ask }

struct ChatMessage: Identifiable {
    enum Role { case user, assistant }

    let id = UUID()
    let role: Role
    let text: String
}
