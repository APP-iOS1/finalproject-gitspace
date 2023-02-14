//
//  TagViewModel.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/02/14.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class TagViewModel: ObservableObject {
    @Published var tags: [Tag] = []
    
    let database = Firestore.firestore()
    
    // MARK: Request Custom tags
    /// 사용자가 등록한 모든 사용자 정의 태그를 불러옵니다.
    @MainActor
    func requestTags() async -> Void {
        do {
            let snapshot = try await database.collection("UserInfo")
            // FIXME: 현재 유저 id로 변경
                .document("50159740")
//                .document(Auth.auth().currentUser?.uid ?? "")
                .collection("Tag")
                .getDocuments()
            self.tags.removeAll()
            for document in snapshot.documents {
                let id = document["id"] as? String ?? ""
                let tagName = document["tagName"] as? String ?? ""
                let repositories = document["repositories"] as? [String] ?? []
                self.tags.append( Tag(id: id, tagName: tagName, repositories: repositories) )
            }
        } catch {
            print("Error")
        }
    }
    
    // MARK: Register New Custom Tag
    /// 새로운 사용자 정의 태그를 등록합니다.
    func registerTag(tagName: String) async -> Void {
        do {
            let tid = UUID().uuidString
            try await database.collection("UserInfo")
            // FIXME: 현재 유저 id로 변경
                .document("50159740")
//                .document(Auth.auth().currentUser?.uid ?? "")
                .collection("Tag")
                .document(tid)
                .setData([
                    "id": tid,
                    "tagName": tagName,
                    "repositoires": []
                ])
        } catch {
            print("Register Tag Error")
        }
    }
    
    // MARK: Delete Custom Tag
    /// 특정 사용자 태그를 삭제합니다.
    func deleteTag(tag: Tag) async -> Void {
        do {
            try await database.collection("UserInfo")
                .document("50159740")
//                .document(Auth.auth().currentUser?.uid ?? "")
                .collection("Tag")
                .document(tag.id)
                .delete()
        } catch {
            print("Delete Tag")
        }
    }
    
    // MARK: Update Custom Tag
    /// 특정 사용자 태그를 수정합니다.
    func updateTag() {
        // FIXME: 수정 시나리오 완성 후 메서드 구현
    }
    
}
