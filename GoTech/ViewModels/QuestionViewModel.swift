//
//  QuestionViewModel.swift
//  GoTech
//
//  Created by Michael Safir on 22.05.2023.
//

import Foundation

final class QuestionViewModel: NSObject, ObservableObject {
    @Published var question: Question
    
    init(question: Question) {
        self.question = question
    }
    
    func toggleAnswerSelection(_ answer: Answer, clearOther: Bool = true) {
        self.objectWillChange.send()
        guard let index = question.answers.firstIndex(where: { $0.id == answer.id }) else {
            return
        }
        if question.type == .singleChoice || question.type == .singleChoiceWithText{
            clearSelectedAnswers(clearOther: clearOther)
        }
        question.answers[index].isSelected.toggle()
    }
    
    func clearSelectedAnswers(clearOther: Bool) {
        for index in 0..<question.answers.count {
            question.answers[index].isSelected = false
            
            if question.type == .textInput || (question.type == .singleChoiceWithText && question.answers[index].isOther) {
                if clearOther {
                    question.answers[index].text = ""
                }
            }
        }
    }

}
