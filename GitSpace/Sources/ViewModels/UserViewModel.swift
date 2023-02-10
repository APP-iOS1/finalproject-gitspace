//
//  UserViewModel.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import Foundation
import FirebaseFirestore

class UserStore : ObservableObject {
    
    @Published var user: UserInfo?
    @Published var users: [UserInfo]
    
    let db = Firestore.firestore()
    
    init(users: [UserInfo] = []) {
        self.users = users
    }
    
    private func getUserDocument(userID: String) async -> DocumentSnapshot? {
        do {
            let snapshot = try await db.collection("User").document(userID).getDocument()
            return snapshot
        } catch {
            print("Get User Document Error : \(error)")
        }
        return nil
    }
    
    func requestUser(userID: String) async {
        let document = await getUserDocument(userID: userID)
        
        if let document {
            do {
                let user: UserInfo = try document.data(as: UserInfo.self)
                self.user = user
            } catch {
                print("Request User Error : \(error)")
            }
        }
    }
    
    func fetchUsers() {
        db.collection("UserInfo")
            .getDocuments { (snapshot, error) in
                self.users.removeAll()
                
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        let docData = document.data()
                        let name = docData["name"] as? String ?? ""
                        let email = docData["email"] as? String ?? ""
                        let timeStamp: Timestamp = docData["date"] as? Timestamp ?? Timestamp()
                        let date: Date = Timestamp.dateValue(timeStamp)()
                        
                        let newUserInfo = UserInfo.init(id: id,
                                                        name: name,
                                                        email: email,
                                                        date: date)
                        self.users.append(newUserInfo)
                    }
                }
            }
    }
    
}
