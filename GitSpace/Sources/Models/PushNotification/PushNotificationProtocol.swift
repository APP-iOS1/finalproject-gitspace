//
//  PushNotification.swift
//  GitSpace
//
//  Created by Celan on 2023/03/08.
//

import SwiftUI

/**
 PushNotification을 발송하는 모델이 채택합니다.
 해당 모델은 서버 엔드포인트에 접근할 url 속성과 sendNotification, MakeNotificationData, configureHTTPRequst 메소드를 갖습니다.
 
 - Author: @Valselee(celan)
 */
protocol GSPushNotificationSendable {
    var url: URL? { get }
    
    /**
        Notification을 생성하여 발송하는 동시성 메소드입니다.
         - Parameters:
            - with: PushNotificationMessageType 열거형 타입으로 knock, chat을 전달합니다. 해당 내용으로 Push Notification을 구성합니다.
            - to: 어떤 유저에게 알람을 보낼지 UserInfo 타입으로 전달합니다.
     */
    func sendNotification(
        with message: PushNotificationMessageType,
        to userInfo: UserInfo
    ) async -> Void
    
    /**
         Notification의 payload 데이터를 생성합니다.
        - Parameters:
            - pushNotificationBody: PushNotificationMessageBody 열거형 타입으로 Data를 만들 때 필요한 데이터를 전달합니다.
            - to: UserInfo 정보를 받아서 해당 유저의 기기 토큰과 아이디를 활용하여 필요한 Data 타입을 리턴합니다.
         - Returns: Data?

     */
    func makeNotificationData(
        pushNotificationBody: PushNotificationMessageBody,
        to userInfo: UserInfo
    ) -> Data?
    
    /**
     Notification의 HTTP Request를 생성합니다.
     - Returns: URLRequest
     */
    func configureHTTPRequest(
        url: URL
    ) -> URLRequest
}

/**
 Notification을 탭할 때 View를 Navigate할 수 있도록 합니다.
 */
protocol GSPushNotificationNavigatable {
    var isNavigatedToReceivedKnock: Bool { get set }
    var isNavigatedToSentKnock: Bool { get set }
    var isNavigatedToChat: Bool { get set }
}
