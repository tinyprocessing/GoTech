//
//  StringExtensions.swift
//  GoTech
//
//  Created by Michael Safir on 22.05.2023.
//

import Foundation

extension String {
    var isEmptyOrWhitespace: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
