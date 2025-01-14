//
//  Thing.swift
//  A Better Day Workshop
//
//  Created by Rachael LaMassa on 1/8/25.
//

import Foundation
import SwiftData

@Model
class Thing: Identifiable {
    
    var id: String = UUID().uuidString // unique random string
    var title: String = ""
    var lastUpdated: Date = Date()
    var isHidden: Bool = false
    
    init(title: String) { // this is how you create an instance of a Thing
        self.title = title
    }
    
}
