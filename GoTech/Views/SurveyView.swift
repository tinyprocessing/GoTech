//
//  SurveyView.swift
//  GoTech
//
//  Created by Michael Safir on 22.05.2023.
//

import Foundation
import SwiftUI
import Combine

struct SurveyView: View {
    
    @EnvironmentObject private var viewModel: SurveyViewModel

    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false){
                if let questions = viewModel.survey?.questions {
                    ForEach(questions, id:\.self) { question in
                        QuestionView(viewModel: question)
                            .environmentObject(self.viewModel)
                    }
                }  else {
                    Text("No questions available")
                }
                Spacer()
            }.padding(.bottom)
            
            Button(action: {
                viewModel.survey?.questions.forEach({ model in
                    print("id: \(model.question.id), answer: \(model.question.answers.filter { $0.isSelected })")
                    
                })
            }) {
                HStack {
                    Text("Send Form")
                }
            }
            .foregroundColor(.white)
            .font(.headline)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .disabled(!viewModel.validateSurvey())
            .opacity(viewModel.validateSurvey() ? 1.0 : 0.3)
            
        }
        .onAppear {
            viewModel.loadSurvey()
        }
    }
}
