//
//  CurrencyValueView.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 31.07.2022.
//

import Foundation
import UIKit

final class CurrencyValueView: UIStackView {
    
    let exchangeCount = 1
    var exchangeResult = 0.0 {
        didSet {
            if oldValue == 0.0 { resultLabel.alpha = 1 }
            
            UIView.animate(withDuration: 0.2) { [self] in
                self.resultLabel.text = "= \(exchangeResult) $"
            }
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
        label.text = String(exchangeCount)
        label.textColor = .mainText
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
        label.text = " = \(exchangeResult) $"
        label.textColor = .mainText
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    

}
