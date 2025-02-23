//
//  InstructionViewModel.swift
//  Inhale15
//
//  Created by Diana on 30/01/2025.
//

import Foundation

class InstructionViewModel {
    let titleText = LabelText.instructionTitle.text
    let instructionText = LabelText.instructionText.text
    
    func navigateToNextScreen(completion: @escaping () -> Void) {
        completion()
    }
}

