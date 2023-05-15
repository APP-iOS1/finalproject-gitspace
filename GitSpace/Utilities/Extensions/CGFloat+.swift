//
//  CGFloat+.swift
//  GitSpace
//
//  Created by 원태영 on 2023/05/15.
//

import Foundation

extension CGFloat {
    var asInt: Int {
        switch self {
        case .infinity, .nan:
            return 0
        default:
            return Int(self)
        }
    }
}
