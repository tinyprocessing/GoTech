//
//  QuestionViewModel.swift
//  GoTech
//
//  Created by Michael Safir on 22.05.2023.
//

import Foundation

class QuestionViewModel: NSObject, ObservableObject {
    @Published var question: Question
    @Published var answerText: String = ""
    @Published var isAnswered: Bool = false
    @Published var errorMessage: String = ""
    @Published var showErrorMessage: Bool = false
    
    private var surveyResult: SurveyResult?
    
    init(question: Question, surveyResult: SurveyResult? = nil) {
        self.question = question
        self.surveyResult = surveyResult
    }
    
    func toggleAnswerSelection(_ answer: Answer) {
        self.objectWillChange.send()
        guard let index = question.answers.firstIndex(where: { $0.id == answer.id }) else {
            return
        }
        if question.type == .singleChoice || question.type == .singleChoiceWithText{
            clearSelectedAnswers()
        }
        question.answers[index].isSelected.toggle()
    }
    
    func clearSelectedAnswers() {
        for index in 0..<question.answers.count {
            question.answers[index].isSelected = false
        }
    }

    
    private func validateAnswer() -> Bool {
        if question.isRequired && !isAnswered {
            errorMessage = "This question is required"
            showErrorMessage = true
            return false
        }
        return true
    }

}
