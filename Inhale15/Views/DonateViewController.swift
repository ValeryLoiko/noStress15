//
//  DonateViewController.swift
//  Inhale15
//
//  Created by Diana on 07/02/2025.
//

import UIKit
import SnapKit

class DonateViewController: UIViewController {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Поддержите проект"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usdtAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "USDT (TRC20)"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addressTextField: UITextField = {
        let textField = UITextField()
        textField.text = "TRC20USDT_ADDRESS_HERE"
        textField.isUserInteractionEnabled = false
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 14)
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let copyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Копировать адрес", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let thankYouLabel: UILabel = {
        let label = UILabel()
        label.text = "Спасибо за вашу поддержку! ❤️"
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground.withAlphaComponent(0.95)
        
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(usdtAddressLabel)
        containerView.addSubview(addressTextField)
        containerView.addSubview(copyButton)
        containerView.addSubview(thankYouLabel)
        view.addSubview(closeButton)
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.7)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalToSuperview().offset(-20)
            make.size.equalTo(36)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(32)
            make.leading.equalTo(containerView).offset(20)
            make.trailing.equalTo(containerView).offset(-20)
        }
        
        usdtAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.equalTo(containerView).offset(20)
            make.trailing.equalTo(containerView).offset(-20)
        }
        
        addressTextField.snp.makeConstraints { make in
            make.top.equalTo(usdtAddressLabel.snp.bottom).offset(12)
            make.leading.equalTo(containerView).offset(20)
            make.trailing.equalTo(containerView).offset(-20)
            make.height.equalTo(44)
        }
        
        copyButton.snp.makeConstraints { make in
            make.top.equalTo(addressTextField.snp.bottom).offset(20)
            make.centerX.equalTo(containerView)
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        
        thankYouLabel.snp.makeConstraints { make in
            make.top.equalTo(copyButton.snp.bottom).offset(24)
            make.leading.equalTo(containerView).offset(20)
            make.trailing.equalTo(containerView).offset(-20)
            make.bottom.equalTo(containerView).offset(-32)
        }
    }
    
    private func setupActions() {
        copyButton.addTarget(self, action: #selector(copyAddress), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc private func copyAddress() {
        UIPasteboard.general.string = addressTextField.text
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Анимация копирования
        UIView.animate(withDuration: 0.2) {
            self.copyButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.copyButton.transform = .identity
            }
        }
        
        // Показываем уведомление о копировании
        let originalTitle = copyButton.title(for: .normal)
        copyButton.setTitle("Скопировано! ✓", for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.copyButton.setTitle(originalTitle, for: .normal)
        }
    }
}

