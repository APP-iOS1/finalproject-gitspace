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
	
	init(date: Date, knockMessage: String, knockStatus: String, knockCategory: String, declineMessage: String? = nil, receivedUserName: String, sentUserName: String) {
		self.date = date
		self.knockMessage = knockMessage
		self.knockStatus = knockStatus
		self.knockCategory = knockCategory
		self.declineMessage = declineMessage
		self.receivedUserName = receivedUserName
		self.sentUserName = sentUserName
	}
	
	init(isFailedDummy: Bool) {
		self.init(date: .now, knockMessage: "FAILED", knockStatus: "FAILED", knockCategory: "FAILED", receivedUserName: "FAILED", sentUserName: "FAILED")
	}
}
