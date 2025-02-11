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
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.05)
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(white: 1.0, alpha: 0.1).cgColor
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(white: 1.0, alpha: 0.6)
        return label
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .light) // Чуть уменьшил, чтобы лучше смотрелось
        label.textColor = UIColor(red: 149/255, green: 222/255, blue: 205/255, alpha: 1.0)
        return label
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
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)) // Добавили отступы
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(12)
        }
        
        durationLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4) // Чуть уменьшил расстояние между строками
            make.left.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12) // Отступ снизу, чтобы текст не прилипал
        }
    }
    
    func configure(with session: BreathSession) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        dateLabel.text = dateFormatter.string(from: session.date ?? Date())
        durationLabel.text = String(format: "%.0f секунд", session.duration)
    }
}


