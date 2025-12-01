//
//  FrameworkGridViewModel.swift
//  aplikacja1
//
//  Created by Wojciech Zbieg on 20/08/2025.
//

import SwiftUI

final class FrameworkGridViewModel: ObservableObject {
    
    var selectedFramework: Framework? {
        didSet {
            isShowingDetailView = true
        }
    }
    @Published var isShowingDetailView = false
}
