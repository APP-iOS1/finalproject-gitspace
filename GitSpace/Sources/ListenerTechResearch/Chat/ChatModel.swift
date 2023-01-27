//
//  ChatModel.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import Foundation

// 채팅방 모델
struct Chat : Identifiable {
    let id : String // 채팅방 ID
    let date : Double // 생성 날짜
    let userIDs : (open: String, join: String) // 채팅방 참여 유저 2명 ID (개설, 참여)
    let lastDate : Double // 마지막 메세지 날짜
    let lastContent : String // 마지막 메세지 내용
    
    // MARK: -Computed Properties
    // 로그인 ID와 userIDs를 비교해서 상대방 유저 ID를 반환하는 연산 프로퍼티
    var targetID : String {
        return userIDs.open == Utility.loginUserID ? userIDs.join : userIDs.open
    }
    
    var userIDList : [String] {
        return [userIDs.open, userIDs.join]
    }
    
    var stringDate : String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateAt = Date(timeIntervalSince1970: date)
        return dateFormatter.string(from: dateAt)
    }
    
    var stringLastDate : String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let dateAt = Date(timeIntervalSince1970: lastDate)
        return dateFormatter.string(from: dateAt)
    }
    
    var stringLastTime : String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "HH:mm"
        let dateAt = Date(timeIntervalSince1970: lastDate)
        return dateFormatter.string(from: dateAt)
    }
}
