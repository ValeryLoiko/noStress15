//
//  ViewController.swift
//  Inhale15
//
//  Created by Diana on 26/01/2025.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Установка оранжевого фона
        view.backgroundColor = UIColor.orange

        // Создание и настройка UILabel
        let label = UILabel()
        label.text = "Inhale15"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor.white
        label.textAlignment = .center

        // Добавление лейбла на экран
        view.addSubview(label)

        // Установка констрейнтов с помощью SnapKit
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }    }


}

