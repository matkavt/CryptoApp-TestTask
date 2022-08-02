//
//  DateTimePickerViewController.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 31.07.2022.
//

import Foundation
import UIKit

final class DateTimePickerViewController: UIViewController {
    private var dateChosen: Date? {
        didSet {
            if let dateChosen = dateChosen {
                dateView.setText(text: Date.dateToLocalizedString(for: .ru, date: dateChosen), color: .black, fontSize: 16, fontWeight: .regular)
            } else {
                dateView.setText(text: "Выберите дату", color: UIColor(red: 124/255, green: 137/255, blue: 163/255, alpha: 1), fontSize: 16, fontWeight: .regular)
            }
            
            updateDoneButton()
        }
    }
    
    private var timeChosen: Date? {
        didSet {
            let format = DateFormatter()
            format.dateFormat = "HH:mm"
            timeView.setText(text: format.string(from: timeChosen!), color: .black, fontSize: 16, fontWeight: .regular)
            
            updateDoneButton()
        }
    }
    
    private var dateView = RoundedLabelView()
    private var timeView = RoundedLabelView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true

        view.addSubview(cancelButton)
        view.addSubview(sheetTitle)
        view.addSubview(doneButton)
        view.addSubview(dateTimeFields)
        view.addSubview(dateTimeOptions)
        
        doneButton.isEnabled = false
        
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
            
            dateTimeFields.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 25),
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
    
    private func updateDoneButton() {
        if let _ = dateChosen, let _ = timeChosen {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
    }
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        let font = UIFont.systemFont(ofSize: 17, weight: .regular)
        let textColor = UIColor(red: 0, green: 80/255, blue: 207/255, alpha: 1)
        let title = NSAttributedString(string: "Отменить", attributes: [.font: font, .foregroundColor: textColor])
      
        button.setAttributedTitle(title, for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var sheetTitle: UILabel = {
        let label = UILabel()
        label.text = "Дата и время"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        let font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        let textColorEnabled = UIColor(red: 0, green: 80/255, blue: 207/255, alpha: 1)
        let textColorDisabled = UIColor(red: 0, green: 80/255, blue: 207/255, alpha: 0.4)

        let titleEnabled = NSAttributedString(string: "Готово", attributes: [.font: font, .foregroundColor: textColorEnabled])
        let titleDisabled = NSAttributedString(string: "Готово", attributes: [.font: font, .foregroundColor: textColorDisabled])
      
        button.setAttributedTitle(titleEnabled, for: .normal)
        button.setAttributedTitle(titleDisabled, for: .disabled)
        
        return button
    }()
    
    private lazy var dateTimeFields: UIStackView = {
        let textColor = UIColor(red: 124/255, green: 137/255, blue: 163/255, alpha: 1)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showCalendar))
        dateView.addGestureRecognizer(tapRecognizer)
        
        let secondTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showTimePicker))
        timeView.addGestureRecognizer(secondTapRecognizer)
        
        dateView.setText(text: "Выберите дату", color: textColor, fontSize: 16, fontWeight: .regular)
        timeView.setText(text: "Выберите время", color: textColor, fontSize: 16, fontWeight: .regular)
        
        let stack = UIStackView(arrangedSubviews: [dateView, timeView])
        
        stack.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(greaterThanOrEqualToConstant: 72).isActive = true
            $0.topAnchor.constraint(equalTo: stack.topAnchor).isActive = true
        }
        
        dateView.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
        timeView.trailingAnchor.constraint(equalTo: stack.trailingAnchor).isActive = true
        
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var dateTimeOptions: UIStackView = {
        let todaySetting = DateTimeSettingView()
        todaySetting.setUpTimeSetting(for: Date.now, with: UIImage(named: "todayImage"), title: "Сегодня", showWeekDay: true)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseTodayDate))
        todaySetting.addGestureRecognizer(tapRecognizer)
        
        let yesterdaySetting = DateTimeSettingView()
        yesterdaySetting.setUpTimeSetting(for: Date.yesterday, with: UIImage(named: "yesterdayImage"), title: "Вчера", showWeekDay: true)
        
        let secondTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseYesterdayDate))
        yesterdaySetting.addGestureRecognizer(secondTapRecognizer)
        
        
        let previousWeekSetting = DateTimeSettingView()
        previousWeekSetting.setUpTimeSetting(for: Date.previousWeek, with: UIImage(named: "lastWeekImage"), title: "Предыдущая неделя", showWeekDay: true)
        
        let thirdTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePreviousWeekDate))
        previousWeekSetting.addGestureRecognizer(thirdTapRecognizer)
        
        let liveSetting = DateTimeSettingView()
        liveSetting.setUpTimeSetting(for: Date.now, with: UIImage(named: "liveImage"), title: "Текущие дата и время", showWeekDay: false)
        
        let fourthTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseLive))
        liveSetting.addGestureRecognizer(fourthTapRecognizer)
        
        
        let stack = UIStackView(arrangedSubviews: [todaySetting, yesterdaySetting, previousWeekSetting, liveSetting])
        
        stack.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 48).isActive = true
        }
        
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .fillEqually
        return stack
    }()
    
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
    }
    
    @objc func showCalendar() {
        navigationController?.fadeTo(CalendarViewController())
    }
    
    @objc func showTimePicker() {
        navigationController?.fadeTo(TimePickerViewController())
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
                                                   
}

extension Date {
    
    enum Localization {
        case ru
    }
    
    
    static func dateToLocalizedString(for locale: Localization, date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let month = calendar.component(Calendar.Component.month, from: date)
        let weekday = calendar.component(Calendar.Component.weekday, from: date)
        let day = calendar.component(Calendar.Component.day, from: date)
        let year = calendar.component(Calendar.Component.year, from: date)
        
        switch(locale) {
        case .ru:
            let monthNames = [
                "янв",
                "фев",
                "мар",
                "апр",
                "мая",
                "июня",
                "июля",
                "авг",
                "сен",
                "окт",
                "ноя",
                "дек"
            ]
            
            return "\(day) \(monthNames[month-1]). \(year) г., \(Date.getWeekdayLocalizedRussian(by: weekday)!)"
        }
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    static var previousWeek: Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    }
    
}
