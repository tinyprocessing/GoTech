import Foundation
import SwiftUI

struct QuestionView: View {
    
    @ObservedObject var viewModel: QuestionViewModel
    @EnvironmentObject private var viewModelParent: SurveyViewModel
    
    var body: some View {
        VStack {
            HStack{
                VStack(alignment: .leading, spacing: 10){
                    Text(viewModel.question.text)
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                    if viewModel.question.isRequired{
                        HStack{
                            Text("* required")
                                .font(.caption)
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
                .padding()
                Spacer()
            }
            
            switch viewModel.question.type {
            case .singleChoice, .multipleChoice:
                VStack(spacing: 10){
                    ForEach(viewModel.question.answers, id: \.id) { answer in
                        Button(action: {
                            viewModelParent.objectWillChange.send()
                            viewModel.toggleAnswerSelection(answer)
                        }) {
                            HStack {
                                Image(systemName: answer.isSelected ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(.black)
                                Text(answer.text)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                        }.padding(.horizontal)
                    }
                }.padding(.bottom)
            case .singleChoiceWithText:
                VStack(spacing: 10){
                    ForEach(viewModel.question.answers.indices, id: \.self) { index in
                        let answer = viewModel.question.answers[index]
                        VStack{
                            Button(action: {
                                viewModelParent.objectWillChange.send()
                                viewModel.toggleAnswerSelection(answer)
                            }) {
                                HStack {
                                    Image(systemName: answer.isSelected ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(.black)
                                    if !answer.isOther {
                                        Text(answer.text)
                                            .foregroundColor(.black)
                                    }else{
                                        Text("Other")
                                            .foregroundColor(.black)
                                    }
                                    Spacer()
                                }
                            }
                            if answer.isOther {
                                TextField("Your answer", text: $viewModel.question.answers[index].text)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(10)
                                    .background(Color(.systemBackground))
                                    .cornerRadius(8)
                                    .shadow(color: Color(.systemGray), radius: 1, x: 0, y: 2)
                                    .onChange(of: viewModel.question.answers[index].text) { newValue in
                                        viewModelParent.objectWillChange.send()
                                        if newValue.count > 1  && !newValue.isEmptyOrWhitespace {
                                            if viewModel.question.isRequired {
                                                viewModel.toggleAnswerSelection(answer, clearOther: false)
                                            }
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                }.padding(.bottom)
            case .textInput:
                HStack{
                    if viewModel.question.answers.first != nil {
                        TextField("Your answer", text: $viewModel.question.answers[0].text)
                            .onChange(of: viewModel.question.answers[0].text) { newValue in
                                viewModelParent.objectWillChange.send()
                                if newValue.count > 1  && !newValue.isEmptyOrWhitespace {
                                    if viewModel.question.isRequired {
                                        viewModel.question.answers[0].isSelected = true
                                    }
                                }else{
                                    if viewModel.question.isRequired {
                                        viewModel.question.answers[0].isSelected = false
                                    }
                                }
                            }
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(10)
                            .background(Color(.systemBackground))
                            .cornerRadius(8)
                            .shadow(color: Color(.systemGray), radius: 1, x: 0, y: 2)
                            .padding(.horizontal, 10)
                    }
                    Spacer()
                }.padding(.bottom)
            }
            
        }
    }
}


