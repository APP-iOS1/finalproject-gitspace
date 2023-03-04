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
	let sentUserName: String
	let navigateTo: String
	let viewBuildID: String
	
	init(_ messageType: PushNotificationMessageType) {
		switch messageType {
		case let .knock(title, body, knockSentFrom, knockID):
			self.messageTitle = title
			self.messageBody = body
			self.navigateTo = "knock"
			self.sentUserName = knockSentFrom
			self.viewBuildID = knockID
		case let .chat(title, body, chatSentFrom, chatID):
			self.messageTitle = title
			self.messageBody = body
			self.navigateTo = "chat"
			self.sentUserName = chatSentFrom
			self.viewBuildID = chatID
		}
	}
}

enum PushNotificationMessageType {
	case knock(title: String, body: String, knockSentFrom: String, knockID: String)
	case chat(title: String, body: String, chatSentFrom: String, chatID: String)
}
