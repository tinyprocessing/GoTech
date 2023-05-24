import Foundation

struct Survey: Identifiable, Hashable  {
    let id: String
    let title: String
    let questions: [QuestionViewModel]
}
