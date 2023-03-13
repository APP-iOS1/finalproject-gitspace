//
//  Knock.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/11.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Knock: Codable, Hashable, Identifiable {
	var id: String = UUID().uuidString
	var knockedDate: Timestamp
	var knockMessage: String
	var knockStatus: String
	var knockCategory: String
	var declineMessage: String? = nil
	var receivedUserName: String
	var sentUserName: String
	var receivedUserID: String
	var sentUserID: String
    
    var acceptedDate: Timestamp? = nil
    var declinedDate: Timestamp? = nil
	
	var dateDiff: String {
		get {
			let diff = knockedDate.dateValue()
			return diff.timeAgoDisplay()
		}
	}
	
	/// 기본 생성자
	init(
		date: Date,
		knockMessage: String,
		knockStatus: String,
		knockCategory: String,
		declineMessage: String? = nil,
		receivedUserName: String,
		sentUserName: String,
		receivedUserID: String,
		sentUserID: String
	) {
		self.knockedDate = Timestamp(date: date)
		self.knockMessage = knockMessage
		self.knockStatus = knockStatus
		self.knockCategory = knockCategory
		self.declineMessage = declineMessage
		self.receivedUserName = receivedUserName
		self.sentUserName = sentUserName
		self.receivedUserID = receivedUserID
		self.sentUserID = sentUserID
	}
	
	/// 옵셔널의 기본값으로 전달할 인스턴스를 생성하는 생성자
	init(isFailedDummy: Bool) {
		self.init(
			date: .now,
			knockMessage: "FAILED",
			knockStatus: "FAILED",
			knockCategory: "FAILED",
			receivedUserName: "FAILED",
			sentUserName: "FAILED",
			receivedUserID: "",
			sentUserID: ""
		)
	}
}
