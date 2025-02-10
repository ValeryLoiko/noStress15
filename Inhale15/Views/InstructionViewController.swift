//
//  InstructionViewController.swift
//  Inhale15
//
//  Created by Diana on 29/01/2025.
//

import UIKit

class InstructionViewController: UIViewController {
    private let viewModel = InstructionViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Далее", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemIndigo
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.isUserInteractionEnabled = true // Убеждаемся, что кнопка активна
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.2, alpha: 1)
        setupLayout()
        bindViewModel()
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Начинаем с полной прозрачности
        view.alpha = 0
        
        // Плавно делаем экран видимым за 2 секунды
        UIView.animate(withDuration: 2.0, animations: {
            self.view.alpha = 1
        })
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
            make.left.right.equalToSuperview().inset(20)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40) // Больше отступа вниз
        }
    }
    
    private func bindViewModel() {
        titleLabel.text = viewModel.titleText
        instructionLabel.text = viewModel.instructionText
    }
    
    @objc private func nextTapped() {
        let timerVC = TimerViewController()
        timerVC.modalTransitionStyle = .crossDissolve
        timerVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(timerVC, animated: true)
    }
}
