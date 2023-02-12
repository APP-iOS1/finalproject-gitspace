//
//  Knock.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/11.
//

import Foundation

struct Knock: Codable, Hashable {
	var id: String = UUID().uuidString
	var date: Date
	var knockMessage: String
	var knockStatus: String
	var knockCategory: String
	var declineMessage: String?
	var receivedUserName: String
	var sentUserName: String
	
	var dateDiff: Int {
		get {
			let diff = Date.now - date
			return diff.minute ?? 0
		}
	}
}
