//
//  Date+.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/16.
//

import Foundation

extension Date {
    private static var formatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()

    func timeAgoDisplay() -> String {
        Self.formatter.localizedString(for: self, relativeTo: Date())
    }
}
