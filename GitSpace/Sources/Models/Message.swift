//
//  ChatCellModel.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import Foundation

// 채팅 메세지 모델
struct Message : Identifiable, Codable {
    let id: String // 메세지 ID
    let senderID: String // 메세지 작성자 유저 ID
    let textContent: String // 메세지 내용
    let imageContent: String? // 메세지에 첨부한 이미지
    let sentDate: Date // 메세지 작성 날짜
    let isRead: Bool // 수신 유저의 메세지 확인 여부

    var stringDate : String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: sentDate)
    }
}
