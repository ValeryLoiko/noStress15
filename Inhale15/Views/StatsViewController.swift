//
//  StatsViewController.swift
//  Inhale15
//
//  Created by Diana on 29/01/2025.
//

import UIKit
import DGCharts
import SnapKit

protocol StatsViewControllerDelegate: AnyObject {
    func didClearHistory()
}

class StatsViewController: UIViewController {
    weak var delegate: StatsViewControllerDelegate?
    private let viewModel = StatsViewModel()
    private let coreDataService = CoreDataService.shared
    
    private let primaryColor = UIColor(red: 149/255, green: 222/255, blue: 205/255, alpha: 1.0)
    
    private lazy var backgroundGradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 28/255, green: 28/255, blue: 35/255, alpha: 1.0).cgColor,
            UIColor(red: 18/255, green: 18/255, blue: 24/255, alpha: 1.0).cgColor
        ]
        layer.locations = [0.0, 1.0]
        return layer
    }()
    
    private let averageLabel = UILabel()
    private let recordLabel = UILabel()
    private let lineChartView = LineChartView()
    private let periodSegmentedControl = UISegmentedControl(items: ["День", "Неделя", "Месяц"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateStatistics(for: .day)
        NotificationCenter.default.post(name: NSNotification.Name("HistoryCleared"), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradientLayer.frame = view.bounds
    }
    
    private func setupUI() {
        view.addSubview(periodSegmentedControl)
        view.addSubview(lineChartView)
        view.addSubview(clearHistoryButton)
        view.addSubview(clearHistoryButton)
        view.bringSubviewToFront(clearHistoryButton)
        clearHistoryButton.snp.makeConstraints { make in
            make.top.equalTo(lineChartView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        view.layer.insertSublayer(backgroundGradientLayer, at: 0)
        
        setupSegmentControl()
        setupStatCards()
        setupChart()
    }
    
    private func setupSegmentControl() {
        periodSegmentedControl.selectedSegmentIndex = 0
        periodSegmentedControl.addTarget(self, action: #selector(periodChanged(_:)), for: .valueChanged)
        periodSegmentedControl.selectedSegmentTintColor = primaryColor.withAlphaComponent(0.3)
        periodSegmentedControl.setTitleTextAttributes([.foregroundColor: primaryColor], for: .selected)
        
        view.addSubview(periodSegmentedControl)
        periodSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
        }
    }
    
    private func setupStatCards() {
        let stackView = UIStackView(arrangedSubviews: [averageLabel, recordLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        
        averageLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        recordLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        averageLabel.textColor = primaryColor
        recordLabel.textColor = primaryColor
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(periodSegmentedControl.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
    }
    
    private lazy var clearHistoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Очистить историю", for: .normal)
        button.setTitleColor(primaryColor, for: .normal)
        button.backgroundColor = primaryColor.withAlphaComponent(0.2)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(clearHistoryTapped), for: .touchUpInside)
        return button
    }()
    
    private func setupChart() {
        view.addSubview(lineChartView)
        lineChartView.snp.makeConstraints { make in
            make.top.equalTo(recordLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(300)
        }
        
        lineChartView.chartDescription.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.labelTextColor = primaryColor
        lineChartView.xAxis.labelFont = .systemFont(ofSize: 14, weight: .medium)
        lineChartView.xAxis.axisLineColor = primaryColor
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter()
        
        lineChartView.leftAxis.labelTextColor = primaryColor
        lineChartView.leftAxis.labelFont = .systemFont(ofSize: 14, weight: .medium)
        lineChartView.leftAxis.axisLineColor = primaryColor
        lineChartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: timeFormatter())
        
        lineChartView.legend.textColor = primaryColor
        lineChartView.animate(xAxisDuration: 1.2, yAxisDuration: 1.2)
    }
    
    @objc private func clearHistoryTapped() {
        coreDataService.deleteAllSessions()
        updateChart(with: .day)
        updateStatistics(for: .day)
        delegate?.didClearHistory() // Уведомляем делегата, что история очищена
    }

    
    private func updateStatistics(for period: Calendar.Component) {
        let avgDuration = viewModel.getAverageDuration(for: period)
        let recordDuration = viewModel.getRecordDuration(for: period)
        
        averageLabel.text = "Средняя длительность: \(formatTime(avgDuration) )"
        recordLabel.text = "Рекорд: \(formatTime(recordDuration) )"
        
        updateChart(with: period)
    }
    
    private func updateChart(with period: Calendar.Component) {
        let sessions = viewModel.fetchSessions(for: period)
        let entries = sessions.reversed().enumerated().map { index, session in
            ChartDataEntry(x: Double(index + 1), y: session.duration)
        }
        
        let dataSet = LineChartDataSet(entries: entries, label: "Сессии")
        dataSet.colors = [primaryColor]
        dataSet.circleColors = [primaryColor]
        dataSet.circleRadius = 5
        dataSet.lineWidth = 2
        
        let data = LineChartData(dataSet: dataSet)
        data.setValueTextColor(primaryColor)
        data.setValueFormatter(DefaultValueFormatter(formatter: timeFormatter()))
        lineChartView.data = data
    }
    
    private func formatTime(_ duration: Double) -> String {
        if duration >= 60 {
            let minutes = Int(duration) / 60
            let seconds = Int(duration) % 60
            return "\(minutes) мин \(seconds) сек"
        } else {
            return "\(Int(duration)) сек"
        }
    }
    
    private func timeFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.positiveFormat = "#,##0 сек"
        return formatter
    }
    
    @objc private func periodChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            updateStatistics(for: .day)
        case 1:
            updateStatistics(for: .weekOfYear)
        case 2:
            updateStatistics(for: .month)
        default:
            break
        }
    }
}
