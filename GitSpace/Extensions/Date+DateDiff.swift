//
//  Date+DateDiff.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/31.
//

import Foundation

extension Date {
	static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
		let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
		let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
		let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
		let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
		let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second
		
		return (month: month, day: day, hour: hour, minute: minute, second: second)
	}
}

extension Date {
	public func formattedDateString() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
		return dateFormatter.string(from: self)
	}
}
