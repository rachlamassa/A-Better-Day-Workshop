//
//  SettingsView.swift
//  A Better Day Workshop
//
//  Created by Rachael LaMassa on 1/8/25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack (alignment: .leading, spacing: 20) {
            
            Text("Settings")
                .font(.largeTitle)
                .bold()
            
            List {
                
                // rate this app
                let reviewUrl = URL(string: "https://apps.apple.com/app/id6670766958?action=write-review")!
                
                Link (destination: reviewUrl, label: {
                    HStack {
                        Image(systemName: "star.bubble")
                        Text("Rate this app")
                    }
                })
                
                let shareUrl = URL(string: "https://apps.apple.com/app/id6670766958")!
                
                ShareLink(item: shareUrl) {
                    HStack {
                        Image(systemName: "arrowshape.turn.up.right")
                        Text("Recommend the app")
                    }
                }
                
                // contact
                Button {
                    // compose email
                    let mailUrl = createMailUrl()
                    
                    if let mailUrl = mailUrl,
                       UIApplication.shared.canOpenURL(mailUrl) {
                        UIApplication.shared.open(mailUrl)
                    }
                    else {
                        print("Couldn't open mail client")
                    }
                } label: {
                    HStack {
                        Image(systemName: "quote.bubble")
                        Text("Submit feedback")
                    }
                }
                
                // privacy policy
                let privacyUrl = URL(string: "https://codewithchris.com/abd-privacy-policy/")!
                
                Link(destination: privacyUrl, label: {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Privacy Policy")
                    }
                })
            }
            .listRowSeparator(.hidden)
            .listStyle(.plain)
            .tint(.black)
        }
    }
    
    func createMailUrl() -> URL? {
        
        var mailUrlComponents = URLComponents()
        mailUrlComponents.scheme = "mailto"
        mailUrlComponents.path = "care@codewithchris.com"
        mailUrlComponents.queryItems = [
            URLQueryItem(name: "subject", value: "Feedback for A Better Day app")
        ]
        
        return mailUrlComponents.url
        
    }
    
}

#Preview {
    SettingsView()
}
