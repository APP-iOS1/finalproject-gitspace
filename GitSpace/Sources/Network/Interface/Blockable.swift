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
     blockTargetUser(with:) 메소드는 targetUser를 block하는 비동기 함수입니다.
     
     - Parameters:
        - with targetUser: UserInfo 타입
     - Returns: - Result<Void, BlockError>
     - throws: - BlockError enum > blockCreateFailed
     */
    func blockTargetUser(
        in currentUser: UserInfo,
        with targetUser: UserInfo
    ) async throws -> Result<Void, BlockError>
    
    /**
     unblockTargetUser(with:) 메소드는 targetUser를 unblock 하는 비동기 함수입니다.
     
     - Parameters:
        - with targetUser: UserInfo 타입
     - Returns: - Result<Void, BlockError>
     - throws: - BlockError enum > unblockDeleteFailed
     */
    func unblockTargetUser(
        in currentUser: UserInfo,
        with targetUser: UserInfo
    ) async throws -> Result<Void, BlockError>
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
            
            return .success(())
        } catch {
            return .failure(.blockCreateFailed)
        }
    }
    
    func unblockTargetUser(
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
                        FieldValue.arrayRemove([targetUser.id])
                ])
            
            return .success(())
        } catch {
            return .failure(.unblockDeleteFailed)
        }
    }
}

enum BlockError: Error {
    case blockCreateFailed
    case unblockDeleteFailed
}
