//
//  SurveyViewModel.swift
//  GoTech
//
//  Created by Michael Safir on 22.05.2023.
//

import Foundation
import Combine

class SurveyViewModel: NSObject, ObservableObject {
    @Published var survey: Survey?
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    private let apiService: APIService
    
    let objectWillChange = PassthroughSubject<Void, Never>()

    
    init(apiService: APIService = APIService.shared) {
        self.apiService = apiService
    }
    
    func loadSurvey() {
        fetchSurvey()
    }
    
    func fetchSurvey() {
        isLoading = true
        errorMessage = ""
        apiService.fetchSurvey { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false

                switch result {
                case .success(let survey):
                    self.objectWillChange.send()
                    self.survey = survey
                case .failure(let error):
                    self.objectWillChange.send()
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func submitSurveyResult(result: SurveyResult) {
        isLoading = true
        errorMessage = ""
        
        apiService.submitSurveyResult(result) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success:
                    // Опрос успешно отправлен
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func hasSelectedAnswer(answers: [Answer]) -> Bool {
        return answers.contains { $0.isSelected }
    }
    
    func validateSurvey() -> Bool {
        if let survey = self.survey {
            for question in survey.questions {
                if question.question.isRequired && !hasSelectedAnswer(answers: question.question.answers) {
                    return false
                }
                
//                if !hasSelectedAnswer(answers: question.question.answers) {
//                    return false
//                }
                
                if question.question.type == .singleChoiceWithText {
                    var status : Bool = true
                    question.question.answers.forEach { answer in
                        if answer.isOther && answer.isSelected && answer.text.isEmptyOrWhitespace && answer.text.count < 2 {
                            status = false
                        }
                    }
                    if status == false {
                        return false
                    }
                }
            }
        }else{
            return false
        }
        
        return true
    }
}
