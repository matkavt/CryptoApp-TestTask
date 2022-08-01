//
//  CalendarViewController.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 01.08.2022.
//

import Foundation
import UIKit

final class CalendarViewController: UIViewController {
    
    private var previousDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(cancelButton)
        view.addSubview(sheetTitle)
        view.addSubview(deleteButton)
        view.addSubview(calendarView)
        
        deleteButton.isEnabled = false
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 15),
            cancelButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            
            sheetTitle.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            sheetTitle.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            deleteButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            deleteButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 15),
            
            calendarView.topAnchor.constraint(equalTo: sheetTitle.bottomAnchor, constant: 15),
            calendarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            calendarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30)
            
        ])
    }
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        let font = UIFont.systemFont(ofSize: 17, weight: .regular)
        let textColor = UIColor(red: 0, green: 80/255, blue: 207/255, alpha: 1)
        let title = NSAttributedString(string: "Отменить", attributes: [.font: font, .foregroundColor: textColor])
      
        button.setAttributedTitle(title, for: .normal)
        
        return button
    }()
    
    private lazy var sheetTitle: UILabel = {
        let label = UILabel()
        label.text = "Выберите дату"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        let font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        let textColorEnabled = UIColor(red: 230/255, green: 70/255, blue: 70/255, alpha: 1)
        let textColorDisabled = UIColor(red: 230/255, green: 70/255, blue: 70/255, alpha: 0.4)

        let titleEnabled = NSAttributedString(string: "Удалить", attributes: [.font: font, .foregroundColor: textColorEnabled])
        let titleDisabled = NSAttributedString(string: "Удалить", attributes: [.font: font, .foregroundColor: textColorDisabled])
      
        button.setAttributedTitle(titleEnabled, for: .normal)
        button.setAttributedTitle(titleDisabled, for: .disabled)
        
        return button
    }()
    
    private lazy var calendarView: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.sizeToFit()
        
        if let previousDate = previousDate {
            datePicker.date = previousDate
        } 
        
        return datePicker
    }()
}

