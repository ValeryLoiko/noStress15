//
//  InstructionViewController.swift
//  Inhale15
//
//  Created by Diana on 29/01/2025.
//

import UIKit
import SnapKit
import AVFoundation

/// Экран инструкции, стилизованный как HomeVC
class InstructionViewController: UIViewController {
    
    private let viewModel: InstructionViewModel
    private var playerLayer: AVPlayerLayer?
    
    init() {
        let videoService = VideoService()
        self.viewModel = InstructionViewModel(videoService: videoService)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI-компоненты
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UIFactory.createLabel(
            fontSize: 28,
            weight: .bold,
            textColor: .white,
            alignment: .center,
            lines: 2
        )
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    private let instructionLabel = UIFactory.createLabel(
        fontSize: 18,
        textColor: .white,
        alignment: .center,
        lines: 0
    )
    
    // MARK: - Жизненный цикл
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.loadVideo(named: "IMG_4300", ofType: "MP4")
        animateAppearance()
        viewModel.setupAndPlayVideo(named: "instructionVideo", ofType: "mp4")
    }
    
    // MARK: - Настройка UI
    
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(overlayView)
        view.addSubview(titleLabel)
        view.addSubview(instructionLabel)
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.text = LabelText.instructionTitle.text
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        instructionLabel.text = LabelText.instructionText.text
        instructionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-80)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Анимация появления
    
    private func animateAppearance() {
        titleLabel.alpha = 0
        instructionLabel.alpha = 0
        
        UIView.animate(withDuration: 1.0, delay: 0.3, options: .curveEaseOut, animations: {
            self.titleLabel.alpha = 1
        })
        
        UIView.animate(withDuration: 1.2, delay: 0.6, options: .curveEaseOut, animations: {
            self.instructionLabel.alpha = 1
        })
    }
    
    // MARK: - Привязка данных
    
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
    }
}

