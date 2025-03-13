//
//  HomeViewController.swift
//  no Stress 15
//
//  Created by Valera on 18/02/2025.
//

import UIKit
import SnapKit
import AVKit

/// Главный экран приложения. Отвечает за отображение кнопок навигации и фона с видео-анимацией.
class HomeViewController: UIViewController {
    
    // MARK: - Свойства
    
    /// ViewModel, отвечающая за логику главного экрана.
    private let viewModel: HomeViewModel
    
    /// Слой для отображения видео на заднем фоне.
    private var playerLayer: AVPlayerLayer?

    // MARK: - Инициализация
    
    /// Инициализатор без параметров, создаёт ViewModel и передаёт в неё VideoService.
    init() {
        let videoService = VideoService() // Создаём сервис видео
        self.viewModel = HomeViewModel(videoService: videoService) // Передаём сервис в ViewModel
        super.init(nibName: nil, bundle: nil) // Вызываем инициализатор родителя
    }
    
    /// Обязательный инициализатор, не используется, так как инициализация идёт вручную.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Жизненный цикл
    
    /// Вызывается при загрузке экрана.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()        // Настройка интерфейса
        setupBindings()  // Настройка привязки данных
        setupActions()   // Настройка действий для кнопок
        viewModel.loadVideo(named: "IMG_4246", ofType: "MP4") // Загружаем фоновое видео
        viewModel.setupAndPlayVideo(named: "homeVideo", ofType: "mp4")
    }
    
    // MARK: - UI-компоненты
    
    /// Полупрозрачный тёмный слой для затемнения фона.
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return view
    }()
    
    /// Заголовок приложения.
    private let titleLabel = UIFactory.createLabel(
        fontSize: 36,
        weight: .bold,
        textColor: .white
    )
    
    /// Кнопки для навигации по приложению.
    private lazy var instructionButton = createStyledButton(title: "📖 " + LabelText.homeInstruction.text)
    private lazy var timerButton = createStyledButton(title: "⏱ " + LabelText.homeTimer.text)
    private lazy var statsButton = createStyledButton(title: "📊 " + LabelText.homeStats.text)
    private lazy var settingsButton = createStyledButton(title: "⚙️ " + LabelText.homeSettings.text)
    
    /// Стек с кнопками, чтобы удобно располагать их на экране.
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
    
    // MARK: - Настройка интерфейса
    
    /// Устанавливает компоненты на экран.
    private func setupUI() {
        view.backgroundColor = .black // Фон на случай, если видео не загрузится

        // Добавляем слои на экран
        view.addSubview(overlayView)
        view.addSubview(titleLabel)
        view.addSubview(buttonsStackView)
        
        // Настраиваем расположение затемняющего слоя
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // Растягиваем на весь экран
        }
        
        // Устанавливаем текст заголовка
        titleLabel.text = LabelText.appName.text
        
        // Настраиваем расположение заголовка
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.centerX.equalToSuperview()
        }
        
        // Настраиваем расположение кнопок
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
        }
    }
    
    /// Создаёт стилизованную кнопку с заданным текстом.
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
    
    // MARK: - Привязка данных
    
    /// Настраивает привязку данных между ViewModel и контроллером.
    private func setupBindings() {
        // Привязываем видео к слою
        viewModel.onVideoReady = { [weak self] player in
            guard let self = self else { return }
            self.playerLayer = AVPlayerLayer(player: player)
            self.playerLayer?.videoGravity = .resizeAspectFill
            self.playerLayer?.frame = self.view.bounds
            if let playerLayer = self.playerLayer {
                self.view.layer.insertSublayer(playerLayer, at: 0)
            }
        }
        
        // Привязываем навигацию между экранами
        viewModel.onNavigateTo = { [weak self] viewController in
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: - Действия
    
    /// Настраивает обработчики нажатий на кнопки.
    private func setupActions() {
        instructionButton.addTarget(self, action: #selector(openScreen(_:)), for: .touchUpInside)
        timerButton.addTarget(self, action: #selector(openScreen(_:)), for: .touchUpInside)
        statsButton.addTarget(self, action: #selector(openScreen(_:)), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(openScreen(_:)), for: .touchUpInside)
    }
    
    /// Обрабатывает нажатие на кнопку и открывает нужный экран.
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
