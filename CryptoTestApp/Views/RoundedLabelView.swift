//
//  RoundedLabelView.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 01.08.2022.
//

import Foundation
import UIKit

final class RoundedLabelView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textLabel)
        setUp()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        label.text = ""
        label.textAlignment = .center
        return label
    }()
    
    func setText(text: String, color: UIColor, fontSize: CGFloat, fontWeight: UIFont.Weight) {
        textLabel.text = text
        textLabel.textColor = color
        textLabel.font = .systemFont(ofSize: fontSize, weight: fontWeight)
    }
    
    func getText() -> String {
        return textLabel.text ?? ""
    }
    
}
