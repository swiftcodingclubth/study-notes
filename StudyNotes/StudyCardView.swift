// import SwiftUI
//
// struct StudyCardView: View {
//     let card: StudyCard.PartiallyGenerated
//     @State private var revealedAnswers: Set<Int> = []
//
//     var body: some View {
//         VStack(alignment: .leading, spacing: 16) {
//             HStack(alignment: .firstTextBaseline) {
//                 Text(card.title ?? "…")
//                     .font(.title2.bold())
//                 Spacer()
//                 if let difficulty = card.difficulty {
//                     Text("Difficulty \(difficulty)/5")
//                         .font(.caption.weight(.semibold))
//                         .padding(.horizontal, 8)
//                         .padding(.vertical, 4)
//                         .background(.orange.opacity(0.2), in: .capsule)
//                 }
//             }
//
//             if let keyPoints = card.keyPoints, !keyPoints.isEmpty {
//                 VStack(alignment: .leading, spacing: 8) {
//                     Text("Key points")
//                         .font(.headline)
//                     ForEach(Array(keyPoints.enumerated()), id: \.offset) { _, point in
//                         Label(point, systemImage: "checkmark.circle")
//                     }
//                 }
//             }
//
//             if let questions = card.questions, !questions.isEmpty {
//                 VStack(alignment: .leading, spacing: 12) {
//                     Text("Test yourself")
//                         .font(.headline)
//                     ForEach(Array(questions.enumerated()), id: \.offset) { index, item in
//                         VStack(alignment: .leading, spacing: 4) {
//                             Text(item.question ?? "…")
//                             if revealedAnswers.contains(index) {
//                                 Text(item.answer ?? "…")
//                                     .foregroundStyle(.secondary)
//                             } else {
//                                 Button("Show answer") {
//                                     revealedAnswers.insert(index)
//                                 }
//                                 .font(.callout)
//                             }
//                         }
//                     }
//                 }
//             }
//         }
//         .padding()
//         .frame(maxWidth: .infinity, alignment: .leading)
//         .background(.thinMaterial, in: .rect(cornerRadius: 16))
//     }
// }
//
// #Preview {
//     StudyCardView(card: StudyCard(
//         title: "Plants Make Food from Light",
//         keyPoints: [
//             "Photosynthesis happens in chloroplasts.",
//             "Light reactions release oxygen.",
//             "The Calvin cycle builds glucose.",
//         ],
//         questions: [
//             QuizQuestion(question: "Where does the Calvin cycle happen?", answer: "In the stroma."),
//             QuizQuestion(question: "Which gas is released?", answer: "Oxygen."),
//         ],
//         difficulty: 2
//     ).asPartiallyGenerated())
//     .padding()
// }
