//
//  GSPushNotificationRouter.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/11.
//

import SwiftUI

// TODO: 하위 인스턴스 분리 및 추상화 필요
final class PushNotificationManager: ObservableObject {
	private(set) var currentUserDeviceToken: String?
	
	/// 예시 코드에서 API 키와 테스트용 Device Token은 xcconfig 파일로 캡슐화 하여 사용했습니다.
	private let serverKey = Bundle.main.object(forInfoDictionaryKey: "SERVER_KEY") as? String ?? ""
	private let valseDevice = Bundle.main.object(forInfoDictionaryKey: "VALSE_DEVICE_TOKEN") as? String ?? ""
	private let endpoint = Bundle.main.object(forInfoDictionaryKey: "PUSH_NOTIFICATION_ENDPOINT") as? String ?? ""
	
	public func setCurrentUserDeviceToken(token: String) {
		currentUserDeviceToken = token
	}
	
	/// Button을 탭할 때, 아래 메소드를 호출합니다.
	public func sendPushNotification(
		with message: GSTabBarRouter.MessageType,
		to userInfo: UserInfo
	) async -> Void {
		/// 이 url 에는 Legacy HTTP의 엔드포인트가 아규먼트로 전달됩니다.
		
		guard let url = URL(string: "https://\(endpoint)" ?? "") else {
			print("Error: \(#file)-\(#function): NO URL FOR PUSH NOTIFICATION")
			return
		}
		
		var messageTitle: String = ""
		var messageBody: String = ""
		var fromUserName: String = ""
		var navigateTo: String = ""
		var viewBuildID: String = ""
		
		switch message {
		case let .knock(title, body, fromUser, id):
			messageTitle = title
			messageBody = body
			navigateTo = "knock"
			fromUserName = fromUser
			viewBuildID = id
		case let .chat(title, body, fromUser, id):
			messageTitle = title
			messageBody = body
			navigateTo = "chat"
			fromUserName = fromUser
			viewBuildID = id
		}
		
		/// HTTP Request의 body로 전달할 data를 딕셔너리로 선언한 후, JSON으로 변환합니다.
		let json: [AnyHashable: Any] = [
			/// 특정 기기에 알람을 보내기 위해 "to"를 사용합니다.
			/// 경우에 따라 Topic 등 다른 용도로 활용할 수 있습니다.
			/// valse 폰으로 확인하려면  각주를 해제합니다.
//			"to": valseDevice,
			"to": userInfo.deviceToken,
			
			/// 알람의 내용을 구성하는 키-밸류 입니다.
			"notification": [
				"title": messageTitle,
				"body": messageBody,
				"subtitle": fromUserName,
				"badge": "1"
			],
			
			/// 알람을 보내며 함께 전달할 데이터를 삽입합니다.
			"data": [
				"userName": "CurrentUserID",
				"sentDeviceToken": currentUserDeviceToken ?? "보낸 이의 디바이스토큰",
				"sentUserName": userInfo.githubLogin,
				"sentUserID": userInfo.id,
				"navigateTo": navigateTo,
				"viewBuildID": viewBuildID,
				"date": Date.now.description
			]
		]
		
		/// HTTP Body로 전달할 JSON 파일을 상단의 딕셔너리로 생성합니다.
		let httpBody = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
		
		/// URLReqeust를 만들고 적절한 메소드와 헤더를 설정합니다.
		var request = URLRequest(url: url)
		request.httpMethod = HTTPRequestMethod.post.rawValue
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
	
	// MARK: LIFECYCLE
	init(
		currentUserDeviceToken: String?
	) {
		self.currentUserDeviceToken = currentUserDeviceToken
	}
}

struct GSPushNotification: Codable {
	let aps: GSAps
	let googleCAE, googleCFid, gcmMessageID, googleCSenderID,
		userName, sentDeviceToken, sentUserName, sentUserID, navigateTo, viewBuildID, date: String
	
	enum CodingKeys: String, CodingKey {
		case aps
		case userName, sentDeviceToken, sentUserName, sentUserID, navigateTo, viewBuildID, date
		
		case googleCAE = "google.c.a.e"
		case googleCFid = "google.c.fid"
		case gcmMessageID = "gcm.message_id"
		case googleCSenderID = "google.c.sender.id"
	}
}

// MARK: - Aps
struct GSAps: Codable {
	let alert: GSNotificationDetail
	let badge: Int
}

// MARK: - Alert
struct GSNotificationDetail: Codable {
	let body, title, subtitle: String
}

struct PushNotificationTestView: View {
	
	var body: some View {
		VStack {
			Button {
				Task {
					let instance = PushNotificationManager(currentUserDeviceToken: "H")
					let valseDevice = Bundle.main.object(forInfoDictionaryKey: "VALSE_DEVICE_TOKEN") as? String ?? ""
					
					dump("\(#function), \(instance)")
//					await instance.sendPushNotification(
//						with: .knock(title: "knockMessage", body: "Knock 내용", knockID: "jri5guzFI47hLmZjVFJU"),
//						to: UserInfo(id: UUID().uuidString, createdDate: .now, githubLogin: "Valselee", githubID: 000, deviceToken: valseDevice, githubEmail: "", blockedUserIDs: [""])
//					)
//					await instance.sendPushNotification(
//						with: .chat(title: "chatMessage", body: "chat 내용", chatID: "6FBB214E-C5EE-46F6-9670-4DCA5B73AF17"),
//						to: UserInfo(id: UUID().uuidString, createdDate: .now, githubLogin: "Valselee",
//									 githubID: 000,
//									 deviceToken: valseDevice, githubEmail: "", blockedUserIDs: [""])
//					)
				}
			} label: {
				Text("Send")
			}
			
		}
	}
}
