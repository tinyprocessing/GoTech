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
        ZStack {
            Color.indigo.opacity(0.07)
            SurveyView()
                .environmentObject(viewModel)
                .padding()
                .padding(.vertical, 30)
                .padding(.top, 20)
        }.edgesIgnoringSafeArea(.all)
    }
}

