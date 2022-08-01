//
//  DateTimeFieldView.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 31.07.2022.
//

import Foundation
import UIKit

final class RoundedButton: UIView {
    
    private let gradient = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textLabel)
        setUp()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
    
    private func setUp() {
        // TODO: Make resource file with all the colors
        backgroundColor = UIColor(red: 0.949, green: 0.953, blue: 0.961, alpha: 1)
        layer.cornerRadius = 10
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
        
    }
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Сейчас"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    func setText(text: String, color: UIColor, fontSize: CGFloat, fontWeight: UIFont.Weight) {
        textLabel.text = text
        textLabel.textColor = color
        textLabel.font = .systemFont(ofSize: fontSize, weight: fontWeight)
    }
    
    func setUpGradient() {
        let gradientColorSet = [[
                UIColor(red: 89/255, green: 156/255, blue: 1, alpha: 1).cgColor,
                UIColor(red: 110/255, green: 96/255, blue: 206/255 , alpha: 1).cgColor,
                UIColor(red: 179/255, green: 79/255, blue: 177/255 , alpha: 1).cgColor,
                UIColor(red: 233/255, green: 115/255, blue: 74/255 , alpha: 1).cgColor
        ]]
               
        gradient.frame = bounds
        gradient.colors = gradientColorSet[0]
        gradient.cornerRadius = 10
        gradient.startPoint = CGPoint(x:0.0, y:0.0)
        gradient.endPoint = CGPoint(x:1.0, y:0.0)
               
        layer.insertSublayer(gradient, at: 0)
        

    }
}
