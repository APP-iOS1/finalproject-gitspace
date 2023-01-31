//
//  ChatModel.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import Foundation
import Firebase

// 채팅방 모델
struct Chat : Identifiable {
    let id : String // 채팅방 ID
    let date : Date // 생성 날짜
    let users: (senderID: String, receiverID: String) // 채팅방 참여 유저 2명 ID (개설, 참여)
    let lastDate : Date // 마지막 메세지 날짜
    let lastContent : String // 마지막 메세지 내용
    let knockContent: String // 노크 메세지 내용
    let knockDate: Date // 노크 메세지 날짜
    
    // MARK: -Computed Properties
    // 로그인 ID와 userIDs를 비교해서 상대방 유저 ID를 반환하는 연산 프로퍼티
    var targetID : String {
        return users.senderID == Utility.loginUserID ? users.receiverID : users.senderID
    }
    
    var userIDList : [String] {
        return [users.senderID, users.receiverID]
    }
    
    var stringDate : String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    var stringLastDate : String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.string(from: lastDate)
    }
    
    var stringLastTime : String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: lastDate)
    }
    
    var stringKnockDate : String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH:mm:ss"
        return dateFormatter.string(from: knockDate) + (dateFormatter.timeZone.abbreviation() ?? "")
    }
}
