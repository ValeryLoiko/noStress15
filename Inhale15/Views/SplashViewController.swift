//  SplashViewController.swift
//  Inhale15
//
//  Created by Diana on 29/01/2025.
//

import UIKit
import SnapKit
import Lottie

class SplashViewController: UIViewController {
    
    private let viewModel = SplashViewModel()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 100
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    private let animationView: LottieAnimationView = {
        let animation = LottieAnimationView()
        animation.loopMode = .loop
        animation.contentMode = .scaleAspectFit
        return animation
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 12/255.0, green: 8/255.0, blue: 67/255.0, alpha: 1.0)
        
        view.addSubview(animationView)
        view.addSubview(logoImageView)
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(160) // Лого ниже
            make.width.height.equalTo(200)
        }
        
        animationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
            make.width.equalToSuperview().multipliedBy(1.5) // Увеличиваем ширину на 150%
            make.height.equalToSuperview().multipliedBy(1.5)
        }
    }
    
    private func bindViewModel() {
        logoImageView.image = UIImage(named: viewModel.logoImageName)
        animationView.animation = LottieAnimation.named(viewModel.animationName)
        animationView.play()
        
        viewModel.onFinishSplash = { [weak self] in
            self?.navigateToNextScreen()
        }
        
        viewModel.startSplashTimer()
    }
    
    private func navigateToNextScreen() {
        let nextVC = InstructionViewController()
        nextVC.modalTransitionStyle = .crossDissolve
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true, completion: nil)
    }
}

