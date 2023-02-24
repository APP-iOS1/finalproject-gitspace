//
//  UserViewModel.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import Foundation
import FirebaseFirestore

class UserStore : ObservableObject {
    
    enum BlockCase {
        case block
        case unblock
    }
    
    @Published var user: UserInfo?
    @Published var users: [UserInfo]
    let db = Firestore.firestore()
    
    init(users: [UserInfo] = []) {
        self.users = users
    }
    
    private func getUserDocument(userID: String) async -> DocumentSnapshot? {
        do {
            let snapshot = try await db.collection("UserInfo").document(userID).getDocument()
            return snapshot
        } catch {
            print("Get User Document Error : \(error)")
            
        }
        return nil
    }
    
    @MainActor
    func requestUser(userID: String) async {
        let document = await getUserDocument(userID: userID)
        
        if let document {
            do {
                let user: UserInfo = try document.data(as: UserInfo.self)
                self.user = user
            } catch {
                print("Request User Error : \(error.localizedDescription)")
            }
        }
    }
	
	// MARK: - PUSHED VIEW를 그릴 때 상대방의 정보를 가져오는 메소드
	public func requestAnotherUserInfoWithID(userID: String) async -> UserInfo? {
		let doc = db.collection("UserInfo").document(userID)
		
		do {
			let userInfo = try await doc.getDocument(as: UserInfo.self)
			return userInfo
		} catch {
			dump("\(#file), \(#function) - DEBUG \(error.localizedDescription)")
			return nil
		}
	}
	
	// MARK: - User 의 device token을 서버에 업데이트 합니다.
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
    
    
    func requestUsers() async {
        
        let snapshot = await getUserDocuments()
        var users: [UserInfo] = []
        
        if let snapshot {
            for document in snapshot.documents {
                do {
                    let user: UserInfo = try document.data(as: UserInfo.self)
                    users.append(user)
                } catch {
                    print("Request Users Error : \(error)")
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
        guard let user else {
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
            let newUser: UserInfo = .init(id: user.id,
                                          createdDate: user.createdDate,
										  githubUserName: user.githubUserName,
										  githubID: user.githubID,
                                          deviceToken: user.deviceToken,
                                          emailTo: user.emailTo,
                                          blockedUserIDs: newBlockedUserIDs)
            await writeUser(user: newUser)
            try await db
                .collection("UserInfo")
                .document(user.id)
                .updateData(["blockedUserIDs" : newBlockedUserIDs])
        } catch {
            print("Block/Unblock User Update Error : \(error.localizedDescription)")
        }
        
    }
    
}
