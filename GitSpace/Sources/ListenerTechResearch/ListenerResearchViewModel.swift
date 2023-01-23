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
        
        db.collectionGroup("Review").addSnapshotListener { snapshot, error in
                // snapshot이 비어있으면 에러 출력 후 리턴
                guard let snp = snapshot else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                
                // document 변경 사항에 대해 감지해서 작업 수행
                snp.documentChanges.forEach { diff in
                    switch diff.type {
                    case .added:
                        print("added")
                        
                    case .modified:
                        print("modified")
                    case .removed:
                        print("removed")
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


// TODO: -해야할 거
/// 1. snapshotListener에서 단일로 Cell을 추가하거나 삭제하는 것이 가능한지
/// 2. 업데이트 된 단일 Cell이 View에 반영되는지
/// 3. remove할 때 인덱스 번호로 찾아가서 걔만 지울 수 있는지
