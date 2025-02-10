//
//  SplashViewModel.swift
//  Inhale15
//
//  Created by Diana on 29/01/2025.
//

import Foundation

class SplashViewModel {
    
    var animationName: String {
        return "Animation - 1727784149695"
    }
    
    var onNavigateToInstruction: (() -> Void)?
    
    func startSplashTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { [weak self] in
            debugPrint("Navigating to InstructionVC") 
            self?.onNavigateToInstruction?()
        }
    }
}
