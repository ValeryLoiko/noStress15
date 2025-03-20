//
//  HomeViewController.swift
//  no Stress 15
//
//  Created by Valera on 18/02/2025.
//

import UIKit
import SnapKit
import AVKit

//// Главный экран приложения с видео на фоне и навигационными кнопками.
class HomeViewController: UIViewController {
    
    // MARK: - Свойства
    private let videoService = VideoService()
    private let viewModel = HomeViewModel()
    private var playerLayer: AVPlayerLayer?
    
    // MARK: - UI-компоненты
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
    
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupActions()
        setupVideoBackground()
    }
    
    // MARK: - Настройка интерфейса
    private func setupUI() {
        view.backgroundColor = .black
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
    
    // MARK: - Настройка видеофона
    private func setupVideoBackground() {
        videoService.loadVideo(named: "IMG_4300", ofType: "MP4")
        if let player = videoService.getPlayer() {
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.videoGravity = .resizeAspectFill
            playerLayer?.frame = view.bounds
            if let playerLayer = playerLayer {
                view.layer.insertSublayer(playerLayer, at: 0)
            }
        }
    }
    
    // MARK: - Привязка ViewModel
    private func setupBindings() {
        viewModel.onNavigateTo = { [weak self] viewController in
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: - Действия
    private func setupActions() {
        instructionButton.addTarget(self, action: #selector(openScreen(_:)), for: .touchUpInside)
        timerButton.addTarget(self, action: #selector(openScreen(_:)), for: .touchUpInside)
        statsButton.addTarget(self, action: #selector(openScreen(_:)), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(openScreen(_:)), for: .touchUpInside)
    }
    
    @objc private func openScreen(_ sender: UIButton) {
        switch sender {
        case instructionButton: viewModel.navigateTo(screen: .instruction)
        case timerButton: viewModel.navigateTo(screen: .timer)
        case statsButton: viewModel.navigateTo(screen: .stats)
        case settingsButton: viewModel.navigateTo(screen: .settings)
        default: break
        }
    }
}
