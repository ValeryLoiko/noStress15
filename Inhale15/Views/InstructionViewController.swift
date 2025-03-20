//
//  InstructionViewController.swift
//  Inhale15
//
//  Created by Diana on 29/01/2025.
//

import UIKit
import SnapKit
import AVFoundation

/// Экран инструкции, где отображается текстовое описание процесса.
class InstructionViewController: UIViewController {
    
    // MARK: - Свойства
    
    /// ViewModel, отвечающая за логику экрана.
    private let viewModel: InstructionViewModel
    
    /// Слой для отображения видео на заднем фоне.
    private var playerLayer: AVPlayerLayer?

    // MARK: - Инициализация
    
    /// Инициализатор контроллера, передающий `VideoService` в `InstructionViewModel`.
    init() {
        let videoService = VideoService() // ✅ Создаём сервис видео
        self.viewModel = InstructionViewModel(videoService: videoService) // ✅ Передаём сервис в ViewModel
        super.init(nibName: nil, bundle: nil) // ✅ Вызываем родительский инициализатор
    }
    
    /// Обязательный инициализатор, вызываемый при использовании Storyboard (не используется).
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI-компоненты
    
    /// Полупрозрачный затемняющий слой.
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return view
    }()
    
    /// Заголовок экрана.
    private let titleLabel = UIFactory.createLabel(
        fontSize: 20,
        weight: .bold,
        textColor: ColorPalette.primary
    )
    
    /// Текст инструкции.
    private let instructionLabel = UIFactory.createLabel(
        fontSize: 17,
        textColor: .white,
        alignment: .left,
        lines: 0
    )
    
    /// Кнопка "Далее" для перехода на следующий экран.
    private lazy var nextButton: UIButton = {
        let button = UIFactory.createButton(
            title: LabelText.nextButton.text,
            backgroundColor: ColorPalette.primary
        )
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Жизненный цикл
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
   //     setupBindings()
     //   viewModel.loadVideo(named: "IMG_4300", ofType: "MP4") // ✅ Загружаем видео
    }
    
    // MARK: - Настройка интерфейса
    
    /// Настраивает интерфейс экрана.
    private func setupUI() {
        view.backgroundColor = .black // ✅ Фон на случай, если видео не загрузится

        // Добавляем слои на экран
        view.addSubview(overlayView)
        view.addSubview(titleLabel)
        view.addSubview(instructionLabel)
        view.addSubview(nextButton)

        // Настройка затемняющего слоя
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Настройка заголовка
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Настройка инструкции
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        // Настройка кнопки "Далее"
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(160)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
    }
    
    // MARK: - Привязка данных
    
    /// Настраивает привязку данных между ViewModel и контроллером.
//    private func setupBindings() {
//        titleLabel.text = viewModel.titleText
//        instructionLabel.text = viewModel.instructionText
//
//        viewModel.onVideoReady = { [weak self] player in
//            guard let self = self else { return }
//            self.playerLayer = AVPlayerLayer(player: player)
//            self.playerLayer?.videoGravity = .resizeAspectFill
//            self.playerLayer?.frame = self.view.bounds
//            if let playerLayer = self.playerLayer {
//                self.view.layer.insertSublayer(playerLayer, at: 0)
//            }
//        }
//    }
    
    // MARK: - Действия
    
    /// Обработчик нажатия на кнопку "Далее".
    @objc private func nextTapped() {
        viewModel.navigateToNextScreen {
            let timerVC = TimerViewController()
            timerVC.modalTransitionStyle = .crossDissolve
            timerVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(timerVC, animated: true)
        }
    }
}
