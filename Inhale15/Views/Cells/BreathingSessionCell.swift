//
//  BreathingSessionCell.swift
//  Inhale15
//
//  Created by Diana on 11/02/2025.
//

import UIKit
import SnapKit

class BreathingSessionCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.cellBackground
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = ColorPalette.border.cgColor
        return view
    }()
    
    private let dateLabel = UIFactory.createLabel(fontSize: 13, textColor: ColorPalette.textGray)
    private let durationLabel = UIFactory.createLabel(fontSize: 24, weight: .light, textColor: ColorPalette.primary)
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(dateLabel)
        containerView.addSubview(durationLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(12)
        }
        
        durationLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    func configure(with session: BreathSession) {
        dateLabel.text = Self.dateFormatter.string(from: session.date ?? Date())
        durationLabel.text = String(format: "%.0f", session.duration)
    }
}

