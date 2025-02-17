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

    private lazy var backgroundGradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            ColorPalette.backgroundDark.cgColor,
            UIColor.black.cgColor
        ]
        layer.locations = [0.0, 1.0]
        return layer
    }()

    private let averageLabel = UIFactory.createLabel(fontSize: 20, weight: .medium, textColor: ColorPalette.primary)
    private let recordLabel = UIFactory.createLabel(fontSize: 20, weight: .medium, textColor: ColorPalette.primary)
    private let lineChartView = LineChartView()
    private let periodSegmentedControl = UISegmentedControl(items: ["День", "Неделя", "Месяц"])

    private lazy var clearHistoryButton: UIButton = {
        let button = UIFactory.createButton(title: "Очистить историю", backgroundColor: ColorPalette.primary.withAlphaComponent(0.2))
        button.addTarget(self, action: #selector(clearHistoryTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateStatistics(for: .day)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradientLayer.frame = view.bounds
    }

    private func setupUI() {
        view.layer.insertSublayer(backgroundGradientLayer, at: 0)
        setupSegmentControl()
        setupStatCards()
        setupChart()
        
        view.addSubview(clearHistoryButton)
        clearHistoryButton.snp.makeConstraints { make in
            make.top.equalTo(lineChartView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
    }

    private func setupSegmentControl() {
        periodSegmentedControl.selectedSegmentIndex = 0
        periodSegmentedControl.addTarget(self, action: #selector(periodChanged(_:)), for: .valueChanged)
        periodSegmentedControl.selectedSegmentTintColor = ColorPalette.primary.withAlphaComponent(0.3)
        periodSegmentedControl.setTitleTextAttributes([.foregroundColor: ColorPalette.primary], for: .selected)

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

        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(periodSegmentedControl.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
    }

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
        lineChartView.xAxis.labelTextColor = ColorPalette.primary
        lineChartView.leftAxis.labelTextColor = ColorPalette.primary
        lineChartView.legend.textColor = ColorPalette.primary
        lineChartView.animate(xAxisDuration: 1.2, yAxisDuration: 1.2)
    }

    @objc private func clearHistoryTapped() {
        coreDataService.deleteAllSessions()
        updateStatistics(for: .day)
        delegate?.didClearHistory() // Уведомляем делегата
    }

    private func updateStatistics(for period: Calendar.Component) {
        let avgDuration = viewModel.getAverageDuration(for: period)
        let recordDuration = viewModel.getRecordDuration(for: period)

        averageLabel.text = "Средняя длительность: \(formatTime(avgDuration))"
        recordLabel.text = "Рекорд: \(formatTime(recordDuration))"
        
        updateChart(with: period)
    }

    private func updateChart(with period: Calendar.Component) {
        let sessions = viewModel.fetchSessions(for: period).reversed() // 🔄 Разворачиваем массив
        
        let entries = sessions.enumerated().map { index, session in
            ChartDataEntry(x: Double(index + 1), y: session.duration)
        }

        let dataSet = LineChartDataSet(entries: entries, label: "Сессии")
        dataSet.colors = [ColorPalette.primary]
        dataSet.circleColors = [ColorPalette.primary]
        dataSet.circleRadius = 5
        dataSet.lineWidth = 2

        let data = LineChartData(dataSet: dataSet)
        data.setValueTextColor(ColorPalette.primary)
        
        lineChartView.data = data
    }


    private func formatTime(_ duration: Double) -> String {
        return duration >= 60 ? "\(Int(duration) / 60) мин \(Int(duration) % 60) сек" : "\(Int(duration)) сек"
    }

    @objc private func periodChanged(_ sender: UISegmentedControl) {
        let periods: [Calendar.Component] = [.day, .weekOfYear, .month]
        updateStatistics(for: periods[sender.selectedSegmentIndex])
    }
}
