//
//  ToolTipView.swift
//  A Better Day Workshop
//
//  Created by Rachael LaMassa on 1/10/25.
//

import SwiftUI

struct ToolTipView: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .foregroundStyle(.blue)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.blue, lineWidth: 1)
                    .background(Color("light-blue"))
                    .cornerRadius(10)
            }
    }
}

#Preview {
    ToolTipView(text: "Hello, World!")
}
