//
//  CalendarViewController.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 01.08.2022.
//

import Foundation
import UIKit

final class CalendarViewController: UIViewController {
    
    var previousDate: Date? {
        didSet {
            if let _ = previousDate {
                deleteButton.isEnabled = true
            }
        }
    }
    
    var dateReceiver: DateTimeReceiverDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background

        view.addSubview(cancelButton)
        view.addSubview(sheetTitle)
        view.addSubview(deleteButton)
        view.addSubview(calendarView)
        
        if let _ = previousDate { deleteButton.isEnabled = true } else {
            deleteButton.isEnabled = false
        } // :))
        
        setUpConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        let height = cancelButton.bounds.height + 30 + 320
        
        UIView.animate(withDuration: 0.2, animations: { [self] in
            preferredContentSize = CGSize(width: view.bounds.width, height: height)
        })
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
            calendarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            calendarView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -5)
            
        ])
        // Что-то с лэйаутом не так, прикрепил видео. Не работают кнопки и не видны дни недели
    }
    
   
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        let font = UIFont.systemFont(ofSize: 17, weight: .regular)
        let title = NSAttributedString(string: "Отменить", attributes: [.font: font, .foregroundColor: UIColor.systemBlue])
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissCalendar))
        button.addGestureRecognizer(tapRecognizer)
      
        button.setAttributedTitle(title, for: .normal)
        
        return button
    }()
    
    private lazy var sheetTitle: UILabel = {
        let label = UILabel()
        label.text = "Выберите дату"
        label.textColor = .mainText
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let font = UIFont.systemFont(ofSize: 17, weight: .semibold)

        let titleEnabled = NSAttributedString(string: "Удалить", attributes: [.font: font, .foregroundColor: UIColor.systemRed])
        let titleDisabled = NSAttributedString(string: "Удалить", attributes: [.font: font, .foregroundColor: UIColor.systemRed.withAlphaComponent(0.4)])
        button.addTarget(self, action: #selector(deleteSelection), for: .touchUpInside)
      
        button.setAttributedTitle(titleEnabled, for: .normal)
        button.setAttributedTitle(titleDisabled, for: .disabled)
        
        return button
    }()
    
    private lazy var calendarView: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        
        // TODO: Здесь баг. Если пользователь выберет месяц или год в ручную через всплывающее окно, .valueChanged затригерится
        
        // Да, есть такое
        datePicker.addTarget(self, action: #selector(updateSelection), for: .allEvents)
        
        if let previousDate = previousDate {
            datePicker.date = previousDate
        } 
        
        return datePicker
    }()
    
    @objc func dismissCalendar() {
        dateReceiver?.receiveDate(previousDate == nil ? nil : previousDate)
        navigationController?.fadeToRootViewController(self)
    }
    
    @objc func deleteSelection() {
        dateReceiver?.receiveDate(nil)
        navigationController?.fadeToRootViewController(self)
    }
    
    @objc func updateSelection() {
        if previousDate != calendarView.date {
            dateReceiver?.receiveDate(calendarView.date)
            navigationController?.fadeToRootViewController(self)
        }
        

    }
}



