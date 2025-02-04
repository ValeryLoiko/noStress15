//
//  StatsViewController.swift
//  Inhale15
//
//  Created by Diana on 29/01/2025.
//

import UIKit
import DGCharts

class StatsViewController: UIViewController {
    private let viewModel = StatsViewModel()

    private let averageCardView = UIView()
    private let recordCardView = UIView()
    private let averageLabel = UILabel()
    private let recordLabel = UILabel()
    private let lineChartView = LineChartView()
    private let periodSegmentedControl = UISegmentedControl(items: ["День", "Неделя", "Месяц"])

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateStatistics(for: .day)
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        setupSegmentControl()
        setupCardViews()
        setupChart()
    }

    private func setupSegmentControl() {
        periodSegmentedControl.selectedSegmentIndex = 0
        periodSegmentedControl.addTarget(self, action: #selector(periodChanged(_:)), for: .valueChanged)
        
        view.addSubview(periodSegmentedControl)
        periodSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
        }
    }

    private func setupCardViews() {
        [averageCardView, recordCardView].forEach { card in
            card.backgroundColor = .systemGray6
            card.layer.cornerRadius = 15
            card.layer.shadowColor = UIColor.black.cgColor
            card.layer.shadowOpacity = 0.1
            card.layer.shadowOffset = CGSize(width: 0, height: 5)
            card.layer.shadowRadius = 10
            view.addSubview(card)
        }
        
        averageCardView.snp.makeConstraints { make in
            make.top.equalTo(periodSegmentedControl.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(100)
        }
        
        recordCardView.snp.makeConstraints { make in
            make.top.equalTo(averageCardView.snp.bottom).offset(20)
            make.left.right.height.equalTo(averageCardView)
        }
        
        [averageLabel, recordLabel].forEach { label in
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        }
        
        averageCardView.addSubview(averageLabel)
        recordCardView.addSubview(recordLabel)
        
        averageLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        recordLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func setupChart() {
        view.addSubview(lineChartView)
        lineChartView.snp.makeConstraints { make in
            make.top.equalTo(recordCardView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(300)
        }
        
        lineChartView.chartDescription.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
    }

    private func updateStatistics(for period: Calendar.Component) {
        let avgDuration = viewModel.getAverageDuration(for: period)
        let recordDuration = viewModel.getRecordDuration(for: period)
        
        averageLabel.text = "Средняя длительность: \(String(format: "%.2f", avgDuration)) сек"
        recordLabel.text = "Рекорд: \(String(format: "%.2f", recordDuration)) сек"

        updateChart(with: period)
    }

    private func updateChart(with period: Calendar.Component) {
        let sessions = viewModel.fetchSessions(for: period)
        let entries = sessions.enumerated().map { index, session in
            ChartDataEntry(x: Double(index + 1), y: session.duration)
        }

        let dataSet = LineChartDataSet(entries: entries, label: "Дыхательные сессии")
        dataSet.colors = [.systemBlue]
        dataSet.circleColors = [.systemBlue]
        dataSet.circleRadius = 5
        dataSet.lineWidth = 2

        let data = LineChartData(dataSet: dataSet)
        lineChartView.data = data
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
