//
//  ContentView.swift
//  GoTech
//
//  Created by Michael Safir on 22.05.2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = SurveyViewModel()

    var body: some View {
        VStack {
          SurveyView()
                .environmentObject(viewModel)

        }
        .padding()
    }
}

