//
//  AddThingView.swift
//  A Better Day Workshop
//
//  Created by Rachael LaMassa on 1/8/25.
//

import SwiftUI
import SwiftData

struct AddThingView: View {
    
    // access context/ retrieve things
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var thingTitle = ""
    
    var body: some View {
        
        VStack (alignment: .leading, spacing: 10){
            TextField("What makes you feel good?", text: $thingTitle)
                .textFieldStyle(.roundedBorder)
            Button("Add") {
                // add into SwiftData
                addThing()
                
                thingTitle = ""
                
                dismiss() // remove view from screen
            }
            .buttonStyle(.borderedProminent)
            .disabled(thingTitle
                .trimmingCharacters(in:
                .whitespacesAndNewlines).isEmpty)
        }
        .padding()
        
    }
    
    func addThing() {
        
        // TODO: clean the text
        let cleanedTitle = thingTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // TODO: add into DB
        context.insert(Thing(title:cleanedTitle))
        
        try? context.save()
        
    }
    
}

#Preview {
    AddThingView()
}
