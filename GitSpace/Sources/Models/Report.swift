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
        
        func getDescription() -> String {
            switch self {
            case .spamming:
                return "Sending unsolicited messages in bulk by chat and knock."
            case .offensive:
                return "Including, but not limited to language that is unlawful, harmful, threatening, abusive, harassing, defamatory, vulgar, obscene, sexually explicit, or otherwise objectionable."
            case .sexual:
                return "Sending offensive sexual content to other users."
            case .cheating:
                return "Using unapproved third party programs or cheating the other users with false information."
            case .bullying:
                return "Intentionally bullying other users."
            }
        }
        
    }
}
