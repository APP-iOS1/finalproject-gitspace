//
//  Blockable.swift
//  GitSpace
//
//  Created by Celan on 2023/04/16.
//

import Foundation
import FirebaseFirestore

/**
 Blockable 프로토콜은 블락/언블락 작업을 수행하는 데 사용됩니다.
 이 프로토콜을 구현하는 클래스 또는 구조체는 targetUser 매개 변수를 통해 UserInfo 타입을 입력으로 받습니다.
 블락 작업이 성공하면 void 타입이 Result 에 담겨 반환됩니다.
 그러나 실패하는 경우, BlockError 열거형에 정의된 하나의 오류가 발생합니다.
 */
protocol Blockable {
    /**
     blockTargetUser(in: , with: ) 메소드는 targetUser를 block하는 비동기 함수입니다.
     
     - Parameters:
        - in currentUser: UserInfo 타입
        - with targetUser: UserInfo 타입
     - Returns: - Result<Void, BlockError>
     - throws: - BlockError enum > blockCreateFailed
     */
    func blockTargetUser(
        in currentUser: UserInfo,
        with targetUser: UserInfo
    ) async throws -> Result<Void, BlockError>
    
    /**
     unblockTargetUser(in: , with: ) 메소드는 targetUser를 unblock 하는 비동기 함수입니다.
     
     - Parameters:
        - in currentUser: UserInfo 타입
        - with targetUser: UserInfo 타입
     - Returns: - Result<Void, BlockError>
     - throws: - BlockError enum > unblockDeleteFailed
     */
    func unblockTargetUser(
        in currentUser: UserInfo,
        with targetUser: UserInfo
    ) async throws -> Result<Void, BlockError>
        
    /**
     isBlocked(by: , with: ) 메소드는 subjectUser가 objectUser를 차단했는지 검증하는 함수입니다.
     subjectUser가 이미 objectUser를 차단했다면 true를 반환하고,
     차단을 하지 않았다면 false를 반환합니다.
     
     - Parameters:
        - by subjectUser: UserInfo 타입, 차단을 한 주체
        - with objectUser: UserInfo 타입, 차단을 당한 객체
     - Returns: - Bool
     */
    func isBlocked(
        by subjectUser: UserInfo,
        with objectUser: UserInfo
    ) -> Bool
    
    /**
     isBlockedEither(by: , by: ) 메소드는 currentUser와 targetUser 간의 차단 상태를 확인하는 함수입니다.
     둘 중 하나라도 차단을 했다면 true를 반환하고,
     둘 다 차단하지 않은 상태라면 false를 반환합니다.
     
     - Parameters:
        - by currentUser: UserInfo 타입
        - by targetUser: UserInfo 타입
     - Returns: - Bool
     */
    func isBlockedEither(
        by currentUser: UserInfo,
        by targetUser: UserInfo
    ) -> Bool
}

extension Blockable {
    func blockTargetUser(
        in currentUser: UserInfo,
        with targetUser: UserInfo
    ) async throws -> Result<Void, BlockError> {
        let db = Firestore.firestore()
        
        do {
            try await db
                .collection(Constant.FirestorePathConst.COLLECTION_USER_INFO)
                .document(currentUser.id)
                .updateData([
                    Constant.FirestorePathConst.FIELD_BLOCKED_USER_IDS:
                        FieldValue.arrayUnion([targetUser.id])
                ])
            
            try await db
                .collection(Constant.FirestorePathConst.COLLECTION_USER_INFO)
                .document(targetUser.id)
                .updateData([
                    Constant.FirestorePathConst.FIELD_BLOCKED_BY_USER_IDS:
                        FieldValue.arrayUnion([currentUser.id])
                ])
            
            return .success(())
        } catch {
            return .failure(.blockCreateFailed)
        }
    }
    
    @discardableResult
    func unblockTargetUser(
        in currentUser: UserInfo,
        with targetUser: UserInfo
    ) async throws -> Result<Void, BlockError> {
        let db = Firestore.firestore()
        do {
            try await db
                .collection(Constant.FirestorePathConst.COLLECTION_USER_INFO)
                .document(targetUser.id)
                .updateData([
                    Constant.FirestorePathConst.FIELD_BLOCKED_BY_USER_IDS:
                        FieldValue.arrayRemove([currentUser.id])
                ])
            
            try await db
                .collection(Constant.FirestorePathConst.COLLECTION_USER_INFO)
                .document(currentUser.id)
                .updateData([
                    Constant.FirestorePathConst.FIELD_BLOCKED_USER_IDS:
                        FieldValue.arrayRemove([targetUser.id])
                ])
            
            return .success(())
        } catch {
            return .failure(.unblockDeleteFailed)
        }
    }
    
    func isBlocked(
        by subjectUser: UserInfo,
        with objectUser: UserInfo
    ) -> Bool {
        return subjectUser.blockedUserIDs.contains(objectUser.id)
    }
    
    func isBlockedEither(
        by currentUser: UserInfo,
        by targetUser: UserInfo
    ) -> Bool {
        return  currentUser.blockedUserIDs.contains(targetUser.id) ||
                currentUser.blockedByUserIDs.contains(targetUser.id)
    }
}

enum BlockError: Error {
    case blockCreateFailed
    case unblockDeleteFailed
}
