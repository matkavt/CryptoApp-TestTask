//
//  DateTimeSettingView.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 01.08.2022.
//

import Foundation
import UIKit

final class DateTimeSettingView: UIView {

    func setUpTimeSetting(for date: Date, for time: Date?, with icon: UIImage?, title: String, showWeekDay: Bool) {
        let calendar = Calendar(identifier: .gregorian)
        let dayOfTheWeek = calendar.component(.weekday, from: date)
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        
        if let time = time {
            dateLabel.text = "\(Date.getWeekdayLocalizedRussian(by: dayOfTheWeek)!), \(format.string(from: time))"
        } else {
            dateLabel.text = Date.getWeekdayLocalizedRussian(by: dayOfTheWeek)!
        }
        
        self.icon.image = icon
        titleLabel.text = title
        if !showWeekDay {
            dateLabel.isHidden = true
        }
        
        addSubview(self.icon)
        addSubview(titleLabel)
        addSubview(dateLabel)
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 28),
            icon.heightAnchor.constraint(equalToConstant: 28),
            
            titleLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    private lazy var icon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let textColor = UIColor(red: 124/255, green: 137/255, blue: 163/255, alpha: 1)
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = textColor
        return label
    }()
    
}

