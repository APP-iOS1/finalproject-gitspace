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
    
    /**
     Listener가 있는지 체크하고 존재한다면 true, 없다면 false를 리턴합니다.
     */
    public func checkIfListenerExists() -> Bool {
        if listener != nil {
            return true
        } else {
            return false
        }
    }
}

// MARK: - Filter, Sort etc.
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
    
    /**
     검색 상태와 검색어, 유저의 메뉴 선택 옵션에 따라 노크리스트를 필터링하는 메소드입니다.
     list의 .filter 클로저에서 호출합니다.
     수신한 노크리스트일 경우, 발신자를 검색해야 하기 때문에 Bool 값으로 아규먼트를 전달하여 분기처리합니다.
     - returns: Bool
     */
    public func filterKnockList(
        isReceivedKnockList: Bool,
        isSearching: Bool,
        searchText: String,
        userFilteredKnockState: KnockStateFilter,
        eachKnock: Knock
    ) -> Bool {
        if isSearching { // 검색 필터링
            switch userFilteredKnockState {
            case .waiting:
                if isReceivedKnockList {
                    return eachKnock.sentUserName.contains(
                        searchText, isCaseInsensitive: true
                    ) && eachKnock.knockStatus == Constant.KNOCK_WAITING
                } else {
                    return eachKnock.receivedUserName.contains(
                        searchText, isCaseInsensitive: true
                    ) && eachKnock.knockStatus == Constant.KNOCK_WAITING
                }
            case .accepted:
                if isReceivedKnockList {
                    return eachKnock.sentUserName.contains(
                        searchText, isCaseInsensitive: true
                    ) && eachKnock.knockStatus == Constant.KNOCK_ACCEPTED
                } else {
                    return eachKnock.receivedUserName.contains(
                        searchText, isCaseInsensitive: true
                    ) && eachKnock.knockStatus == Constant.KNOCK_ACCEPTED
                }
            case .declined:
                if isReceivedKnockList {
                    return eachKnock.sentUserName.contains(
                        searchText, isCaseInsensitive: true
                    ) && eachKnock.knockStatus == Constant.KNOCK_DECLINED
                } else {
                    return eachKnock.receivedUserName.contains(
                        searchText, isCaseInsensitive: true
                    ) && eachKnock.knockStatus == Constant.KNOCK_DECLINED
                }
            case .all:
                if isReceivedKnockList {
                    return eachKnock.sentUserName.contains(
                        searchText, isCaseInsensitive: true
                    )
                } else {
                    return eachKnock.receivedUserName.contains(
                        searchText, isCaseInsensitive: true
                    )
                }
            }
        } else { // 비검색 필터링
            switch userFilteredKnockState {
            case .waiting:
                return eachKnock.knockStatus == Constant.KNOCK_WAITING
            case .accepted:
                return eachKnock.knockStatus == Constant.KNOCK_ACCEPTED
            case .declined:
                return eachKnock.knockStatus == Constant.KNOCK_DECLINED
            case .all:
                return true
            }
        }
    }
    
    /**
     필터링 된 특정 노크 리스트의 갯수를 반환하는 메소드입니다.
     MainKnockView에서 header를 그릴 때 활용합니다.
     */
    public func getFilteredKnockCountInKnockList(
        isReceivedKnockList: Bool,
        isSearching: Bool,
        searchText: String,
        userFilteredKnockState: KnockStateFilter
    ) -> Int {
        if isReceivedKnockList {
            return receivedKnockList
                .filter {
                    filterKnockList(
                        isReceivedKnockList: isReceivedKnockList,
                        isSearching: isSearching,
                        searchText: searchText,
                        userFilteredKnockState: userFilteredKnockState,
                        eachKnock: $0
                    )
                }
                .count
        } else {
            return sentKnockList
                .filter {
                    filterKnockList(
                        isReceivedKnockList: isReceivedKnockList,
                        isSearching: isSearching,
                        searchText: searchText,
                        userFilteredKnockState: userFilteredKnockState,
                        eachKnock: $0
                    )
                }
                .count
        }
        
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
        // TODO: 로딩중인 걸 보여주기 위한 로딩 전, 진행중, 완료 등의 상태를 담은 열거형 정의 후, 프로그레스뷰 이식하기
        
		listener = firebaseDatabase
            .addSnapshotListener(includeMetadataChanges: true) { [self] snapshot, err in
				guard let snapshot else {
					print("No SnapShot-\(#file)-\(#function)")
					return
				}
                
                snapshot.documentChanges.forEach { docDiff in
                    switch docDiff.type {
                    case .added:
                        if let newKnock = self.decodeKnockElementForListener(with: docDiff, currentUser: currentUser) {
                            self.appendKnockElementInTempList(newKnock: newKnock, currentUser: currentUser)
                        }
                    case .modified:
                        if let diffKnock = self.decodeKnockElementForListener(with: docDiff, currentUser: currentUser) {
                            self.updateTempKnockList(diffKnock: diffKnock, currentUser: currentUser)
                        }
                    case .removed:
                        if let removedKnock = self.decodeKnockElementForListener(with: docDiff, currentUser: currentUser) {
                            self.removeKnocksInTempKnockList(removedKnock: removedKnock, currentUser: currentUser)
                        }
                    }
                }
                
                /**
                 Temp 배열을 모델 배열로 할당
                 할당한 이후, 임시 배열 초기화
                 */
                self.assignTempKnockListToPublishedList()
			}
	}
	
	private func removeSnapshot() {
		if let listener {
			listener.remove()
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
    
    /**
     knockStatus를 업데이트하고, Status가 업데이트 된 시간도 함께 set 합니다.
     knockMessage는 수정되어도 수정 일자를 업데이트 하지 않습니다.
     */
    public func updateKnockOnFirestore(
        knock: Knock,
        knockStatus: String,
        isEdited: Bool? = false,
        newChatID: String? = nil,
        declineMessage: String? = nil
    ) async -> Void {
        let document = firebaseDatabase.document(knock.id)
        
        do {
            try await document.updateData([
                "knockStatus": knockStatus
            ])
            
            if
                let isEdited, isEdited {
                try await document.updateData([
                    "knockMessage": knock.knockMessage
                ])
            }
            
            switch knockStatus {
            case Constant.KNOCK_ACCEPTED:
                try await document.setData([
                    "acceptedDate": Timestamp(date: .now),
                    "chatID": newChatID ?? "CHAT ID IS NIL"
                ], merge: true)
                
            case Constant.KNOCK_DECLINED:
                try await document.setData([
                    "declinedDate": Timestamp(date: .now),
                    "declineMessage": declineMessage ?? "\(knock.receivedUserName) decided not to give you a decline message."
                ], merge: true)
                
            default:
                break
            }
        } catch {
            dump("\(#file)-\(#function), DEBUG: UPDATE Knock FAILED, \(error.localizedDescription)")
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
    private func appendKnockElementInTempList(newKnock: Knock, currentUser: UserInfo) {
        if newKnock.receivedUserID == currentUser.id {
            self.tempReceived.append(newKnock)
        } else if newKnock.sentUserID == currentUser.id {
            self.tempSent.append(newKnock)
        }
    }
    
    private func assignTempKnockListToPublishedList() {
        sentKnockList = tempSent
        receivedKnockList = tempReceived
    }
    
    private func updateTempKnockList(
        diffKnock: Knock,
        currentUser: UserInfo
    ) {
        if diffKnock.receivedUserID == currentUser.id {
            if let knockIndex = tempReceived.firstIndex(where: { knock in
                knock.id == diffKnock.id
            }) {
                tempReceived[knockIndex] = diffKnock
            }
        } else if diffKnock.sentUserID == currentUser.id  {
            if let knockIndex = tempSent.firstIndex(where: { knock in
                knock.id == diffKnock.id
            }) {
                tempSent[knockIndex] = diffKnock
            }
        }
    }
    
    @MainActor
    private func removeKnockList() {
        receivedKnockList.removeAll()
        sentKnockList.removeAll()
    }
    
    private func removeTempKnockList() {
        tempSent = []
        tempReceived = []
    }
    
    /**
    리스너에서 받아온 제거 노크의 id를 임시배열의 노크 요소 id와 비교하여 제거합니다.
     */
    private func removeKnocksInTempKnockList(
        removedKnock: Knock,
        currentUser: UserInfo
    ) {
        if removedKnock.receivedUserID == currentUser.id {
            tempReceived.removeAll { knock in
                knock.id == removedKnock.id
            }
        } else if removedKnock.sentUserID == currentUser.id {
            tempSent.removeAll { knock in
                knock.id == removedKnock.id
            }
        }
    }
    
    @MainActor
    public func assignNewKnock(newKnock: Knock) {
        self.newKnock = newKnock
    }
}

/** Knock Communication History Check Logic */
extension KnockViewManager {
    /**
     노크가 보내진 적이 있는지 체크하는 메소드입니다.
     나 혹은 상대에 의해 노크가 보내진 적이 있고 현재 승인되었다면 .accepted를 반환합니다.
     나 혹은 상대에 의해 노크가 보내진 적이 있고 현재 대기중이라면 .waiting을 반환합니다.
     나 혹은 상대에 의해 노크가 보내진 적이 있고 현재 거절되었다면 .declined를 반환합니다.
     노크가 보내진 적이 없다면 true를 반환합니다.
     */
    public func checkIfKnockHasBeenSent(
        currentUser: UserInfo,
        targetUser: UserInfo
    ) async -> KnockCommunicateResult<KnockStateFilter, Bool> {
        // 내가 발신자, 상대방이 수신자인 경우
        let knockQueryWhenCurrentUserSentKnock = firebaseDatabase
            .whereField("sentUserID", isEqualTo: currentUser.id)
            .whereField("receivedUserID", isEqualTo: targetUser.id)
        
        // 내가 수신자, 상대방이 발신자인 경우
        let knockQueryWhenCurrentUserReceivedKnock = firebaseDatabase
            .whereField("sentUserID", isEqualTo: targetUser.id)
            .whereField("receivedUserID", isEqualTo: currentUser.id)
        
        do {
            let snapshot = try await knockQueryWhenCurrentUserSentKnock.getDocuments()
            for doc in snapshot.documents {
                let knock = try doc.data(as: Knock.self)
                switch knock.knockStatus {
                case Constant.KNOCK_WAITING:
                    return .knockHasBeenSent(
                        knockStatus: .waiting,
                        withKnock: knock
                    )
                case Constant.KNOCK_ACCEPTED:
                    return .knockHasBeenSent(
                        knockStatus: .accepted,
                        withKnock: knock,
                        toChatID: knock.chatID ?? "CHAT ID IS NIL" // chat 뷰를 그리기 위한 id 등 전달 필요
                    )
                case Constant.KNOCK_DECLINED:
                    return .knockHasBeenSent(
                        knockStatus: .declined,
                        withKnock: knock
                    )
                default:
                    break
                }
            }
            
            let snapshot2 = try await knockQueryWhenCurrentUserReceivedKnock.getDocuments()
            for doc in snapshot2.documents {
                let knock = try doc.data(as: Knock.self)
                switch knock.knockStatus {
                case Constant.KNOCK_WAITING:
                    return .knockHasBeenSent(
                        knockStatus: .waiting,
                        withKnock: knock
                    )
                case Constant.KNOCK_ACCEPTED:
                    return .knockHasBeenSent(
                        knockStatus: .accepted,
                        withKnock: knock,
                        toChatID: knock.chatID ?? "CHAT ID IS NIL" // chat 뷰를 그리기 위한 id 등 전달 필요
                    )
                case Constant.KNOCK_DECLINED:
                    return .knockHasBeenSent(
                        knockStatus: .declined,
                        withKnock: knock
                    )
                default:
                    break
                }
            }
            
            return .ableToSentNewKnock(KnockFlag: true)
        } catch {
            print(#file, #function, error.localizedDescription)
        }
        
        return .ableToSentNewKnock(KnockFlag: false)
    }
    
    /**
     결과 타입을 커스터마이징하여 노크가 보내졌는지 여부를 판단하고,
     knockFlag 연관값을 리턴 및 전달하여 새로운 노크를 보낼 수 있는지 체크합니다.
     
     - Author:  ValseLee(Celan)
     */
    enum KnockCommunicateResult<KnockState, KnockFlag> {
        case knockHasBeenSent(
            knockStatus: KnockStateFilter,
            withKnock: Knock? = nil,
            toChatID: String? = nil
        )
        case ableToSentNewKnock(KnockFlag: Bool)
    }
}


