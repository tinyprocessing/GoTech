import Foundation

struct Answer: Codable {
    let id: Int
    var text: String
    var isSelected: Bool = false
    var isOther: Bool = false
}

struct SurveyAnswer: Codable {
    let id: Int
    var answers: [Answer] = []
}

struct ResultSurvey: Codable {
    let id: Int
    var userID: String
    var result: [SurveyAnswer]
}

