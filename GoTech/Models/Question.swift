//
//  Question.swift
//  GoTech
//
//  Created by Michael Safir on 22.05.2023.
//

import Foundation

struct Question: Identifiable, Codable, Hashable {
    let id: Int
    let text: String
    let isRequired: Bool
    let type: QuestionType
    var answers: [Answer]
    
    // Add Hashable conformance methods
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Question, rhs: Question) -> Bool {
        return lhs.id == rhs.id
    }
}


enum QuestionType: String, Codable {
    case singleChoice = "singleChoice"
    case singleChoiceWithText = "singleChoiceWithText"
    case multipleChoice = "multipleChoice"
    case textInput = "textInput"
    
    init(from decoder: Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(String.self)
        self = QuestionType(rawValue: rawValue) ?? .textInput
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
