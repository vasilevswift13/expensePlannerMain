//
//  Date+Extensions.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 28.04.2026.
//

import Foundation

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    func isSameDay(as otherDate: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: otherDate)
    }

    func isSameWeek(as otherDate: Date) -> Bool {
        Calendar.current.isDate(self, equalTo: otherDate, toGranularity: .weekOfYear)
    }

    func isSameMonth(as otherDate: Date) -> Bool {
        Calendar.current.isDate(self, equalTo: otherDate, toGranularity: .month)
    }

    var shortWeekday: String {
        formatted(.dateTime.weekday(.abbreviated))
    }

    var dayNumber: String {
        formatted(.dateTime.day())
    }

    var monthTitle: String {
        formatted(.dateTime.month(.wide).year())
    }

    var fullDateTitle: String {
        formatted(.dateTime.weekday(.wide).day().month(.wide))
    }

    var monthAndYear: String {
        formatted(.dateTime.month(.wide).year())
    }
}
