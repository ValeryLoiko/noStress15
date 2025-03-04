//
//  SettingsViewController.swift
//  no Stress 15
//
//  Created by Valera on 19/02/2025.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    
    private let viewModel = SettingsViewModel()
    
    private let titleLabel = UIFactory.createLabel(fontSize: 32, weight: .bold, textColor: ColorPalette.primary)
    
    private lazy var musicButton: UIButton = {
        let button = UIFactory.createButton(title: "🎵 \(LabelText.musicButton.text): Play", backgroundColor: ColorPalette.primary)
        button.addTarget(self, action: #selector(toggleMusic), for: .touchUpInside)
        return button
    }()

    private lazy var languageButton: UIButton = {
        UIFactory.createButton(title: "🌍  \(LabelText.homeLanguage.text)", backgroundColor: ColorPalette.primary)
    }()
    
    private lazy var termsButton: UIButton = {
        UIFactory.createButton(title: "📜 Terms & Conditions", backgroundColor: ColorPalette.primary)
    }()
    
    private lazy var donateButton: UIButton = {
        let button = UIFactory.createButton(title: "💖 \(LabelText.homeDonate.text)", backgroundColor: ColorPalette.primary.withAlphaComponent(0.7))
        button.addTarget(self, action: #selector(openDonations), for: .touchUpInside)
        return button
    }()
    
    private lazy var linkedInButton: UIButton = {
        let button = UIFactory.createButton(title: "🔗 LinkedIn", backgroundColor: ColorPalette.primary)
        button.addTarget(self, action: #selector(copyLinkedIn), for: .touchUpInside)
        return button
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [musicButton, languageButton, termsButton, donateButton, linkedInButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = ColorPalette.backgroundDark
        
        view.addSubview(titleLabel)
        view.addSubview(buttonsStackView)
        
        titleLabel.text = LabelText.homeSettings.text
        titleLabel.textAlignment = .center
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
        }
    }

    @objc private func toggleMusic() {
        viewModel.togglePlayPause()
        let newTitle = viewModel.isPlaying ? "🎵 \(LabelText.musicButton.text): Pause" : "🎵 \(LabelText.musicButton.text): Play"
        musicButton.setTitle(newTitle, for: .normal)
    }

//    @objc private func resetMusic() {
//        viewModel.resetAudio()
//        musicButton.setTitle("🎵 \(LabelText.musicButton.text): Pause", for: .normal)
//    }
    
    @objc private func openDonations() {
        let vc = DonateViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func copyLinkedIn() {
        viewModel.copyLinkedInURL()
        let alert = UIAlertController(title: LabelText.linkKopped.text, message: LabelText.linkMessage.text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

