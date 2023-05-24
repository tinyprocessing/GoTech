import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SurveyViewModel()
    
    var body: some View {
        ZStack {
            Color.indigo.opacity(0.07)
            SurveyView()
                .environmentObject(viewModel)
                .padding(.horizontal)
                .padding(.vertical, 30)
                .padding(.top, 30)
        }
        .edgesIgnoringSafeArea(.all)
    }
}
