//
//  testView.swift
//  accentapp
//
//  Created by Wojciech Zbieg on 11/09/2025.
//

import SwiftUI

struct testView: View {
    @StateObject private var viewModel = ExerciseViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .center) {
                TextField("", text: $viewModel.referenceText, axis: .vertical)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
                    .padding()
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black.opacity(0.4), lineWidth: 1.2)
                    )
                    .cornerRadius(12)
                    .accentColor(.black)
                if viewModel.referenceText.isEmpty {
                    Text("Enter text to practice...")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.black.opacity(0.4))
                        .multilineTextAlignment(.center)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}

#Preview {
    testView()
}
