//
//  TimePickerController.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 01.08.2022.
//

import Foundation
import UIKit

final class TimePickerViewController: UIViewController {
    
    var timeReceiver: DateTimeReceiverDelegate?
    var previousTime: Date? {
        didSet {
            deleteButton.isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background

        view.addSubview(cancelButton)
        view.addSubview(sheetTitle)
        view.addSubview(deleteButton)
        view.addSubview(timeView)
        view.addSubview(chooseButton)
        
        if let _ = previousTime { deleteButton.isEnabled = true } else {
            deleteButton.isEnabled = false
        }
        
        setUpConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        let height = cancelButton.bounds.height + chooseButton.bounds.height + 15 + 30 + 206
        preferredContentSize = CGSize(width: view.bounds.width, height: height)
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
            
            timeView.topAnchor.constraint(equalTo: sheetTitle.bottomAnchor, constant: 15),
            timeView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            timeView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            
            chooseButton.topAnchor.constraint(equalTo: timeView.bottomAnchor, constant: 15),
            chooseButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 12),
            chooseButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12)
            
        ])
        
        view.layoutIfNeeded()
    }
    
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        button.addGestureRecognizer(tapRecognizer)
        
        let font = UIFont.systemFont(ofSize: 17, weight: .regular)
        let title = NSAttributedString(string: "Отменить", attributes: [.font: font, .foregroundColor: UIColor.systemBlue])
      
        button.setAttributedTitle(title, for: .normal)
        
        return button
    }()
    
    private lazy var sheetTitle: UILabel = {
        let label = UILabel()
        label.text = "Выберите время"
        label.textColor = .mainText
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteSelection))
        button.addGestureRecognizer(tapRecognizer)
        
        let font = UIFont.systemFont(ofSize: 17, weight: .semibold)

        let titleEnabled = NSAttributedString(string: "Удалить", attributes: [.font: font, .foregroundColor: UIColor.systemRed])
        let titleDisabled = NSAttributedString(string: "Удалить", attributes: [.font: font, .foregroundColor: UIColor.systemRed.withAlphaComponent(0.4)])
      
        button.setAttributedTitle(titleEnabled, for: .normal)
        button.setAttributedTitle(titleDisabled, for: .disabled)
        
        return button
    }()
    
    private lazy var timeView: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .time
        datePicker.locale = Locale.init(identifier: "en_gb") // Почему не "ru"? 🧐
        datePicker.sizeToFit()
        
        if let previousTime = previousTime {
            datePicker.date = previousTime
        }
        
        return datePicker
    }()
    
    private lazy var chooseButton: RoundedButton = {
        let roundedButton = RoundedButton()
        roundedButton.setText(text: "Выбрать", color: .white, fontSize: 17, fontWeight: .medium)
        roundedButton.backgroundColor = .systemBlue
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateSelection))
        roundedButton.addGestureRecognizer(tapRecognizer)
        return roundedButton
        
    }()
    
    @objc func dismissPicker() {
        timeReceiver?.receiveTime(previousTime == nil ? nil : previousTime)
        navigationController?.fadeToRootViewController(self)
    }
    
    @objc func deleteSelection() {
        timeReceiver?.receiveTime(nil)
        navigationController?.fadeToRootViewController(self)
    }
    
    @objc func updateSelection() {
        timeReceiver?.receiveTime(timeView.date)
        navigationController?.fadeToRootViewController(self)
    }
    
    
}
