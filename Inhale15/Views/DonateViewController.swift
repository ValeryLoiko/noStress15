//
//  DonateViewController.swift
//  Inhale15
//
//  Created by Diana on 07/02/2025.
//

import UIKit
import SnapKit
import StoreKit

class DonateViewController: UIViewController {
    
    private var products: [SKProduct] = []
    
    // Заголовок
    private let titleLabel: UILabel = UIFactory.createLabel(
        fontSize: 24,
        weight: .bold,
        textColor: .white,
        alignment: .center
    )
    
    // Описание
    private let descriptionLabel: UILabel = UIFactory.createLabel(
        fontSize: 16,
        textColor: .lightGray,
        alignment: .center,
        lines: 0
    )
    
    // StackView для кнопок донатов
    private let donateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .center
        return stackView
    }()
    
    // Кнопка закрытия
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Закрыть", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchProducts()
        SKPaymentQueue.default().add(self)
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        titleLabel.text = "Поддержите проект"
        descriptionLabel.text = "Ваши донаты помогают нам развивать приложение и добавлять новые функции. Спасибо за поддержку! ❤️"

        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(donateStackView)
        view.addSubview(closeButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        donateStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalToSuperview()
        }
    }
    
    private func fetchProducts() {
        let productIdentifiers: Set<String> = [
            "com.nostress15.donation.small",
            "com.nostress15.donation.medium",
            "com.nostress15.donation.large",
            "com.nostress15.donation.extra"
        ]
        
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func donateTapped(_ sender: UIButton) {
        guard let product = products[safe: sender.tag] else { return }
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
}

extension DonateViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("🔹 Загруженные продукты: \(response.products)")

        products = response.products.sorted(by: { $0.price.doubleValue < $1.price.doubleValue })
        
        DispatchQueue.main.async {
            self.donateStackView.arrangedSubviews.forEach { $0.removeFromSuperview() } // Очищаем перед добавлением
            
            for (index, product) in self.products.enumerated() {
                let button = UIFactory.createButton(
                    title: "\(product.localizedTitle) – \(product.priceLocale.currencySymbol ?? "$")\(product.price)",
                    backgroundColor: .systemBlue
                )
                button.tag = index
                button.addTarget(self, action: #selector(self.donateTapped(_:)), for: .touchUpInside)
                
                self.donateStackView.addArrangedSubview(button)
            }
        }
        print("🔹 Загруженные продукты: \(response.products)")
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                showThankYouAnimation()
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                showErrorAlert()
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    private func showThankYouAnimation() {
        let heartLabel = UILabel()
        heartLabel.text = "❤️"
        heartLabel.font = UIFont.systemFont(ofSize: 60)
        heartLabel.alpha = 0.0
        view.addSubview(heartLabel)
        
        heartLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.6, animations: {
            heartLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 1.0, animations: {
                heartLabel.alpha = 0.0
            }) { _ in
                heartLabel.removeFromSuperview()
            }
        }
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так. Попробуйте ещё раз.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
