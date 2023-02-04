//
//  KnockHistoryViewModel.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/31.
//

import SwiftUI

final class KnockHistoryViewModel: ObservableObject {
	@Published var sentKnockLists: [Knock] = []
	@Published var receivedKnockLists: [Knock] = []
	
	@Published var usersKnockHistoryStatus: [String] = []
	@Published var knockMessages: [String] = []
	
	// Dummy Init
	init() {
		let cases = KnockStatus.allCases.shuffled()
		for index in 0..<(cases.count + Int.random(in: 10..<15)) {
			usersKnockHistoryStatus.append(cases.randomElement()!.rawValue)
			sentKnockLists.append(
				Knock(
					date: Date.now - Double.random(in: 10...1500),
					knockMessage: "Message +\(index)",
					knockStatus: cases.randomElement()!.rawValue,
					knockCategory: "Offer",
					declineMessage: "거절사유",
					receiverID: "받는사람 \(index)",
					senderID: "RandomBrazilGuy")
			)
			
			receivedKnockLists.append(
				Knock(
					date: Date.now - Double.random(in: 10...1500),
					knockMessage: "Message +\(index)",
					knockStatus: cases.randomElement()!.rawValue,
					knockCategory: "Offer",
					declineMessage: "거절사유",
					receiverID: "RandomBrazilGuy",
					senderID: "보낸사람 \(index)")
			)
			
		}
	}
	
	enum KnockStatus: String, CaseIterable {
		case waiting = "Waiting"
		case accepted = "Accepted"
		case declined = "Declined"
	}
	
	public func compareTwoKnockWithStatus(lhs: Knock, rhs: Knock) -> Bool {
		if lhs.knockStatus == "Waiting", rhs.knockStatus == "Declined" { return true }
		else if lhs.knockStatus == "Waiting", rhs.knockStatus == "Accepted" { return true }
		else if lhs.knockStatus == "Accepted", rhs.knockStatus == "Declined" { return true }
		else if lhs.knockStatus == "Accepted", rhs.knockStatus == "Waiting" { return false }
		else if lhs.knockStatus == "Declined", rhs.knockStatus == "Accepted" { return false }
		else if lhs.knockStatus == "Declined", rhs.knockStatus == "Waiting" { return false }
		
		return true
	}
}

struct Knock: Codable, Hashable {
	var id: String = UUID().uuidString
	var date: Date
	var knockMessage: String
	var knockStatus: String
	var knockCategory: String
	var declineMessage: String?
	var receiverID: String
	var senderID: String
	
	var dateDiff: Int {
		get {
			let diff = Date.now - date
			return diff.minute ?? 0
		}
	}
}
