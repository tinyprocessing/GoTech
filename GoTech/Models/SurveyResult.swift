//
//  SurveyResult.swift
//  GoTech
//
//  Created by Michael Safir on 22.05.2023.
//

import Foundation

struct SurveyResult: Codable {
    let surveyID: String
    let answers: [QuestionResult]
}

struct QuestionResult: Codable {
    let questionID: String
    let answer: String?
}
