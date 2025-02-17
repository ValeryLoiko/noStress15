//
//  InstructionViewController.swift
//  Inhale15
//
//  Created by Diana on 29/01/2025.
//

import UIKit
import SnapKit

class InstructionViewController: UIViewController {
    private let viewModel = InstructionViewModel()
    
    private let titleLabel = UIFactory.createLabel(fontSize: 20, weight: .bold, textColor: ColorPalette.primary)
    private let instructionLabel = UIFactory.createLabel(fontSize: 17, textColor: .white, alignment: .left, lines: 0)
    
    private lazy var nextButton: UIButton = {
        let button = UIFactory.createButton(title: "Далее", backgroundColor: ColorPalette.primary)
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorPalette.backgroundDark
        setupLayout()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateViewAppearance()
    }
    
    private func setupLayout() {
        let containerView = UIView()
        containerView.backgroundColor = UIColor(white: 0.1, alpha: 0.5) // Полупрозрачный фон под текстом
        containerView.layer.cornerRadius = 10
        
        view.addSubview(containerView)
        view.addSubview(titleLabel)
        view.addSubview(instructionLabel)
        view.addSubview(nextButton)
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).offset(-10)
            make.bottom.equalTo(instructionLabel).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(160)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
    }
    
    private func bindViewModel() {
        titleLabel.text = viewModel.titleText
        instructionLabel.text = viewModel.instructionText
    }
    
    private func animateViewAppearance() {
        view.alpha = 0
        UIView.animate(withDuration: 1.5) {
            self.view.alpha = 1
        }
    }
    
    @objc private func nextTapped() {
        viewModel.navigateToNextScreen {
            let timerVC = TimerViewController()
            timerVC.modalTransitionStyle = .crossDissolve
            timerVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(timerVC, animated: true)
        }
    }
}

