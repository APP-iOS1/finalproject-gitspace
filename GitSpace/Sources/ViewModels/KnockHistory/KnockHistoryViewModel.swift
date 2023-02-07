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
			receivedKnockLists.append(
				Knock(
					date: Date.now - Double.random(in: 10...1500),
					knockMessage: "Message +\(index)",
					knockStatus: cases.randomElement()!.rawValue,
					knockCategory: "Offer",
					declineMessage: "거절사유",
					receiverID: "RandomBrazilGuy",
					senderID: "sentBot\(index)")
			)
			
			sentKnockLists.append(
				Knock(
					date: Date.now - Double.random(in: 10...1500),
					knockMessage: "Message +\(index)",
					knockStatus: cases.randomElement()!.rawValue,
					knockCategory: "Offer",
					declineMessage: "거절사유",
					receiverID: "receivedBot\(index)",
					senderID: "RandomBrazilGuy")
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
	
	public func filterKnockListWithCondition(
		eachKnock: Knock,
		eachFilterOption: String? = nil,
		userFilteredKnockState: KnockStateFilter,
		searchWith: String? = nil,
		knockType: String? = nil
	) -> Bool {
		if let searchWith,
		   let knockType,
		   let eachFilterOption {
			// 검색 && 유저가 필터를 설정
			return eachKnock.knockStatus == eachFilterOption
			&& filterKnockWithUserSearchText(
				eachKnock: eachKnock,
				userSearchText: searchWith,
				knockType: knockType
			)
		} else if let searchWith,
				  let knockType {
			// 검색 && 유저가 필터를 설정하지 않음
			return eachKnock.knockStatus == userFilteredKnockState.rawValue
			&& filterKnockWithUserSearchText(
				eachKnock: eachKnock,
				userSearchText: searchWith,
				knockType: knockType
			)
		} else if let eachFilterOption {
			// 검색하지 않는 상황 && 유저가 필터를 설정
			return eachKnock.knockStatus == eachFilterOption
		} else {
			// 검색하지 않는 상황 && 유저가 필터를 설정하지 않음
			return eachKnock.knockStatus == userFilteredKnockState.rawValue
		}
	}
	
	public func filterKnockWithStatus(
		filterState: String? = nil,
		userFilteredState: String,
		eachKnock: Knock
	) -> Bool {
		if let filterState {
			return eachKnock.knockStatus == filterState
		} else {
			return eachKnock.knockStatus == userFilteredState
		}
	}
	
	public func filterKnockWithUserSearchText(
		eachKnock: Knock,
		userSearchText: String,
		knockType: String
	) -> Bool {
		switch knockType {
		case Constant.KNOCK_RECEIVED:
			return eachKnock.senderID.contains(userSearchText)
		case Constant.KNOCK_SENT:
			return eachKnock.receiverID.contains(userSearchText)
		default:
			return false
		}
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
