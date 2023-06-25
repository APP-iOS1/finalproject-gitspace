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
            self.tags.removeAll()
            let snapshot = try await database.collection(const.COLLECTION_USER_INFO)
                .document(Auth.auth().currentUser?.uid ?? "")
                .collection(const.COLLECTION_TAG)
                .getDocuments()
            for document in snapshot.documents {
                let id = document[const.FIELD_ID] as? String ?? ""
                let tagName = document[const.FIELD_TAGNAME] as? String ?? ""
                let repositories = document[const.FIELD_REPOSITORIES] as? [String] ?? []
                self.tags.append( Tag(id: id, tagName: tagName, repositories: repositories) )
            }
        } catch {
            print("Error-\(#file)-\(#function): \(error.localizedDescription)")
        }
    }
    
    // MARK: Register New Custom Tag
    /// 새로운 사용자 정의 태그를 등록합니다.
    func registerTag(tagName: String) async -> Tag? {
        do {
            let tid = UUID().uuidString
            try await database.collection(const.COLLECTION_USER_INFO)
                .document(Auth.auth().currentUser?.uid ?? "")
                .collection(const.COLLECTION_TAG)
                .document(tid)
                .setData([
                    const.FIELD_ID: tid,
                    const.FIELD_TAGNAME: tagName,
                    const.FIELD_REPOSITORIES: []
                ])
            return Tag(id: tid, tagName: tagName, repositories: [])
        } catch {
            print("Error-\(#file)-\(#function): \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: Delete Custom Tag
    /// 특정 사용자 태그를 삭제합니다.
    func deleteTag(tag: Tag) async -> Void {
        do {
            try await database.collection(const.COLLECTION_USER_INFO)
                .document(Auth.auth().currentUser?.uid ?? "")
                .collection(const.COLLECTION_TAG)
                .document(tag.id)
                .delete()
        } catch {
            print("Error-\(#file)-\(#function): \(error.localizedDescription)")
        }
    }
    
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
            let snapshot = try await database
                .collection(const.COLLECTION_USER_INFO)
                .document(Auth.auth().currentUser?.uid ?? "")
                .collection(const.COLLECTION_TAG)
                .whereField(const.FIELD_REPOSITORIES, arrayContains: "\(repositoryName)")
                .getDocuments()
            for document in snapshot.documents {
                let id = document.data()[const.FIELD_ID] as? String ?? ""
                let name = document.data()[const.FIELD_TAGNAME] as? String ?? ""
                let repositories = document.data()[const.FIELD_REPOSITORIES] as? [String] ?? []
                tagNameList.append(Tag(id: id, tagName: name, repositories: repositories))
            }
            return tagNameList
        } catch {
            print("Error-\(#file)-\(#function): \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: Register Repository Tag
    /// 선택된 레포지토리에 새로운 태그를 추가합니다.
    func addRepositoryTag(_ tags: [Tag], to selectedRepositoryName: String) async -> Void {
        do {
            for tag in tags {
                try await database.collection(const.COLLECTION_USER_INFO)
                    .document(Auth.auth().currentUser?.uid ?? "")
                    .collection(const.COLLECTION_TAG)
                    .document(tag.id)
                    .updateData([
                        const.FIELD_REPOSITORIES: FieldValue.arrayUnion([selectedRepositoryName])
                    ])
            }
        } catch {
            print("Error-\(#file)-\(#function): \(error.localizedDescription)")
        }
    }
    
    /*
    // MARK: Update Repository Tag
    /// 선택된 레포지토리의 태그를 수정합니다.
    func updateRepositoryTag() {
        
    }
    */
    
    // MARK: Delete Repository Tag
    /// 선택된 레포지토리의 태그를 삭제합니다.
    func deleteRepositoryTag(_ tags: [Tag], to selectedRepositoryName: String) async -> Void {
        do {
            for tag in tags {
                try await database.collection(const.COLLECTION_USER_INFO)
                    .document(Auth.auth().currentUser?.uid ?? "")
                    .collection(const.COLLECTION_TAG)
                    .document(tag.id)
                    .updateData([
                        const.FIELD_REPOSITORIES: FieldValue.arrayRemove([selectedRepositoryName])
                    ])
            }
        } catch {
            print("Error-\(#file)-\(#function): \(error.localizedDescription)")
        }
    }
}
