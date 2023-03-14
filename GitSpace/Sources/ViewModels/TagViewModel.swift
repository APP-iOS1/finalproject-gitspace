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
    
    private let database = Firestore.firestore()
    private let const = Constant.FirestorePathConst.self
    
    // MARK: Request Custom tags
    /// 사용자가 등록한 모든 사용자 정의 태그를 불러옵니다.
    @MainActor
    func requestTags() async -> Void {
        do {
            let snapshot = try await database.collection(const.COLLECTION_USER_INFO)
                .document(Auth.auth().currentUser?.uid ?? "")
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
    func registerTag(tagName: String) async -> Tag? {
        do {
            let tid = UUID().uuidString
            try await database.collection(const.COLLECTION_USER_INFO)
                .document(Auth.auth().currentUser?.uid ?? "")
                .collection("Tag")
                .document(tid)
                .setData([
                    "id": tid,
                    "tagName": tagName,
                    "repositories": []
                ])
            return Tag(id: tid, tagName: tagName, repositories: [])
        } catch {
            print("Register Tag Error")
            return nil
        }
    }
    
    // MARK: Delete Custom Tag
    /// 특정 사용자 태그를 삭제합니다.
    func deleteTag(tag: Tag) async -> Void {
        do {
            try await database.collection(const.COLLECTION_USER_INFO)
                .document(Auth.auth().currentUser?.uid ?? "")
                .collection("Tag")
                .document(tag.id)
                .delete()
        } catch {
            print("Delete Tag")
        }
    }
    
    // FIXME: 수정 시나리오 완성 후 메서드 구현
    /*
    // MARK: Update Custom Tag
    /// 특정 사용자 태그를 수정합니다.
    func updateTag() {
        
    }
    */
    
    
    // MARK: Request Repository's Tags
    /// 선택된 레포지토리의 모든 태그를 불러옵니다.
    func requestRepositoryTags(repositoryName: String) async -> [Tag]? {
        do {
            var tagNameList: [Tag] = []
            let snapshot = try await database.collectionGroup("Tag")
                .whereField("repositories", arrayContains: "\(repositoryName)")
                .getDocuments()
            for document in snapshot.documents {
                let id = document.data()["id"] as? String ?? ""
                let name = document.data()["tagName"] as? String ?? ""
                let repositories = document.data()["repositories"] as? [String] ?? []
                tagNameList.append(Tag(id: id, tagName: name, repositories: repositories))
            }
            return tagNameList
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    // MARK: Register Repository Tag
    /// 선택된 레포지토리에 새로운 태그를 추가합니다.
    func addRepositoryTag(_ tags: [Tag], repositoryFullname: String) async -> Void {
        do {
            for tag in tags {
                print(tag)
                try await database.collection(const.COLLECTION_USER_INFO)
                    .document(Auth.auth().currentUser?.uid ?? "")
                    .collection("Tag")
                    .document(tag.id)
                    .updateData([
                        "repositories": FieldValue.arrayUnion([repositoryFullname])
                    ])
            }
        } catch {
            print("Error")
        }
    }
    
    // FIXME: 정말 필요한 함수인지 확인하기
    /*
    // MARK: Update Repository Tag
    /// 선택된 레포지토리의 태그를 수정합니다.
    func updateRepositoryTag() {
        
    }
    
    // MARK: Delete Repository Tag
    /// 선택된 레포지토리의 태그를 삭제합니다.
    func deleteRepositoryTag() {
        
    }
    */
}
