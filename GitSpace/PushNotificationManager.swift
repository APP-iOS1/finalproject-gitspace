//
//  PushNotificationManager.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/08.
//

import Foundation

final class PushNotificationManager {
	/// 예시 코드에서 API 키와 테스트용 Device Token은 xcconfig 파일로 캡슐화 하여 사용했습니다.
	private let serverKey = Bundle.main.object(forInfoDictionaryKey: "SERVER_KEY") as? String ?? ""
	private let deviceToken = Bundle.main.object(forInfoDictionaryKey: "VALSE_DEVICE_TOKEN") as? String ?? ""
	
	/// Button을 탭할 때, 아래 메소드를 호출합니다.
	public func sendPushNoti(url: String) async -> Void {
		print(deviceToken)
		
		/// 이 url 에는 Legacy HTTP의 엔드포인트가 아규먼트로 전달됩니다.
		/// url == https://fcm.googleapis.com/fcm/send
		guard let url = URL(string: url) else {
			return
		}
		
		let messageTitle = "Message Title Here"
		let messageBody = "Message Body Text Here"
		
		/// HTTP Request의 body로 전달할 data를 딕셔너리로 선언한 후, JSON으로 변환합니다.
		let json: [String: Any] =
		[
			/// 특정 기기에 알람을 보내기 위해 "to"를 사용합니다.
			/// 경우에 따라 Topic 등 다른 용도로 활용할 수 있습니다.
			"to": deviceToken,
			
			/// 알람의 내용을 구성하는 키-밸류 입니다.
			"notification": [
				"title": messageTitle,
				"body": messageBody,
				"badge": "1"
			],
			
			/// 알람을 보내며 함께 전달할 데이터를 삽입합니다.
			"data": [
				"GSNotification": [
					"userName": "Valselee",
					"from": "DeviceToken2",
					"navigate": "Knock" // or Chat
				]
			]
		]
		
		/// HTTP Body로 전달할 JSON 파일을 상단의 딕셔너리로 생성합니다.
		let httpBody = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
		
		/// URLReqeust를 만들고 적절한 메소드와 헤더를 설정합니다.
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		/// serverKey 는 3번 과정에서 저장해둔 키를 사용합니다.
		request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
		
		do {
			guard let httpBody else { return }
			
			/// 비동기 함수로 정의된 URLSession upload(for:from:) 메소드를 호출합니다.
			/// uploadPayload는 (Data, Response) 를 갖고 있는 튜플 타입 입니다.
			let uploadPayload = try await URLSession.shared.upload(for: request, from: httpBody)
			
			/// 어떤 데이터가 서로 송수신되는지 확인할 수 있습니다.
			dump("DEBUG: PUSH POST SUCCESSED - \(uploadPayload.0)")
		} catch {
			/// POST가 실패했을 경우 에러를 확인할 수 있도록 dump를 호출합니다.
			dump("DEBUG: PUSH POST FAILED - \(error)")
		}
		
	}
}

struct GSPushNotification: Codable {
	let aps: GSAps
	let googleCAE, googleCFid, gcmMessageID, googleCSenderID: String
	let gsNotification: String
	
	enum CodingKeys: String, CodingKey {
		case aps
		case googleCAE = "google.c.a.e"
		case googleCFid = "google.c.fid"
		case gcmMessageID = "gcm.message_id"
		case googleCSenderID = "google.c.sender.id"
		case gsNotification = "GSNotification"
	}
}

// MARK: - Aps
struct GSAps: Codable {
	let alert: GSNotificationDetail
	let badge: Int
}

// MARK: - Alert
struct GSNotificationDetail: Codable {
	let body, title: String
}

// MARK: - GSNotification
struct GSNotificationData: Codable {
	let navigate, from, userName: String
}
