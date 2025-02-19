//
//  SplashViewModel.swift
//  Inhale15
//
//  Created by Diana on 29/01/2025.
//

import Foundation

class SplashViewModel {
    
    static let animationName = "Animation - 1727784149695"
    
    var onNavigateToHome: (() -> Void)?
    private var splashWorkItem: DispatchWorkItem?

    func startSplashTimer() {
        splashWorkItem = DispatchWorkItem { [weak self] in
            debugPrint("Navigating to HomeVC")
            self?.onNavigateToHome?()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: splashWorkItem!)
    }
    
    func cancelSplashTimer() {
        splashWorkItem?.cancel()
    }
    
    deinit {
        debugPrint("SplashViewModel deallocated")
    }
}

