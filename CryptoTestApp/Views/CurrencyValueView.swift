//
//  CurrencyValueView.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 31.07.2022.
//

import Foundation
import UIKit

final class CurrencyValueView: UIStackView {
    
    let excangeCount = 1
    var excangeResult = 1483.03 {
        didSet {
            resultLabel.text = "= \(excangeResult) $"
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .horizontal
        spacing = 0
        contentMode = .center
        addArrangedSubview(amountToExcange)
        addArrangedSubview(currencyImage)
        addArrangedSubview(resultLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var amountToExcange: UILabel = {
        let label = UILabel()
        label.text = String(excangeCount)
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private lazy var currencyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "currencyLogo")
        imageView.contentMode = .scaleAspectFit
       
        return imageView
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.text = " = \(excangeResult) $"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    

}
