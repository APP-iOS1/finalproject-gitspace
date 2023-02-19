//
//  UserInfo.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

// TODO: Chat팀과 혀이 유저 모델링 논의 필요

import Foundation

struct UserInfo : Identifiable, Codable {
    // MARK: -Properties
    let id: String // 유저 ID
    let createdDate: Date // 유저 생성일시
    let githubUserName: String // 유저 깃허브 ID
	let githubID: Int // 유저 깃허브 ID값, 받을 때 정수형으로 와서 타입 통일
    var deviceToken: String // 유저 기기 토큰
    let emailTo: String? // 유저 이메일
    let blockedUserIDs: [String] // 차단한 유저 ID 리스트
    
    // MARK: -Func : Double 타입 Date를 문자열로 반환하는 함수
    var stringDate : String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: createdDate)
    }
	
	static func getFaliedUserInfo() -> Self {
		let userinfo = UserInfo(
			id: "FALIED",
			createdDate: .now,
			githubUserName: "FAILED",
			githubID: 0,
			deviceToken: "",
			emailTo: "",
			blockedUserIDs: [""]
		)
		return userinfo
	}
}

