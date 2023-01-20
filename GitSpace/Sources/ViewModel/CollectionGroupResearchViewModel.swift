//
//  CollectionGroupResearchViewModel.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/20.
//

import Foundation
import FirebaseFirestore

class CollectionGroupViewModel: ObservableObject {
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
}

