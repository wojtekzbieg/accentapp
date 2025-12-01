//
//  ButtonBlueprint.swift
//  aplikacja1
//
//  Created by Wojciech Zbieg on 20/08/2025.
//

import SwiftUI

struct ButtonBlueprint: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.title2)
            .fontWeight(.semibold)
            .frame(width: 280, height: 50)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

#Preview {
    ButtonBlueprint(text: "test")
}
