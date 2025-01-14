//
//  Day.swift
//  A Better Day Workshop
//
//  Created by Rachael LaMassa on 1/8/25.
//

import Foundation
import SwiftData
@Model
class Day: Identifiable {
    
    var id: String = UUID().uuidString
    var date: Date = Date()
    var things = [Thing]()
    
    init() {
        
    }
}

extension Day {
    
    static func currentDayPredicate() -> Predicate<Day> {
        
        let calendar = Calendar.autoupdatingCurrent
        let start = calendar.startOfDay(for: Date())
        
        return #Predicate<Day> { $0.date >= start }
        
    }
    
}
