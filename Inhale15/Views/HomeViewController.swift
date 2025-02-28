//
//  HomeViewController.swift
//  no Stress 15
//
//  Created by Valera on 18/02/2025.
//

import UIKit
import SnapKit
import AVKit

class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    private var playerLayer: AVPlayerLayer?
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return view
    }()
    
    private let titleLabel = UIFactory.createLabel(
        fontSize: 36,
        weight: .bold,
        textColor: .white
    )
    
    private lazy var instructionButton = createStyledButton(title: "📖 " + LabelText.homeInstruction.text)
    private lazy var timerButton = createStyledButton(title: "⏱ " + LabelText.homeTimer.text)
    private lazy var statsButton = createStyledButton(title: "📊 " + LabelText.homeStats.text)
    private lazy var settingsButton = createStyledButton(title: "⚙️ " + LabelText.homeSettings.text)
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            instructionButton, timerButton, statsButton, settingsButton
        ])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.loadVideo(named: "IMG_4246", ofType: "MP4")
        setupActions()
    }
    
    private func setupUI() {
        view.addSubview(overlayView)
        view.addSubview(titleLabel)
        view.addSubview(buttonsStackView)
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.text = LabelText.appName.text
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.centerX.equalToSuperview()
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
        }
    }
    
    private func createStyledButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.6).cgColor
        button.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        return button
    }
    
    private func setupBindings() {
        viewModel.onVideoReady = { [weak self] player in
            guard let self = self else { return }
            self.playerLayer = AVPlayerLayer(player: player)
            self.playerLayer?.videoGravity = .resizeAspectFill
            self.playerLayer?.frame = self.view.bounds
            if let playerLayer = self.playerLayer {
                self.view.layer.insertSublayer(playerLayer, at: 0)
            }
        }
        
        viewModel.onNavigateTo = { [weak self] viewController in
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func setupActions() {
        instructionButton.addTarget(self, action: #selector(openScreen(_:)), for: .touchUpInside)
        timerButton.addTarget(self, action: #selector(openScreen(_:)), for: .touchUpInside)
        statsButton.addTarget(self, action: #selector(openScreen(_:)), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(openScreen(_:)), for: .touchUpInside)
    }
    
    @objc private func openScreen(_ sender: UIButton) {
        switch sender {
        case instructionButton:
            viewModel.navigateTo(screen: .instruction)
        case timerButton:
            viewModel.navigateTo(screen: .timer)
        case statsButton:
            viewModel.navigateTo(screen: .stats)
        case settingsButton:
            viewModel.navigateTo(screen: .settings)
        default:
            break
        }
    }
}
