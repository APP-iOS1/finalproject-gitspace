//
//  Report.swift
//  GitSpace
//
//  Created by Celan on 2023/04/16.
//

import Foundation
import FirebaseFirestore

struct Report: Codable {
    var id: String = UUID().uuidString
    var reason: String
    var reporterID: String
    var targetUserID: String
    var date: Timestamp
    // Knock 메시지, Chat 메시지 등등
    var content: String?
    var type: String
    
    enum ReportType: String, Codable {
        case user = "User"
        case chat = "Chat"
        case knock = "Knock"
    }
    
    enum ReportReason: String, Codable, CaseIterable {
        case spamming = "Spamming"
        case offensive = "Verbal Abuse, Offensive Language"
        case sexual = "Sexual Description(Activity)"
        case cheating = "Cheating"
        case bullying = "Cyberbullying or Harassment"
    }
    
    enum ReportReasonDescription: String, CaseIterable {
        case spamming = "Spamming Description"
        case offensive = "Verbal Abuse, Offensive Language Description"
        case sexual = "Sexual Description(Activity) Description"
        case cheating = "Cheating Description"
        case bullying = "Cyberbullying or Harassment Description"
    }
}
