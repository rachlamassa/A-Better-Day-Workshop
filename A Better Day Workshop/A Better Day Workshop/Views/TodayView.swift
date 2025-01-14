//
//  TodayView.swift
//  A Better Day Workshop
//
//  Created by Rachael LaMassa on 1/8/25.
//

import SwiftUI
import SwiftData

struct TodayView: View {
    
    @Environment(\.modelContext) private var context
    
    @Binding var selectedTab: Tab
    
    @Query(filter:Day.currentDayPredicate(), sort: \.date) private var today: [Day]
    
    var body: some View {
        
        VStack (spacing: 20){
            
            Text("Today")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Try to do things that make you feel positive today")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            // only display the list if there are things done today
            if getToday().things.count > 0 {
                List(getToday().things) { thing in
                    
                    Text(thing.title)
                    
                }
                .listStyle(.plain)
            }
            else {
                // display the image and some tool tips
                Spacer()
                Image("today")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 300)
                
                ToolTipView(text: "Take a little time out of your busy day and do something that recharges you. Hit the log button below to start!")
                
                Button {
                    // switch to things tab
                    selectedTab = Tab.things
                } label: {
                    Text("Log")
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            
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
    TodayView(selectedTab: Binding.constant(Tab.today))
}
