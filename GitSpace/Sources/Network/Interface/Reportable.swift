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
    
    // 신고하기만 구현
    func reportTarget() async throws -> Result<Void, ReportableError>
    
    // report 내역 가져오기
    func requestReportHistory() async throws -> Result<Void, ReportableError>
}

extension Reportable {
    func reportTarget(
        by currentUser: UserInfo,
        with report: Report
    ) async throws -> Result<Void, ReportableError> {
        let db = Firestore.firestore()
        
        // TODO: - 너무 많은 신고 로직
        
        do {
            try db
                .collection(Constant.FirestorePathConst.COLELCTION_REPORT)
                .document(report.id)
                .setData(from: report.self)
            
            return .success(())
        } catch {
            return .failure(.requestReportFailed)
        }
    }
    
    internal func checkIfTooManyReport() {
        
    }
}

enum ReportableError: Error {
    case tooManyRequest
    case requestReportFailed
}
