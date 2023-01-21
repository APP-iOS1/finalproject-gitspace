//
//  ListenerResearchViewModel.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/20.
//

import Foundation
import FirebaseFirestore

class ListenerViewModel: ObservableObject {
    @Published var stores: [Store]
    @Published var reviews: [Review]
    
    let db = Firestore.firestore()
    
    init(stores : [Store] = [], reviews : [Review] = []) {
        self.stores = stores
        self.reviews = reviews
    }
    
    func requestData(userID : String) {
        db.collectionGroup("Review")
            .whereField("userID", isEqualTo: userID)
            .getDocuments { (snapshot, error) in
                self.reviews.removeAll()
                
                if let snapshot {
                    for document in snapshot.documents {
                        
                        let id : String = document.documentID
                        let docData = document.data()
                        let storeID : String = docData["storeID"] as? String ?? ""
                        let userID : String = docData["userID"] as? String ?? ""
                        let content : String = docData["content"] as? String ?? ""
                        
                        
                        let newReview : Review = Review(id: id,
                                                        storeID: storeID,
                                                        userID: userID,
                                                        content: content)
                        
                        self.reviews.append(newReview)
                    }
                }
            }
    }
    //TODO: API에서 async await concurrency 지원하는지 여부 파악
    
    func addListener() {
        
        db.collectionGroup("Review")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                querySnapshot?.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        // message add
                        
                        print("New Message: \(diff.document.data())")
                        self.requestData(userID: "kaz")
                    }
                    if (diff.type == .modified) {
                        print("Modified Message: \(diff.document.data())")
                    }
                    if (diff.type == .removed) {
                        print("Removed Message: \(diff.document.data())")
                    }
                }
            }
    }
    
    func addReview(newReview : [String:Any]) {
        let id: String = newReview["id"] as? String ?? ""
        let storeID: String = newReview["storeID"] as? String ?? ""
        let userID: String = newReview["userID"] as? String ?? ""
        let content: String = newReview["content"] as? String ?? ""
        
        let newNewReview : Review = Review(id: id, storeID: storeID, userID: userID, content: content)
        
        
    }
    
   
}


