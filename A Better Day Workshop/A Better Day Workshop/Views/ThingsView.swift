//
//  ThingsView.swift
//  A Better Day Workshop
//
//  Created by Rachael LaMassa on 1/8/25.
//

import SwiftUI
import SwiftData

struct ThingsView: View {
    
    // allows change in DC
    @Environment(\.modelContext) private var context
    
    @Query(filter:Day.currentDayPredicate(), sort: \.date) private var today: [Day]
    
    // predicate is criteria for searching
    // $0 is the current thing
    @Query(filter: #Predicate<Thing> { $0.isHidden == false }) private var things: [Thing]
    
    @State private var showAddView: Bool = false
    
    var body: some View {
        VStack (spacing: 20) {
            
            Text("Things")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("These are the things that make you feel positive and uplifted.")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if things.count == 0 {
                // image
                Spacer()
                Image("things")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 300)
                
                // tool tip
                ToolTipView(text: "Start by adding things that brighten your day. Tab the button below to get started!")
            }
            
            List (things) { thing in
                
                let today = getToday()
                
                HStack {
                    Text(thing.title)
                    Spacer()
                    Button {
                        
                        if today.things.contains(thing) {
                            // remove thing from today
                            today.things.removeAll { t in t == thing }
                            try? context.save()
                        }
                        else {
                            // add thing to today
                            today.things.append(thing)
                        }
                        
                        
                    } label: {
                        
                        // if this thing is already in today's things list, show a solid checkmark instead
                        if today.things.contains(thing) {
                            Image(systemName: "checkmark.circl.filled")
                                .foregroundStyle(.blue)
                        }
                        else {
                            Image(systemName: "checkmark.circle")
                        }
                    }
                }
            }
            .listStyle(.plain)
            
            Spacer()
            
            Button("Add New Thing") {
                // show sheet to add thing
                showAddView.toggle()
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            
        }
        .sheet(isPresented: $showAddView) {
            AddThingView()
                .presentationDetents(
                    [.fraction(0.2)])
        }
    }
    
    func getToday() -> Day {
        
        // try to retrieve today from database
        if today.count > 0 {
            return today.first!
        }
        else {
            // if it doesn't exist, create a day and insert it
            let today = Day()
            context.insert(today)
            try? context.save()
            
            return today
        }
    }
}

#Preview {
    ThingsView()
}
