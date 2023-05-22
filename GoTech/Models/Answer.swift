//
//  Answer.swift
//  GoTech
//
//  Created by Michael Safir on 22.05.2023.
//

import Foundation

struct Answer: Codable {
    let id: Int
    var text: String
    var isSelected: Bool = false
    var isOther: Bool = false
}

