//
//  RoundedLabelView.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 01.08.2022.
//

import Foundation
import UIKit

final class RoundedLabelView: UIView {
    private var isTapped = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textLabel)
        setUp()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = .secondaryBackground
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
        label.textColor = .secondaryText
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTapped = true
        backgroundColor = .black.withAlphaComponent(0.1)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTapped {
            UIView.animate(withDuration: 0.1, delay: 0.1, animations: {
                self.backgroundColor = .secondaryBackground
            })
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTapped {
            UIView.animate(withDuration: 0.1, delay: 0.1, animations: {
                self.backgroundColor = .secondaryBackground
            })
            
        }
    }
    
}
