//
//  Date+.swift
//  News
//
//  Created by Daniel Nunez on 28-02-21.
//

import Foundation

extension Date {
    static func - (recent: Date, previous: Date) -> (day: Int?, hour: Int?, minute: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute

        return (day: day, hour: hour, minute: minute)
    }

    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC)
        else { return Date() }

        return localDate
    }
}
