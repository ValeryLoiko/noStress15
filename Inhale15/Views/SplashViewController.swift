//
//  SplashViewController.swift
//  Inhale15
//
//  Created by Diana on 29/01/2025.
//

import UIKit
import Lottie
import SnapKit

class SplashViewController: UIViewController {
    
    private let viewModel = SplashViewModel()
    
    private let animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: SplashViewModel.animationName)
        animation.contentMode = .scaleAspectFill
        animation.loopMode = .loop
        animation.animationSpeed = 0.5
        return animation
    }()
    
    private let titleLabel = UIFactory.createLabel(fontSize: 48, weight: .semibold, textColor: ColorPalette.primary)
    
    private let sloganLabel: UILabel = {
        let label = UIFactory.createLabel(fontSize: 16, weight: .light, textColor: ColorPalette.primary.withAlphaComponent(0.75))
        let text = "THE SIZE OF CALM"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.kern, value: 5, range: NSRange(location: 0, length: text.count))
        label.attributedText = attributedString
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupUI()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.sublayers?.first?.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.cancelSplashTimer() // ⚠️ Отмена таймера при выходе с экрана
    }

    private func setupBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ColorPalette.backgroundDark.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupUI() {
        view.addSubview(animationView)
        view.addSubview(titleLabel)
        view.addSubview(sloganLabel)
        
        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.text = "no Stress 15"
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        sloganLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func bindViewModel() {
        viewModel.onNavigateToHome = { [weak self] in
            self?.navigateToHome()
        }
    }
    
    private func startAnimation() {
        animationView.alpha = 1
        animationView.play()

        titleLabel.alpha = 0
        sloganLabel.alpha = 0

        UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.5) {
                self.titleLabel.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.5) {
                self.sloganLabel.alpha = 0.9
            }
        })
        
        viewModel.startSplashTimer()
    }
    
    private func navigateToHome() {
        guard let navigationController = navigationController else {
            print("Ошибка: navigationController не найден!")
            return
        }

        let homeVC = HomeViewController()

        let transition = CATransition()
        transition.duration = 2.0
        transition.type = .fade
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        DispatchQueue.main.async {
            self.view.window?.layer.add(transition, forKey: kCATransition)
            navigationController.setViewControllers([homeVC], animated: false)
        }
    }

}
