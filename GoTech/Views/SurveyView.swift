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
                            .environmentObject(viewModel)
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                } else {
                    Text("No questions available")
                }
                Spacer()
            }.padding(.bottom)
            
            Button(action: {
                viewModel.upload()
            }) {
                Text("Submit")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .background(Color.indigo)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .opacity(viewModel.validateSurvey() ? 1.0 : 0.3)
                    .disabled(!viewModel.validateSurvey())
            }
        }
        .onAppear {
            viewModel.loadSurvey()
        }
    }
}
