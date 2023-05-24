import Foundation

final class QuestionViewModel: NSObject, ObservableObject {
    @Published var question: Question
    
    init(question: Question) {
        self.question = question
    }
    
    // Method to toggle the selection of an answer
    func toggleAnswerSelection(_ answer: Answer, clearOther: Bool = true) {
        self.objectWillChange.send()
        // Find the index of the selected answer
        guard let index = question.answers.firstIndex(where: { $0.id == answer.id }) else {
            return
        }
        // Clear selected answers if the question type allows only one choice
        if question.type == .singleChoice || question.type == .singleChoiceWithText{
            clearSelectedAnswers(clearOther: clearOther)
        }
        // Toggle the selection state of the answer
        question.answers[index].isSelected.toggle()
    }
    // Method to clear the selected answers
    func clearSelectedAnswers(clearOther: Bool) {
        for index in 0..<question.answers.count {
            question.answers[index].isSelected = false
            // If the question type is text input or single choice with text, clear the answer text
            if question.type == .textInput || (question.type == .singleChoiceWithText && question.answers[index].isOther) {
                if clearOther {
                    question.answers[index].text = ""
                }
            }
        }
    }

}
