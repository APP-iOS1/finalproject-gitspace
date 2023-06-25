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
                /// 이미 사용 중인 사용자들의 Tag 데이터는 약식 암호화가 적용되지 않아서 임시로 분기 처리함.
                if let decodedTagName = tagName.decodedBase64String {
                    self.tags.append(Tag(id: id, tagName: decodedTagName, repositories: repositories))
                } else {
                    self.tags.append(Tag(id: id, tagName: tagName, repositories: repositories))
                }
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
            guard let encodeTagName = tagName.asBase64 else { return nil }
            try await database.collection(const.COLLECTION_USER_INFO)
                .document(Auth.auth().currentUser?.uid ?? "")
                .collection(const.COLLECTION_TAG)
                .document(tid)
                .setData([
                    const.FIELD_ID: tid,
                    const.FIELD_TAGNAME: encodeTagName,
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
                let tagName = document.data()[const.FIELD_TAGNAME] as? String ?? ""
                let repositories = document.data()[const.FIELD_REPOSITORIES] as? [String] ?? []
                /// 이미 사용 중인 사용자들의 Tag 데이터는 약식 암호화가 적용되지 않아서 임시로 분기 처리함.
                if let decodedTagName = tagName.decodedBase64String {
                    tagNameList.append(Tag(id: id, tagName: decodedTagName, repositories: repositories))
                } else {
                    tagNameList.append(Tag(id: id, tagName: tagName, repositories: repositories))
                }
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
