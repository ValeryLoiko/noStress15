//
//  TimerViewController.swift
//  Inhale15
//
//  Created by Diana on 29/01/2025.
//

import UIKit
import SnapKit

class TimerViewController: UIViewController {
    
    private let viewModel = TimerViewModel()
    
    private lazy var backgroundGradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            ColorPalette.backgroundDark.cgColor,
            UIColor.black.cgColor
        ]
        layer.locations = [0.0, 1.0]
        return layer
    }()
    
    private lazy var timerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.cellBackground
        view.layer.cornerRadius = 85
        view.layer.borderWidth = 1
        view.layer.borderColor = ColorPalette.border.cgColor
        view.addSubview(timerLabel)
        view.addSubview(timerDescriptionLabel)
        
        timerLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        timerDescriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timerLabel.snp.bottom)
        }
        
        return view
    }()
    
    private let timerLabel = UIFactory.createLabel(fontSize: 72, weight: .light, textColor: ColorPalette.primary)
    private let timerDescriptionLabel = UIFactory.createLabel(fontSize: 14, textColor: ColorPalette.textGray)
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .clear
        table.separatorStyle = .singleLine
        table.separatorColor = ColorPalette.border
        table.layer.cornerRadius = 20
        table.showsVerticalScrollIndicator = false
        table.delegate = self
        table.dataSource = self
        table.register(BreathingSessionCell.self, forCellReuseIdentifier: "BreathingSessionCell")
        return table
    }()
    
    private lazy var startPauseButton = UIFactory.createButton(title: "Старт", backgroundColor: ColorPalette.primary)
    private lazy var fifteenSecButton = UIFactory.createButton(title: "15 сек", backgroundColor: ColorPalette.primary)
    private lazy var statsButton = UIFactory.createButton(title: "Статистика", backgroundColor: ColorPalette.primary)
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            startPauseButton, fifteenSecButton, statsButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchSessions()
        
        startPauseButton.addTarget(self, action: #selector(startPauseTapped), for: .touchUpInside)
        fifteenSecButton.addTarget(self, action: #selector(fifteenSecTapped), for: .touchUpInside)
        statsButton.addTarget(self, action: #selector(openStatsTapped), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradientLayer.frame = view.bounds
    }
    
    private func setupUI() {
        view.layer.insertSublayer(backgroundGradientLayer, at: 0)
        view.addSubview(timerContainer)
        view.addSubview(buttonsStackView)
        view.addSubview(tableView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        timerContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.height.equalTo(170)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timerContainer.snp.bottom).offset(50)
            make.width.equalTo(200)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(buttonsStackView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] elapsedTime in
            DispatchQueue.main.async {
                self?.updateTimerLabel(elapsedTime)
            }
        }
        
        viewModel.onSessionsUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func updateTimerLabel(_ elapsedTime: TimeInterval) {
        timerLabel.text = String(format: "%.0f", elapsedTime)
    }
    
    // MARK: - Actions
    
    @objc private func startPauseTapped() {
        if viewModel.isTimerRunning {
            viewModel.pauseTimer()
            startPauseButton.setTitle("Старт", for: .normal)
        } else {
            viewModel.startTimer()
            startPauseButton.setTitle("Пауза", for: .normal)
        }
    }
    
    @objc private func fifteenSecTapped() {
        viewModel.saveSessionAndStart15Sec()
    }
    
    @objc private func openStatsTapped() {
        let statsViewController = StatsViewController()
        statsViewController.delegate = self
        navigationController?.pushViewController(statsViewController, animated: true)
    }
}

// MARK: - StatsViewControllerDelegate
extension TimerViewController: StatsViewControllerDelegate {
    func didClearHistory() {
        viewModel.fetchSessions()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension TimerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(viewModel.sessions.count, 3)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BreathingSessionCell", for: indexPath) as? BreathingSessionCell else {
            return UITableViewCell()
        }
        
        let session = viewModel.sessions[indexPath.row]
        cell.configure(with: session)
        return cell
    }
}

