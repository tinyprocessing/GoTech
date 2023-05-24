//
//  APIService.swift
//  GoTech
//
//  Created by Michael Safir on 22.05.2023.
//

import Foundation

final class APIService {
    static let shared = APIService()
    
    private let baseURL = "http://localhost:3000"
    
    private init() {}
    
    func fetchSurvey(completion: @escaping (Result<Survey, Error>) -> Void) {
        let surveyURL = URL(string: "\(baseURL)/questions")!
        
        URLSession.shared.dataTask(with: surveyURL) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "thenoco.co.GoTech", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            
            
            do {
                
                guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                    return
                }

                let questionsJSON: [QuestionViewModel] = jsonArray.compactMap { questionJSON in
                    guard let id = questionJSON["id"] as? Int,
                          let title = questionJSON["title"] as? String,
                          let typeString = questionJSON["type"] as? String,
                          let isRequired = questionJSON["isRequired"] as? Bool else {
                        return nil
                    }

                    let type = QuestionType(rawValue: typeString) ?? .singleChoice

                    var answers: [Answer] = []
                    if let answersArray = questionJSON["answers"] as? [[String: Any]] {
                        answers = answersArray.compactMap { answerJSON in
                            guard let answerTitle = answerJSON["title"] as? String,
                                  let idAnswer = answerJSON["id"] as? Int else {
                                return nil
                            }
                            return Answer(id: idAnswer, text: answerTitle)
                        }
                    }

                    if type == .textInput {
                        answers.append(Answer(id: 0, text: "", isSelected: !isRequired))
                    }
                    
                    if type == .singleChoiceWithText {
                        answers.append(Answer(id: -1, text: "", isSelected: false, isOther: true))
                    }
                    
                    let question = Question(id: id, text: title, isRequired: isRequired, type: type, answers: answers)
                    return QuestionViewModel(question: question)
                }
                
                completion(.success(Survey(id: "1", title: "All questions", questions: questionsJSON)))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func sendSurvey(_ jsonData: Data, completion: @escaping (Result<Bool, Error>) -> Void){
        
        let answersURL = URL(string: "\(baseURL)/answers")!

        var request = URLRequest(url: answersURL)

        
        request.httpMethod = "POST"
        request.httpBody = jsonData

        // Set the Content-Type header to application/json
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if statusCode == 201 {
                    completion(.success(true))
                } else {
                    let error = NSError(domain: "thenoco.co.GoTech", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Bad response"])
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
}
