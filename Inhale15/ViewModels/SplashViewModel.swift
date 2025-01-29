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
    var logoImageName: String {
        return "background"
    }
    var onFinishSplash: (() -> Void)?
    
    func startSplashTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.onFinishSplash?() // Вызываем callback
        }
    }
    
    
}
