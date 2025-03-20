//
//  HomeViewModel.swift
//  noStress15
//
//  Created by Diana on 28/02/2025.
//

import AVFoundation
import UIKit

/// ViewModel для главного экрана
class HomeViewModel {
    
    /// Доступные экраны для навигации
    enum Screen {
        case instruction, timer, stats, settings
    }
    
    /// Коллбек для обработки перехода на другой экран
    var onNavigateTo: ((UIViewController) -> Void)?
    
    /// Осуществляет навигацию на указанный экран
    func navigateTo(screen: Screen) {
        let viewController: UIViewController
        switch screen {
        case .instruction: viewController = InstructionViewController()
        case .timer: viewController = TimerViewController()
        case .stats: viewController = StatsViewController()
        case .settings: viewController = SettingsViewController()
        }
        onNavigateTo?(viewController)
    }
}
