//
//  CopyToClipboardView.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 03.08.2022.
//

import Foundation
import UIKit

final class CopyToClipboardView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background.withAlphaComponent(0.9)
        layer.cornerRadius = 10

        addSubview(icon)
        addSubview(textLabel)
        
        setUp()
        
    }
    
    private func setUp() {
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            icon.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            icon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            icon.widthAnchor.constraint(equalToConstant: 24),
            icon.heightAnchor.constraint(equalToConstant: 24),
            
            textLabel.centerYAnchor.constraint(equalTo: icon.centerYAnchor),
            textLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 12),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "checkmarkIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Скопировано в буфер обмена" // Зачем локализация дней недели, если тут её нет
        label.textColor = .mainText
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    
}
