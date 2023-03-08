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
    let knockContent: String // 노크 메세지 내용
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
    
    /* Memo
     - UserID를 통해 UserInfo를 Request하는 로직을 UserStore로 분리하기 위해 주석처리
     - UserStore의 타입 메서드인 requestAndReturnUser를 통해 UserInfo를 리턴받을 수 있음. 23.02.26 태영
    // targetID 연산 프로퍼티를 활용해서 DB의 target User Name을 찾아서 반환하는 연산 프로퍼티
    var targetUserName: String {
        get async {
            let db = Firestore.firestore()
            var returnUserName: String = ""
            
            do  {
                let document = try await db
                    .collection("UserInfo")
                    .document(targetUserID)
                    .getDocument()
                if let data = document.data() {
                    let name = data["githubLogin"] as? String ?? ""
                    returnUserName = name
                }
            } catch { }
            
            return returnUserName.isEmpty ? "이름 없음" : returnUserName
        }
    }
     */
    
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
}
