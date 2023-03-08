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
	@Published var receivedKnockList: [Knock] = []
	@Published var sentKnockList: [Knock] = []
    public var newKnock: Knock? = nil
    
    private var tempReceived: [Knock] = []
    private var tempSent: [Knock] = []
	
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
    
    public func sortedByDateValue(lhs: Knock, rhs: Knock) -> Bool {
        lhs.knockedDate.dateValue() > rhs.knockedDate.dateValue()
    }
}

// MARK: - Network CRUD
extension KnockViewManager {
	public func addSnapshotToKnock(currentUser: UserInfo) async {
		// !!!: 리스너 중복 주의
		removeSnapshot()
        await removeKnockList()
        // TODO: 로딩중인 걸 보여주기 위한 로딩 전, 진행중, 완료 등의 상태를 담은 열거형 정의 후, 프로그레스뷰 이식하기
        
		listener = firebaseDatabase
			.addSnapshotListener { snapshot, err in
				guard let snapshot else {
					print("No SnapShot-\(#file)-\(#function)")
					return
				}
                
                snapshot.documentChanges.forEach { docDiff in
                    switch docDiff.type {
                    case .added:
                        print(#file, #function, "Added New Knock")
                        if let newKnock = self.decodeKnockElementForListener(with: docDiff, currentUser: currentUser) {
                            self.appendKnockElement(newKnock: newKnock, currentUser: currentUser)
                        }
                    case .modified:
                        print(#file, #function, "Knock Has Been Modified")
                        if let newKnock = self.decodeKnockElementForListener(with: docDiff, currentUser: currentUser) {
                            self.appendKnockElement(newKnock: newKnock, currentUser: currentUser)
                        }
                    case .removed:
                        print(#file, #function, "Knock Has Been Removed")
                    }
                }
                
                /**
                 Temp 배열을 모델 배열로 할당
                 */
                self.assignKnockList()
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
		await removeKnockList()
		
		do {
			let snapshot = try await firebaseDatabase.getDocuments()
			
			for docs in snapshot.documents {
				let eachKnock = try docs.data(as: Knock.self)
				print("+++KNOCK MESSAGE+++", eachKnock.knockMessage)
				appendKnockElement(
					newKnock: eachKnock,
					currentUser: currentUser
				)
			}
            
            await assignKnockListConcurrently()
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
	
	/**
     1. 만들어진 노크를 DB에 등록합니다.
     */
	public func createKnockOnFirestore(knock: Knock) async -> Void {
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

// MARK: - ASSIGN LOGICS
extension KnockViewManager {
    /**
     리스너에서 받아온 노크 doc을 디코드 합니다.
     리스너 클로저 내부에서 활용하는 이유로 동시성 키워드는 제외합니다.
     */
    private func decodeKnockElementForListener(
        with docDiff: DocumentChange,
        currentUser: UserInfo
    ) -> Knock? {
        do {
            let newKnock = try docDiff.document.data(as: Knock.self)
            return newKnock
        } catch {
            print(#file, #function, error.localizedDescription)
            return nil
        }
    }
    
    /**
     아규먼트의 노크가 갖는 수신자 아이디와 현재 유저의 아이디를 비교하여 임시 배열에 어펜드 합니다.
     뷰가 한 번에 그려질 수 있도록 조치하기 위해 임시 배열과 모델 배열을 분리합니다.
     */
    private func appendKnockElement(newKnock: Knock, currentUser: UserInfo) {
        if newKnock.receivedUserName == currentUser.githubLogin {
            self.tempReceived.append(newKnock)
        } else {
            self.tempSent.append(newKnock)
        }
    }
    
    private func assignKnockList() {
        sentKnockList = tempSent
        receivedKnockList = tempReceived
        print(#function, "ASSIGN DONE +++: ", sentKnockList, receivedKnockList)
    }
    
    @MainActor
    private func assignKnockListConcurrently() {
        sentKnockList = tempSent
        receivedKnockList = tempReceived
        print(#function, "ASSIGN DONE +++: ", sentKnockList, receivedKnockList)
    }
	
    @MainActor
    private func removeKnockList() {
        receivedKnockList.removeAll()
        sentKnockList.removeAll()
    }
    
    @MainActor
    public func assignNewKnock(newKnock: Knock) {
        self.newKnock = newKnock
    }
}
