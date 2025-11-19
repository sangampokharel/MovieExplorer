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
}
