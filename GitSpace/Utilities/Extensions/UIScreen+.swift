//
//  UIScreen+.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/14.
//

import UIKit

extension UIScreen {
  /// - Mini, SE: 375.0
  /// - pro: 390.0
  /// - pro max: 428.0
  var isWiderThan375pt: Bool { self.bounds.size.width > 375 }
}
