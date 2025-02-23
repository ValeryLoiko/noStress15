//
//  HomeViewController.swift
//  no Stress 15
//
//  Created by Valera on 18/02/2025.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    private let titleLabel = UIFactory.createLabel(fontSize: 32, weight: .bold, textColor: ColorPalette.primary)
    
    private lazy var instructionButton: UIButton = {
        UIFactory.createButton(title: "📖 \(LabelText.homeInstruction.text)", backgroundColor: ColorPalette.primary)
    }()
    
    private lazy var timerButton: UIButton = {
        UIFactory.createButton(title: "⏱ \(LabelText.homeTimer.text)", backgroundColor: ColorPalette.primary)
    }()
    
    private lazy var statsButton: UIButton = {
        UIFactory.createButton(title: "📊 \(LabelText.homeStats.text)", backgroundColor: ColorPalette.primary)
    }()
    
    private lazy var settingsButton: UIButton = {
        UIFactory.createButton(title: "⚙️ \(LabelText.homeSettings.text)", backgroundColor: ColorPalette.primary.withAlphaComponent(0.7))
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [instructionButton, timerButton, statsButton, settingsButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = ColorPalette.backgroundDark
        
        view.addSubview(titleLabel)
        view.addSubview(buttonsStackView)
        
        titleLabel.text = "no Stress 15"
        titleLabel.textAlignment = .center
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(220)
        }
    }
    
    private func setupActions() {
        instructionButton.addTarget(self, action: #selector(openInstruction), for: .touchUpInside)
        timerButton.addTarget(self, action: #selector(openTimer), for: .touchUpInside)
        statsButton.addTarget(self, action: #selector(openStats), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
    }
    
    @objc private func openInstruction() {
        let vc = InstructionViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func openTimer() {
        let vc = TimerViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func openStats() {
        let vc = StatsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func openSettings() {
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
