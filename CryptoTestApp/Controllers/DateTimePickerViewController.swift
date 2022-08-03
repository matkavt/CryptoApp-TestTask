//
//  DateTimePickerViewController.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 31.07.2022.
//

import Foundation
import UIKit

final class DateTimePickerViewController: UIViewController {
    
    var receiverDelegate: DateTimeReceiverDelegate?
    var labelConstraint: NSLayoutConstraint?
    
    var dateChosen: Date? {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.updateDateView(with: self.dateChosen)
                self.updateDoneButton()
            }
        }
    }
    
    var timeChosen: Date? {
        didSet {
            UIView.animate(withDuration: 0.2) { [self] in
                updateTimeView(with: self.timeChosen)
                updateDoneButton()
                dateTimeOptions.setUpOptionsMenu(with: self.timeChosen)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(cancelButton)
        view.addSubview(sheetTitle)
        view.addSubview(doneButton)
        view.addSubview(dateTimeFields)
        view.addSubview(dateTimeOptions)
        
        setUpConstraints()
        
    }
    
    private func setUpConstraints() {
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 13),
            cancelButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            
            sheetTitle.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            sheetTitle.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            doneButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            doneButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 13),
            
            dateTimeFields.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 20),
            dateTimeFields.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 13),
            dateTimeFields.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -13),
            
            dateTimeOptions.topAnchor.constraint(equalTo: dateTimeFields.bottomAnchor, constant: 10),
            dateTimeOptions.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            dateTimeOptions.widthAnchor.constraint(equalTo: safeArea.widthAnchor)
        ])
        
        view.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        let height = cancelButton.bounds.height + dateTimeFields.bounds.height + dateTimeOptions.bounds.height + 15 + 25 + 10
        preferredContentSize = CGSize(width: view.bounds.width, height: height)
    }
    
    
    
    // - MARK: Updating UI Elements
    
    private func updateDoneButton() {
        if let _ = dateChosen, let _ = timeChosen {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
    }
    
    private func updateDateView(with date: Date?) {
        if let dateChosen = date {
            dateView.setText(text: Date.dateToLocalizedString(for: .ru, date: dateChosen, withHours: false), color: .mainText, fontSize: 16, fontWeight: .regular)
        } else {
            dateView.setText(text: "Выберите дату", color: .secondaryText, fontSize: 16, fontWeight: .regular)
        }
    }
    
    private func updateTimeView(with date: Date?) {
        if let timeChosen = date {
            let format = DateFormatter()
            format.dateFormat = "HH:mm"
            dateView.widthAnchor.constraint(lessThanOrEqualToConstant: 269).isActive = true
            labelConstraint = timeView.widthAnchor.constraint(equalToConstant: 72)
            labelConstraint?.isActive = true
            timeView.setText(text: format.string(from: timeChosen), color: .mainText, fontSize: 16, fontWeight: .regular)
        } else {
            timeView.setText(text: "Выберите время", color: .secondaryText, fontSize: 16, fontWeight: .regular)
            timeView.widthAnchor.constraint(lessThanOrEqualToConstant: 170).isActive = true
            labelConstraint?.isActive = false
        }
        
    }
    
    
    
    // - MARK: UI Elements
    
    private var dateView = RoundedLabelView()
    private var timeView = RoundedLabelView()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        let font = UIFont.systemFont(ofSize: 17, weight: .regular)
        let title = NSAttributedString(string: "Отменить", attributes: [.font: font, .foregroundColor: UIColor.systemBlue])
        
        button.setAttributedTitle(title, for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var sheetTitle: UILabel = {
        let label = UILabel()
        label.text = "Дата и время"
        label.textColor = .mainText
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(dismissAndSave), for: .touchUpInside)
        let font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        let titleEnabled = NSAttributedString(string: "Готово", attributes: [.font: font, .foregroundColor: UIColor.systemBlue])
        let titleDisabled = NSAttributedString(string: "Готово", attributes: [.font: font, .foregroundColor: UIColor.systemBlue.withAlphaComponent(0.4)])
        
        button.setAttributedTitle(titleEnabled, for: .normal)
        button.setAttributedTitle(titleDisabled, for: .disabled)
        
        return button
    }()
    
    private lazy var dateTimeFields: UIStackView = {
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showCalendar))
        dateView.addGestureRecognizer(tapRecognizer)
        
        let secondTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showTimePicker))
        timeView.addGestureRecognizer(secondTapRecognizer)
        
        let stack = UIStackView(arrangedSubviews: [dateView, timeView])
        
        stack.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: stack.topAnchor).isActive = true
        }
        
        dateView.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
        timeView.trailingAnchor.constraint(equalTo: stack.trailingAnchor).isActive = true
        dateView.widthAnchor.constraint(greaterThanOrEqualToConstant: 170).isActive = true
        
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var dateTimeOptions: DateTimeOptionsMenuView = {
        
        let today = UITapGestureRecognizer(target: self, action: #selector(chooseTodayDate))
        let yesterday = UITapGestureRecognizer(target: self, action: #selector(chooseYesterdayDate))
        let previousWeek = UITapGestureRecognizer(target: self, action: #selector(choosePreviousWeekDate))
        let live = UITapGestureRecognizer(target: self, action: #selector(chooseLive))
        
        let optionsMenu = DateTimeOptionsMenuView()
        optionsMenu.initializeMenu(todayTapRecognizer: today, yesterdayTapRecognizer: yesterday, previousWeekTapRecognizer: previousWeek, liveTapRecognizer: live)
        
        optionsMenu.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 48).isActive = true
        }
        
        optionsMenu.setUpOptionsMenu(with: timeChosen)
        return optionsMenu
    }()
    
    
    // - MARK: UI Actions
    
    @objc func chooseTodayDate() {
        dateChosen = Date.now
    }
    
    @objc func chooseYesterdayDate() {
        dateChosen = Date.yesterday
    }
    
    @objc func choosePreviousWeekDate() {
        dateChosen = Date.previousWeek
    }
    
    @objc func chooseLive() {
        dateChosen = nil
        timeChosen = nil
        
        receiverDelegate?.receiveDate(nil)
        self.dismiss(animated: true)
    }
    
    @objc func showCalendar() {
        let vc = CalendarViewController()
        vc.dateReceiver = self
        if let dateChosen = dateChosen {
            vc.previousDate = dateChosen
        }
        navigationController?.fadeTo(vc)
    }
    
    @objc func showTimePicker() {
        let vc = TimePickerViewController()
        vc.timeReceiver = self
        if let timeChosen = timeChosen {
            vc.previousTime = timeChosen
        }
        navigationController?.fadeTo(vc)
    }
    
    @objc func dismissAndSave() {
        if let dateChosen = dateChosen, let timeChosen = timeChosen {
            let calendar = Calendar(identifier: .gregorian)
            
            let hourComponent = calendar.component(.hour, from: timeChosen)
            let minuteComponent = calendar.component(.minute, from: timeChosen)
            
            let date = calendar.date(bySettingHour: hourComponent, minute: minuteComponent, second: 0, of: dateChosen)
            receiverDelegate?.receiveDate(date)
            self.dismiss(animated: true)
            
        }
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
    
}

// - MARK: DateTimePickerViewController implements delegate to receive data from previous screens


extension DateTimePickerViewController: DateTimeReceiverDelegate {
    func receiveTime(_ time: Date?) {
        self.timeChosen = time
    }
    
    func receiveDate(_ date: Date?) {
        self.dateChosen = date
    }
}

