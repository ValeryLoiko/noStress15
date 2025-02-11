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
            UIColor(red: 28/255.0, green: 28/255.0, blue: 35/255.0, alpha: 1.0).cgColor,
            UIColor(red: 18/255.0, green: 18/255.0, blue: 24/255.0, alpha: 1.0).cgColor
        ]
        layer.locations = [0.0, 1.0]
        return layer
    }()
    
    private lazy var timerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.05)
        view.layer.cornerRadius = 85
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(white: 1.0, alpha: 0.1).cgColor
        
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
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 72, weight: .light)
        label.textAlignment = .center
        label.text = "0"
        label.textColor = UIColor(red: 149/255, green: 222/255, blue: 205/255, alpha: 1.0)
        return label
    }()
    
    private let timerDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.text = "секунд"
        label.textColor = UIColor(red: 149/255, green: 222/255, blue: 205/255, alpha: 1.0)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .clear
        table.separatorStyle = .singleLine
        table.separatorColor = UIColor(white: 1.0, alpha: 0.1)
        table.layer.cornerRadius = 20
        table.showsVerticalScrollIndicator = false
        table.delegate = self
        table.dataSource = self
        table.register(BreathingSessionCell.self, forCellReuseIdentifier: "BreathingSessionCell")
        return table
    }()
    
    private lazy var startPauseButton: UIButton = {
        createButton(title: "Старт", action: #selector(startPauseTapped), color: .black)
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            startPauseButton,
            createButton(title: "15 сек", action: #selector(fifteenSecTapped), color: .black),
            createButton(title: "Статистика", action: #selector(openStatsTapped), color: .black)
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
    
    private func createButton(title: String, action: Selector, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.setTitleColor(UIColor(red: 149/255, green: 222/255, blue: 205/255, alpha: 1.0), for: .normal)
        button.backgroundColor = color.withAlphaComponent(0.15)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = color.withAlphaComponent(0.3).cgColor
        button.addTarget(self, action: action, for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
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
        }    }
    
    @objc private func fifteenSecTapped() {
        viewModel.saveSessionAndStart15Sec()
    }
    
    @objc private func openStatsTapped() {
        let statsViewController = StatsViewController()
        statsViewController.modalPresentationStyle = .fullScreen
        present(statsViewController, animated: true)
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
