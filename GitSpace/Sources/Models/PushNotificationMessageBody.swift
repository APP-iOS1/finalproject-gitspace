//
//  PushNotificationMessageBody.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/21.
//

import Foundation

/**
 Push Notification의 Payload 데이터 구조체.
 메세지의 제목, 바디, 발신자, 뷰가 도착해야 할 뷰, 도착하여 그려야 할 데이터의 정보를 담습니다.
 
 - Author: @Valselee
 */
struct PushNotificationMessageBody {
	let messageTitle: String
	let messageBody: String
	let fromUserName: String
	let navigateTo: String
	let viewBuildID: String
	
	init(_ messageType: PushNotificationMessageType) {
		switch messageType {
		case let .knock(title, body, fromUser, knockID):
			messageTitle = title
			messageBody = body
			navigateTo = "knock"
			fromUserName = fromUser
			viewBuildID = knockID
		case let .chat(title, body, fromUser, chatID):
			messageTitle = title
			messageBody = body
			navigateTo = "chat"
			fromUserName = fromUser
			viewBuildID = chatID
		}
	}
}
