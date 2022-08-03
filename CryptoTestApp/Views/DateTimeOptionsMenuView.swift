//
//  DateTimeOptionsMenuView.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 03.08.2022.
//

import Foundation
import UIKit

final class DateTimeOptionsMenuView: UIStackView {
    private let todaySetting = DateTimeSettingView()
    private let yesterdaySetting = DateTimeSettingView()
    private let previousWeekSetting = DateTimeSettingView()
    private let liveSetting = DateTimeSettingView()
    
    func initializeMenu(todayTapRecognizer: UITapGestureRecognizer, yesterdayTapRecognizer: UITapGestureRecognizer, previousWeekTapRecognizer: UITapGestureRecognizer, liveTapRecognizer: UITapGestureRecognizer ) {
        
        todaySetting.addGestureRecognizer(todayTapRecognizer)
        yesterdaySetting.addGestureRecognizer(yesterdayTapRecognizer)
        previousWeekSetting.addGestureRecognizer(previousWeekTapRecognizer)
        liveSetting.addGestureRecognizer(liveTapRecognizer)
        
        addArrangedSubview(todaySetting)
        addArrangedSubview(yesterdaySetting)
        addArrangedSubview(previousWeekSetting)
        addArrangedSubview(liveSetting)
        
                
        axis = .vertical
        spacing = 0
        distribution = .fillEqually
    }
    
    func setUpOptionsMenu(with time: Date?) {
        todaySetting.setUpTimeSetting(for: Date.now, for: time, with: UIImage(named: "todayImage"), title: "Сегодня", showWeekDay: true)
        yesterdaySetting.setUpTimeSetting(for: Date.yesterday, for: time, with: UIImage(named: "yesterdayImage"), title: "Вчера", showWeekDay: true)
        previousWeekSetting.setUpTimeSetting(for: Date.previousWeek, for: time, with: UIImage(named: "lastWeekImage"), title: "Предыдущая неделя", showWeekDay: true)
        liveSetting.setUpTimeSetting(for: Date.now, for: time, with: UIImage(named: "liveImage"), title: "Текущие дата и время", showWeekDay: false)
        
    }
}
