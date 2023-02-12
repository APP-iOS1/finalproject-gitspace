//
//  Array+String.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/12.
//

import Foundation

extension Array where Element == String {
	/// 배열 원소가 문자열일 때, 영어의 소대문자 구분 없이 문자열을 포함하는지를 확인 후 Bool 을 리턴하는 메소드.
	public func caseInsensitiveContains(_ element: Element) -> Bool {
		contains { $0.caseInsensitiveCompare(element) == .orderedSame }
	}
}
