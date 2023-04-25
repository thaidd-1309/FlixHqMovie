//
//  String+.swift
//  FlixHqMovie
//
//  Created by DuyThai on 20/03/2023.
//

import Foundation

extension String {
    func getNumberFromString() -> String {
        let numbers = self.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let stringNumber = numbers.filter { !$0.isEmpty }
        return stringNumber.joined(separator: "")
    }

    func removeWhiteSpaceAndBreakLine() -> String {
        return self.filter { !"\n".contains($0) }
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var stringWithCapitalizedFirstLetter: String {
        let capitalizedFirstLetter = prefix(1).capitalized
        return replacingCharacters(in: ..<index(startIndex, offsetBy: 1), with: capitalizedFirstLetter)
    }
}
