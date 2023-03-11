//
//  UserViewModel.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import Foundation
import FirebaseFirestore

final class UserStore: ObservableObject {
    
    enum BlockCase {
        case block
        case unblock
    }
    
	@Published var currentUser: UserInfo?
    @Published var user: UserInfo?
    @Published var users: [UserInfo]
    private let db = Firestore.firestore()
    
    init(
		users: [UserInfo] = [],
		currentUserID: String
	) {
        self.users = users
		Task {
			let currentUser = await self.requestUserInfoWithID(userID: currentUserID)
			if let currentUser {
				await assignCurrentUser(with: currentUser)
			}
		}
    }
    
    private func getUserDocument(userID: String) async -> DocumentSnapshot? {
        do {
            let snapshot = try await db.collection("UserInfo").document(userID).getDocument()
            return snapshot
        } catch {
            print("Error-\(#file)-\(#function) : \(error.localizedDescription)")
            return nil
        }
    }
    
    func requestUser(userID: String) async {
        let document = await getUserDocument(userID: userID)
        
        if let document {
            do {
                let user: UserInfo = try document.data(as: UserInfo.self)
                await writeUser(user: user)
            } catch {
                print("Error-\(#file)-\(#function) : \(error.localizedDescription)")
            }
		} else {
			return
		}
    }
    
    static func requestAndReturnUser(userID: String) async -> UserInfo? {
        let doc = Firestore.firestore().collection("UserInfo").document(userID)
        do {
            let userInfo = try await doc.getDocument(as: UserInfo.self)
            return userInfo
        } catch {
            print("Error-\(#file)-\(#function) : \(error.localizedDescription)")
            return nil
        }
    }
	
	// MARK: - PUSHED VIEW를 그릴 때 상대방의 정보를 가져오는 메소드
	/// USERINFO를 가져오기 위해 호출하는 메소드 입니다.
	/// userID로 가져온 userInfo를 리턴합니다.
	public func requestUserInfoWithID(userID: String) async -> UserInfo? {
		let doc = db.collection("UserInfo").document(userID)
		
		do {
			print(userID)
			let userInfo = try await doc.getDocument(as: UserInfo.self)
			return userInfo
		} catch {
			dump("\(#file), \(#function) - DEBUG \(error.localizedDescription)")
			return nil
		}
	}
	
	/**
	 GITHUB ID로 유저 정보를 가져 옵니다.
	 정수형 타입으로 저장되는 gitHubID로 GitSpace FirebaseDB에서 유저 정보를 파싱하여 가져옵니다.
	 
	 - returns: UserInfo or nil
	 nil 리턴의 경우, 우리 앱에 해당 유저가 없음을 UX 전달해야 합니다.
	 */
	public func requestUserInfoWithGitHubID(githubID: Int) async -> UserInfo? {
		let collection = db.collection("UserInfo")
		
		do {
			// GITHUB ID 필드에 저장된 것과 같은 유저 정보를 가져 오도록 쿼링
			let query = collection.whereField("githubID", isEqualTo: githubID)
			let data = try await query.getDocuments().documents
			var userInformationList: [UserInfo] = []
			
			for doc in data {
				let userInfo = try doc.data(as: UserInfo.self)
				userInformationList.append(userInfo)
			}
			return userInformationList.first
		} catch {
			dump("\(#function) - DEBUG \(error.localizedDescription)")
			return nil
		}
	}
	
	/**
	 User deviceToken을 서버에 업데이트 합니다.
	 */
	public func updateUserDeviceToken(userID: String, deviceToken: String) async {
		do {
			let document = db.collection("UserInfo").document(userID)
			try await document.updateData([
				"deviceToken": deviceToken
			])
		} catch {
			print("Error-\(#file)-\(#function): USERINFO DEVICETOKEN Update Falied")
		}
	
	}
    
    private func getUserDocuments() async -> QuerySnapshot? {
        do {
            let snapshot = try await db.collection("UserInfo").getDocuments()
            return snapshot
        } catch {
            print("Get User Document Error : \(error)")
        }
        return nil
    }
    
    @MainActor
    private func writeUsers(users: [UserInfo]) {
        self.users = users
    }
	
	@MainActor
	private func assignCurrentUser(with userInfo: UserInfo) {
		self.currentUser = userInfo
	}
    
    
    func requestUsers() async {
        
        let snapshot = await getUserDocuments()
        var users: [UserInfo] = []
        
        if let snapshot {
            for document in snapshot.documents {
                do {
                    let user: UserInfo = try document.data(as: UserInfo.self)
                    users.append(user)
                } catch {
                    print("Request Users Error : \(error.localizedDescription)")
                }
            }
        }
        await writeUsers(users: users)
    }
    
    private func getTargetUserIDIndex(targetUserID: String) -> Int? {
        guard let user else {
            return nil
        }
        return user.blockedUserIDs.firstIndex(of: targetUserID)
    }
    
    @MainActor
    private func writeUser(user: UserInfo) {
        self.user = user
    }
    
    func updateIsTartgetUserBlocked(blockCase: BlockCase, targetUserID: String) async {
        guard var user else {
            print("로그인 유저 정보가 nil입니다.")
            return
        }
        var newBlockedUserIDs = user.blockedUserIDs
        let index = getTargetUserIDIndex(targetUserID: targetUserID)
        
        switch blockCase {
        
        case .block:
            guard index == nil else {
                print("block 대상 ID가 이미 리스트에 존재합니다.")
                return
            }
            newBlockedUserIDs.append(targetUserID)
        
        case .unblock:
            guard let index else {
                print("unblock 대상 ID가 리스트에 존재하지 않습니다.")
                return
            }
            newBlockedUserIDs.remove(at: index)
        }
        
        do {
            user.blockedUserIDs = newBlockedUserIDs
            try await db
                .collection("UserInfo")
                .document(user.id)
                .updateData(["blockedUserIDs" : newBlockedUserIDs])
        } catch {
            print("Block/Unblock User Update Error : \(error.localizedDescription)")
        }
        
    }
    
}
