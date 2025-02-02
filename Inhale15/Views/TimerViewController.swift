//
//  TimerViewController.swift
//  Inhale15
//
//  Created by Diana on 29/01/2025.
//

import UIKit

class TimerViewController: UIViewController {
    
    private let viewModel = TimerViewModel()
    private let timerLabel = UILabel()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
      
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 12/255.0, green: 8/255.0, blue: 67/255.0, alpha: 1.0)
        
        timerLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        timerLabel.textAlignment = .center
        view.addSubview(timerLabel)
        
        timerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
        }
        
        let startPauseButton = createButton(title: "Старт/Пауза", action: #selector(startPauseTapped))
        let fifteenSecButton = createButton(title: "15 сек", action: #selector(fifteenSecTapped))
        let resetButton = createButton(title: "Сброс", action: #selector(resetTapped))
        let clearHistoryButton = createButton(title: "Очистить историю", action: #selector(clearHistoryTapped))
        
        let stack = UIStackView(arrangedSubviews: [startPauseButton, fifteenSecButton, resetButton, clearHistoryButton])
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timerLabel.snp.bottom).offset(40)
        }
        
//        tableView.dataSource = self
//        view.addSubview(tableView)
//        tableView.snp.makeConstraints { make in
//            make.top.equalTo(stack.snp.bottom).offset(20)
//            make.left.right.bottom.equalToSuperview()
//        }
//        tableView.backgroundColor = UIColor(red: 12/255.0, green: 8/255.0, blue: 67/255.0, alpha: 1.0)

    }
    
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func bindViewModel() {
       
    }
    
    @objc private func startPauseTapped() {
    
    }
    
    @objc private func fifteenSecTapped() {
    }
    
    @objc private func resetTapped() {
    }
    
    @objc private func clearHistoryTapped() {
     
    }
}

//extension TimerViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.sessions.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
//        let session = viewModel.sessions[indexPath.row]
//        cell.textLabel?.text = "Длительность: \(session.duration) сек"
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        formatter.timeStyle = .short
//        cell.detailTextLabel?.text = "Дата: \(formatter.string(from: session.date ?? Date()))"
//        return cell
//    }
//
//}
