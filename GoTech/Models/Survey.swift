//
//  Survey.swift
//  GoTech
//
//  Created by Michael Safir on 22.05.2023.
//

import Foundation

struct Survey: Identifiable, Hashable  {
    let id: String
    let title: String
    let questions: [QuestionViewModel]
}
