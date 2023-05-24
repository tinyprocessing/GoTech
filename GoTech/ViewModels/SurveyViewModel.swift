//
//  SurveyViewModel.swift
//  GoTech
//
//  Created by Michael Safir on 22.05.2023.
//

import Foundation
import Combine
import UIKit

final class SurveyViewModel: NSObject, ObservableObject {
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
                    self.showAlert(message: "Error \(error.localizedDescription)")
                }
            }
        }
    }
    
    func submitSurveyResult() {
       
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
    
    func upload() {
        var surveyAnswer : [SurveyAnswer] = []
        survey?.questions.forEach({ model in
            surveyAnswer.append(SurveyAnswer(id: model.question.id,
                                             answers: model.question.answers.filter { $0.isSelected }))
        })
        
        var result: ResultSurvey = ResultSurvey(id: 0, userID: "0000-0000-0000-0001", result: surveyAnswer)
            
        do {
            let jsonData = try JSONEncoder().encode(result)
            apiService.sendSurvey(jsonData) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self.clear()
                        self.showAlert(message: "Uploaded")
                    case .failure(let error):
                        print(error)
                        self.showAlert(message: "Error \(error.localizedDescription)")
                    }
                }
            }
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
        } catch {
            DispatchQueue.main.async {
                self.showAlert(message: "Error \(error.localizedDescription)")
            }
            print("Error encoding JSON: \(error)")
        }
    }
    
    func clear(){
        self.objectWillChange.send()
        if let questions = survey?.questions {
            for model in questions {
                model.objectWillChange.send()
                model.clearSelectedAnswers(clearOther: true)
            }
        }
    }
    
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in }
        alertController.addAction(okAction)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let topWindow = windowScene.windows.last {
                topWindow.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        }
    }

}
