//
//  DateExtensions.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 02.08.2022.
//

import Foundation

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

extension Date {
    static func getWeekdayLocalizedRussian(by index: Int) -> String? {
        // Вообще имхо имело бы смысл с 0 начинать и до 6 - тут же index
        
        guard index < 8 else { return nil }
        guard index > 0 else { return nil } // одна проверка есть, почему бы не написать вторую
        
        let names = [
            "Вс",
            "Пн",
            "Вт",
            "Ср",
            "Чт",
            "Пт",
            "Сб",
        ]
        
        return names[index-1] // Вроде как это можно сделать умнее и для разных локализаций. Но для тз конечно хорошо и так
    }
}



extension Date {
    
    enum Localization {
        case ru
    }//Если заморачиваться с этим, то имхо имело бы смысл системную локализацию использовать. Такой подход плохо масштабируется
    
    static func dateToLocalizedString(for locale: Localization, date: Date, withHours: Bool) -> String {
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
            
            let format = DateFormatter()
            format.dateFormat = "HH:mm"
            
            return "\(day) \(monthNames[month-1]). \(year) г., \(Date.getWeekdayLocalizedRussian(by: weekday)!)\(withHours ? ", \(format.string(from: date))" : "")"
        }
        
        // + замечания, аналогичные к функции getWeekdayLocalizedRussian
    }
}




