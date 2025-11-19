//
//  Int + Ext.swift
//  MovieExplorer
//
//  Created by Ekbana on 19/11/2025.
//

import Foundation

extension Int {
    func formatAsHoursAndMinutes() -> String {
        let hours = self / 60
        let minutes = self % 60

        if hours == 0 {
            return "\(minutes)mins"
        } else if minutes == 0 {
            return "\(hours)h"
        } else {
            return "\(hours)h \(minutes)mins"
        }
    }

    func ordinalString() -> String {
        let suffix: String
        let lastDigit = self % 10
        let lastTwoDigits = self % 100

        if lastTwoDigits >= 11 && lastTwoDigits <= 13 {
            suffix = "th"
        } else {
            switch lastDigit {
            case 1: suffix = "st"
            case 2: suffix = "nd"
            case 3: suffix = "rd"
            default: suffix = "th"
            }
        }

        return "\(self)\(suffix)"
    }
}
