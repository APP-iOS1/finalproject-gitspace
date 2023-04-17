//
//  Reportable.swift
//  GitSpace
//
//  Created by Celan on 2023/04/16.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol Reportable {
    associatedtype ReportContent = String
    
    /// 로그인 유저와 신고 객체를 받아서 Firestore Report 컬렉션에 문서를 추가하는 비동기 함수입니다.
    func reportTarget(by currentUser: UserInfo,
                      with report: Report
    ) async throws -> Result<Void, ReportableError>
    
    /// 신고 객체의 중복 여부를 통해 신고가 가능한지 여부를 체크해서 반환하는 비동기 함수입니다. reportTarget 내부에서 사용합니다.
    func checkReportable(
        by currentUser: UserInfo,
        with report: Report
    ) async throws -> Result<Void, ReportableError>
}

extension Reportable {
    func reportTarget(
        by currentUser: UserInfo,
        with report: Report
    ) async throws -> Result<Void, ReportableError> {
        let db = Firestore.firestore()
        
        // TODO: - 너무 많은 신고 로직
        let reportableResult = try await checkReportable(by: currentUser, with: report)
        
        switch reportableResult {
        case .success(()):
            do {
                try db
                    .collection(Constant.FirestorePathConst.COLLECTION_REPORT)
                    .document(report.id)
                    .setData(from: report.self)
                return .success(())
            } catch {
                return .failure(.setReportFailed)
            }
        default:
            return reportableResult
        }
    }
    
    func checkReportable(
        by currentUser: UserInfo,
        with report: Report
    ) async throws -> Result<Void, ReportableError> {
        let db = Firestore.firestore()
        let const = Constant.FirestorePathConst.self
        let calendar = Calendar.current
        let timestampAsDate = report.date.dateValue()
        
        let year = calendar.component(.year, from: timestampAsDate)
        let month = calendar.component(.month, from: timestampAsDate)
        let day = calendar.component(.day, from: timestampAsDate)
        
        if let startDate = calendar.date(from: DateComponents(year: year, month: month, day: day)) {
            do {
                let snapshot = try await db
                    .collection(const.COLLECTION_REPORT)
                    .whereField(const.FIELD_REPORTER_ID, isEqualTo: currentUser.id)
                    .whereField(const.FIELD_TARGET_USER_ID, isEqualTo: report.targetUserID)
                    .whereField(const.FIELD_REASON, isEqualTo: report.reason)
                    .whereField(const.FIELD_DATE, isGreaterThanOrEqualTo: startDate)
                    .getDocuments()
                // 조건에 해당하는 문서가 없는 경우 신고가 가능
                return snapshot.isEmpty
                ? .success(())
                : .failure(.alreadyReported)
            } catch {
                return .failure(.requestReportFailed)
            }
        } else {
            return .failure(.invalidDate)
        }
    }
}

enum ReportableError: Error {
    case invalidDate // 날짜 정보가 잘못된 경우 (startDate를 옵셔널 바인딩 못한 경우)
    case alreadyReported // 내가 상대방을 오늘 같은 사유로 신고한 이력이 있는 경우
    case requestReportFailed // report 컬렉션 요청이 실패한 경우
    case setReportFailed // report 컬렉션에 setData가 실패한 경우
    case unKnownError
}
