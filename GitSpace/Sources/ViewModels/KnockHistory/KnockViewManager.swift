//
//  KnockNetworkManager.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/11.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

final class KnockViewManager: ObservableObject {
	@Published var eachKnock: Knock?
	@Published var receivedKnockList: [Knock] = []
	@Published var sentKnockList: [Knock] = []
	
	private let currentUser = "Valselee"
	private let firebaseDatabase = Firestore.firestore().collection("Knock")
	
	public let trailingTransition = AnyTransition
		.asymmetric(
			insertion: .move(edge: .trailing),
			removal: .move(edge: .trailing)
		)
	
	public let leadingTransition = AnyTransition
		.asymmetric(
			insertion: .move(edge: .leading),
			removal: .move(edge: .leading)
		)
}

extension KnockViewManager {
	public func compareTwoKnockWithStatus(lhs: Knock, rhs: Knock) -> Bool {
		if lhs.knockStatus == Constant.KNOCK_WAITING, rhs.knockStatus == Constant.KNOCK_DECLINED { return true }
		else if lhs.knockStatus == Constant.KNOCK_WAITING, rhs.knockStatus == Constant.KNOCK_ACCEPTED { return true }
		else if lhs.knockStatus == Constant.KNOCK_ACCEPTED, rhs.knockStatus == Constant.KNOCK_DECLINED { return true }
		else if lhs.knockStatus == Constant.KNOCK_ACCEPTED, rhs.knockStatus == Constant.KNOCK_WAITING { return false }
		else if lhs.knockStatus == Constant.KNOCK_DECLINED, rhs.knockStatus == Constant.KNOCK_ACCEPTED { return false }
		else if lhs.knockStatus == Constant.KNOCK_DECLINED, rhs.knockStatus == Constant.KNOCK_WAITING { return false }
		
		return true
	}
	
	public func getKnockCountInKnockList(
		knockList: [Knock],
		equalsToKnockStatus: String,
		isSearching: Bool,
		searchText: String,
		userSelectedTab: String
	) -> Int {
		knockList
			.filter {
				filteringSearchText(
					knock: $0,
					equalsToKnockStatus: equalsToKnockStatus,
					isSearching: isSearching,
					searchText: searchText,
					userSelectedTab: userSelectedTab
				)
			}
			.count
	}
	
	private func filteringSearchText(
		knock: Knock,
		equalsToKnockStatus: String,
		isSearching: Bool,
		searchText: String,
		userSelectedTab: String
	) -> Bool {
		if isSearching, userSelectedTab == Constant.KNOCK_RECEIVED { // 검색중 + 내 수신함
																	 // 현재 내가 선택한 필터 옵션과 같아야 하고, 내 수신함에는 보낸 사람의 정보를 가져야 한다.
			return knock.knockStatus == equalsToKnockStatus && knock.sentUserName.contains(searchText, isCaseInsensitive: true)
		} else if isSearching, userSelectedTab == Constant.KNOCK_SENT { // 검색중 + 내 발신함
			return knock.knockStatus == equalsToKnockStatus && knock.receivedUserName.contains(searchText, isCaseInsensitive: true)
		} else if userSelectedTab == Constant.KNOCK_RECEIVED {
			return knock.knockStatus == equalsToKnockStatus
		} else if userSelectedTab == Constant.KNOCK_SENT {
			return knock.knockStatus == equalsToKnockStatus
		}
		return false
	}
}

// MARK: - Network CRUD
extension KnockViewManager {
	// MARK: - METHODS
	public func addSnapshotToKnock() async {
		firebaseDatabase
			.addSnapshotListener { snapshot, err in
				// snapshot이 비어있으면 에러 출력 후 리턴
				guard let eachSnap = snapshot else {
					print("No SnapShot-\(#file)-\(#function)")
					return
				}
				
				eachSnap.documentChanges.forEach { diff in
					switch diff.type {
					case .added:
						print("added")
						print(diff.document.documentID)
						Task {
							await self.requestKnockList()
						}
					case .modified:
						print("modified")
						print(diff.document.documentID)
					case .removed:
						print("removed")
					}
				}
			}
	}
	
	// MARK: - In Normal Situation(foreground)
	public func requestKnockList() async -> Void {
		do {
			let snapshot = try await firebaseDatabase.getDocuments()
			for docs in snapshot.documents {
				let eachKnock = try docs.data(as: Knock.self)
				await appendKnockElement(eachKnock: eachKnock)
			}
		} catch {
			print("Request Failed-\(#file)-\(#function): \(error.localizedDescription)")
		}
	}
	
	@MainActor
	private func appendKnockElement(eachKnock: Knock) -> Void {
		// block 했을 때 수신함에 쌓이지 않도록 확인하는 로직 필요
		receivedKnockList.removeAll()
		
		if eachKnock.receivedUserName == currentUser {
			receivedKnockList.append(eachKnock)
		} else {
			sentKnockList.append(eachKnock)
		}
	}
	
	// MARK: - In Push Notification(Background, foreground)
	public func requestKnockWithID(knockID: String) async -> Knock? {
		let document = firebaseDatabase.document("\(knockID)")
		
		do {
			let requestKnock = try await document.getDocument(as: Knock.self)
			return requestKnock
		} catch {
			print("Error-\(#file)-\(#function): \(error.localizedDescription)")
			return nil
		}
	}
	
	@MainActor
	private func assignknock(knock: Knock) {
		self.eachKnock = knock
	}
	
	// Create
	public func createKnock(knock: Knock) async -> Void {
		let document = firebaseDatabase.document("\(knock.id)")
		
		do {
			try await document.setData([
				"id": knock.id,
				"date": Timestamp(date: knock.date),
				"declineMessage": knock.declineMessage ?? "",
				"knockCategory": knock.knockCategory,
				"knockStatus": Constant.KNOCK_WAITING,
				"knockMessage": knock.knockMessage,
				"receivedUserName": knock.receivedUserName,
				"sentUserName": knock.sentUserName,
			])
		} catch {
			print("Error-\(#file)-\(#function): \(error.localizedDescription)")
		}
	}
}
