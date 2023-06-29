//
//  ChatModel.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import Foundation
import Firebase
import FirebaseFirestore

// 채팅방 모델
struct Chat: Identifiable, Codable {
    let id: String // 채팅방 ID
    let createdDate: Date // 생성 날짜
    let joinedMemberIDs: [String] // 채팅방에 참여한 유저 ID 리스트
    var lastContent: String // 마지막 메세지 내용
    var lastContentDate: Date // 마지막 메세지 날짜
    var knockContent: String // 노크 메세지 내용
    let knockContentDate: Date // 노크 메세지 날짜
    var unreadMessageCount: [String : Int] // 읽지 않은 메시지 갯수 (userID : 읽지 않은 메시지 갯수)
    
    // MARK: -Computed Properties
    // 로그인 ID와 joinedMemberIDs를 비교해서 상대방 유저 ID를 반환하는 연산 프로퍼티
    var targetUserID: String {
        if let firstUser = joinedMemberIDs.first, let secondUser = joinedMemberIDs.last {
            return firstUser == Utility.loginUserID
            ? secondUser
            : firstUser
        }
        return ""
    }
    
    var createdDateAsString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: createdDate)
    }
    
    var lastContentDateAsString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.string(from: lastContentDate)
    }
    
    var lastContentTimeAsString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: lastContentDate)
    }
    
    var knockContentDateAsString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH:mm"
        return dateFormatter.string(from: knockContentDate) + " " + (dateFormatter.timeZone.abbreviation() ?? "")
    }
    
    static func emptyChat() -> Chat {
        return Chat.init(
            id: "",
            createdDate: .now,
            joinedMemberIDs: [],
            lastContent: "",
            lastContentDate: .now,
            knockContent: "",
            knockContentDate: .now,
            unreadMessageCount: [:]
        )
    }
    
    static func encodedChat(with chat: Chat) -> Chat {
        var encodedChat: Chat = chat
        encodedChat.knockContent = chat.knockContent.asBase64 ?? ""
        encodedChat.lastContent = chat.lastContent.asBase64 ?? ""
        return encodedChat
    }
    
    static func decodedChat(with chat: Chat) -> Chat {
        var decodedChat: Chat = chat
        decodedChat.knockContent = chat.knockContent.decodedBase64String ?? ""
        decodedChat.lastContent = chat.lastContent.decodedBase64String ?? ""
        return decodedChat
    }
}
