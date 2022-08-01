//
//  LiveLabelView.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 31.07.2022.
//

import Foundation
import UIKit

final class LiveLabelView: UIView {
    private let gradient = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(liveLabel)
        layer.cornerRadius = 4
        setUpConstraints()
        setUpGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
    
    private func setUpGradient() {
            
        let gradientColorSet = [[
                UIColor(red: 252/255, green: 30/255, blue: 123/255, alpha: 1).cgColor,
                UIColor(red: 250/255, green: 51/255, blue: 73/255 , alpha: 1).cgColor,
        ]]
               
        gradient.frame = bounds
        gradient.colors = gradientColorSet[0]
        gradient.cornerRadius = 4
        gradient.startPoint = CGPoint(x:1.0, y:1.0)
        gradient.endPoint = CGPoint(x:0.0, y:0.0)
               
        layer.insertSublayer(gradient, at: 0)
    }
    
    private func setUpConstraints() {
        liveLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            liveLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            liveLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            liveLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            liveLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }
    
    private lazy var liveLabel: UILabel = {
        let label = UILabel()
        
        label.text = "LIVE"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        
        return label
       
    }()
}
