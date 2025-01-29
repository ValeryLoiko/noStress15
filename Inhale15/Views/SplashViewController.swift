//
//  SplashViewController.swift
//  Inhale15
//
//  Created by Diana on 29/01/2025.
//

import UIKit
import SnapKit

class SplashViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "background"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(logoImageView)
        //  view.addSubview(animationView)
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.height.equalTo(150)
        }
        
        //          animationView.snp.makeConstraints { make in
        //              make.centerX.equalToSuperview()
        //              make.top.equalTo(logoImageView.snp.bottom).offset(20)
        //              make.width.height.equalTo(100)
        //          }
    }
    
    
}
