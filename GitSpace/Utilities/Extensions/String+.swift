//
//  Array+String.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/12.
//

import Foundation

extension String {
	/// 영어의 소대문자 구분 없이 문자열을 포함하는지를 확인 후 Bool 을 리턴하는 메소드.
	public func contains(
		_ string: String,
		isCaseInsensitive caseInsensitive: Bool
	) -> Bool {
		caseInsensitive
		? range(of: string, options: .caseInsensitive) != nil
		: contains(string)
	}
    
    public func stringToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: self) else { return Date() }
        return date
    }
    
    public func isValidPattern(pattern: String) -> Bool {
        return self.range(of: pattern, options: .regularExpression) != nil
    }
}
