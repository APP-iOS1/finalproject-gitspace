//
//  UserViewModel.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import Foundation
import FirebaseFirestore

class UserStore : ObservableObject {
    @Published var users: [UserInfo]
    
    let db = Firestore.firestore()
    
    init(users: [UserInfo] = []) {
        self.users = users
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
                        let signUpDate = docData["signUpDate"] as? Double ?? 0.0
                        
                        let newUserInfo = UserInfo.init(id: id,
                                                        name: name,
                                                        email: email,
                                                        signUpDate: signUpDate)
                        self.users.append(newUserInfo)
                    }
                }
            }
    }
    
}
