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
	
	private var listener: ListenerRegistration?
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
	public func addSnapshotToKnock(currentUser: UserInfo) async {
		// !!!: 리스너 중복 주의
		removeSnapshot()
		
		listener = firebaseDatabase
			.addSnapshotListener { snapshot, err in
				// snapshot이 비어있으면 에러 출력 후 리턴
				guard let eachSnap = snapshot else {
					print("No SnapShot-\(#file)-\(#function)")
					return
				}
				
				eachSnap.documentChanges.forEach { diff in
					switch diff.type {
					case .added:
						Task {
							print(#file, #function, "NEW KNOCK HAS BEEN ADDED: \(diff.document.documentID)")
							await self.requestKnockList(currentUser: currentUser)
						}
					case .modified:
						Task {
							print(#file, #function, "KNOCK HAS BEEN MODIFIED: \(diff.document.documentID)")
							await self.requestKnockList(currentUser: currentUser)
						}
					case .removed:
						Task {
							print(#file, #function, "KNOCK HAS BEEN MODIFIED: \(diff.document.documentID)")
							await self.requestKnockList(currentUser: currentUser)
						}
					}
				}
			}
	}
	
	private func removeSnapshot() {
		if let listener {
			listener.remove()
		}
	}
	
	// MARK: - In Normal Situation(foreground)
	/// 한번에 리턴시켜야 뚜두둑 로딩되지 않음.
	public func requestKnockList(currentUser: UserInfo) async -> Void {
		receivedKnockList.removeAll()
		sentKnockList.removeAll()
		
		do {
			let snapshot = try await firebaseDatabase.getDocuments()
			
			for docs in snapshot.documents {
				let eachKnock = try docs.data(as: Knock.self)
				print("+++KNOCK MESSAGE+++", eachKnock.knockMessage)
				await appendKnockElement(
					eachKnock: eachKnock,
					currentUser: currentUser
				)
			}
		} catch {
			print("Request Failed-\(#file)-\(#function): \(error.localizedDescription)")
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
	
	// Create
	public func createKnock(knock: Knock) async -> Void {
		let document = firebaseDatabase.document("\(knock.id)")
		
		do {
			try await document.setData([
				"id": knock.id,
				"knockedDate": knock.knockedDate,
				"declineMessage": knock.declineMessage ?? "",
				"knockCategory": knock.knockCategory,
				"knockStatus": Constant.KNOCK_WAITING,
				"knockMessage": knock.knockMessage,
				"receivedUserName": knock.receivedUserName,
				"sentUserName": knock.sentUserName,
				"sentUserID": knock.sentUserID,
				"receivedUserID": knock.receivedUserID
			])
		} catch {
			print("Error-\(#file)-\(#function): \(error.localizedDescription)")
		}
	}
}

/// ASSIGN LOGICS
extension KnockViewManager {
	@MainActor
	private func appendKnockElement(
		eachKnock: Knock,
		currentUser: UserInfo
	) -> Void {
		// block 했을 때 수신함에 쌓이지 않도록 확인하는 로직 필요
		// TODO: 메소드 내부에 로컬 리스트 만들고 리턴시켜.
		
		if eachKnock.receivedUserName == currentUser.githubLogin {
			receivedKnockList.append(eachKnock)
			print("+++ KNOCKLIST +++", receivedKnockList)
		} else if eachKnock.receivedUserName != currentUser.githubLogin {
			sentKnockList.append(eachKnock)
			print("+++ KNOCKLIST +++", sentKnockList)
		}
	}
	
	@MainActor
	private func assignknock(knock: Knock) {
		self.eachKnock = knock
	}
}
