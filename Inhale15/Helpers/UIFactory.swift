//
//  UIFactory.swift
//  Inhale15
//
//  Created by Diana on 17/02/2025.
//

import UIKit

final class UIFactory {
    
    // 📌 Создание UILabel с параметрами
    static func createLabel(fontSize: CGFloat, weight: UIFont.Weight = .regular, textColor: UIColor = .white, alignment: NSTextAlignment = .center, lines: Int = 1) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: fontSize, weight: weight)
        label.textAlignment = alignment
        label.textColor = textColor
        label.numberOfLines = lines
        return label
    }

    // 📌 Создание UIButton с параметрами
    static func createButton(title: String, fontSize: CGFloat = 18, backgroundColor: UIColor, titleColor: UIColor = .white, cornerRadius: CGFloat = 12) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: fontSize)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
        return button
    }
}

