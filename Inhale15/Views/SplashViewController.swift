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
    
    private let accentColor = UIColor(red: 149/255, green: 222/255, blue: 205/255, alpha: 1.0) // #95DECD
    private let darkGradientStart = UIColor(red: 28/255, green: 28/255, blue: 40/255, alpha: 1.0).cgColor
    private let darkGradientEnd = UIColor(red: 20/255, green: 20/255, blue: 30/255, alpha: 1.0).cgColor
    
    private let animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "Animation - 1727784149695")
        animation.contentMode = .scaleAspectFill
        animation.loopMode = .loop
        animation.animationSpeed = 0.5
        return animation
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "No Stress 15"
        label.font = .systemFont(ofSize: 48, weight: .semibold)
        label.textColor = UIColor(red: 149/255, green: 222/255, blue: 205/255, alpha: 0.95)
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    private let sloganLabel: UILabel = {
        let label = UILabel()
        let text = "THE SIZE OF CALM"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.kern, value: 5, range: NSRange(location: 0, length: text.count))
        
        label.attributedText = attributedString
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textColor = UIColor(red: 149/255, green: 222/255, blue: 205/255, alpha: 0.75) // #95DECD с прозрачностью
        label.textAlignment = .center
        label.alpha = 0
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
    
    private func setupBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [darkGradientStart, darkGradientEnd]
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
        viewModel.onNavigateToInstruction = { [weak self] in
            self?.navigateToInstruction()
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
    
    private func navigateToInstruction() {
        guard let navigationController = navigationController else {
            print("Ошибка: navigationController не найден!")
            return
        }
        
        let instructionVC = InstructionViewController()
        
        let transition = CATransition()
        transition.duration = 2.0
        transition.type = .fade
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        DispatchQueue.main.async {
            self.view.window?.layer.add(transition, forKey: kCATransition)
            navigationController.setViewControllers([instructionVC], animated: false)
        }
    }
}
