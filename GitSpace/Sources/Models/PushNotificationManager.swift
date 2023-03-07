//
//  GSPushNotificationRouter.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/11.
//

import SwiftUI

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

// MARK: - ObservableObject 구현부
final class PushNotificationManager: ObservableObject {
	private(set) var currentUserDeviceToken: String?
	private(set) var viewBuildID: String? = "DOCPATH"
	
	/// Test를 위한 개인 디바이스 키
	private let valseDevice = Bundle.main.object(forInfoDictionaryKey: "VALSE_DEVICE_TOKEN") as? String ?? ""

	// MARK: - Methods
	/// private(set) 속성에 접근하여 DeviceToken을 할당합니다.
	public func setCurrentUserDeviceToken(token: String) {
		currentUserDeviceToken = token
	}
	
	/// private(set) 속성에 접근하여 view를 그릴 때 필요한 데이터 ID를 할당합니다.
	public func assignViewBuildID(_ id: String) {
		self.viewBuildID = id
	}
	
	// MARK: LIFECYCLE
	init(
		currentUserDeviceToken: String?
	) {
		self.currentUserDeviceToken = currentUserDeviceToken
	}
}

// MARK: - GSPushNotificationSendable 프로토콜 구현부
extension PushNotificationManager: GSPushNotificationSendable {
	var url: URL? {
		URL(string: "https://\(Constant.PushNotification.PUSH_NOTIFICATION_ENDPOINT)")
	}
	
	public func sendNotification(
		with message: PushNotificationMessageType,
		to userInfo: UserInfo
	) async -> Void {
		guard let url else { return }
		let messageBody = PushNotificationMessageBody(message)
		let httpBody = makeNotificationData(pushNotificationBody: messageBody, to: userInfo)
		let httpRequest = configureHTTPRequest(url: url)
		
		do {
			guard let httpBody else { return }
			
			/// 비동기 함수로 정의된 URLSession upload(for:from:) 메소드를 호출합니다.
			/// uploadPayload는 (Data, Response) 를 갖고 있는 튜플 타입 입니다.
			let _ = try await URLSession.shared.upload(
				for: httpRequest,
				from: httpBody
			)
		} catch {
			/// POST가 실패했을 경우 에러를 확인할 수 있도록 dump를 호출합니다.
			dump("DEBUG: PUSH POST FAILED - \(error)")
		}
	}
	
	internal func makeNotificationData(
		pushNotificationBody: PushNotificationMessageBody,
		to userInfo: UserInfo
	) -> Data? {
		/// HTTP Request의 body로 전달할 data를 딕셔너리로 선언한 후, JSON으로 변환합니다.
		let json: [AnyHashable: Any] = [
			/// 특정 기기에 알람을 보내기 위해 "to"를 사용합니다.
			/// 경우에 따라 Topic 등 다른 용도로 활용할 수 있습니다.
			"to": userInfo.deviceToken,
			
			/// 알람의 내용을 구성하는 키-밸류 입니다.
			"notification": [
				"title": pushNotificationBody.messageTitle,
				"body": pushNotificationBody.messageBody,
				"subtitle": pushNotificationBody.sentUserName,
				"badge": "1"
			],
			
			/// 알람을 보내며 함께 전달할 데이터를 삽입합니다.
			"data": [
				"userName": "CurrentUserID",
				"sentDeviceToken": currentUserDeviceToken ?? "보낸 이의 디바이스토큰",
				"sentUserName": userInfo.githubLogin,
				"sentUserID": userInfo.id,
				"navigateTo": pushNotificationBody.navigateTo,
				"viewBuildID": pushNotificationBody.viewBuildID,
				"date": Date.now.description
			]
		]
		let httpBody = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
		
		return httpBody
	}
	
	internal func configureHTTPRequest(url: URL) -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = HTTPRequestMethod.post.rawValue
		request.setValue(
			"application/json",
			forHTTPHeaderField: "Content-Type"
		)
		
		/// serverKey 는 3번 과정에서 저장해둔 키를 사용합니다.
		request.setValue(
			"key=\(Constant.PushNotification.SERVER_KEY)",
			forHTTPHeaderField: "Authorization"
		)
		
		return request
	}
}

struct GSPushNotification: Codable {
	let aps: GSAps
	let googleCAE, googleCFid, gcmMessageID, googleCSenderID,
		userName, sentDeviceToken, sentUserName, sentUserID, navigateTo, viewBuildID, date: String
	
	enum CodingKeys: String, CodingKey {
		case aps, userName, sentDeviceToken, sentUserName, sentUserID, navigateTo, viewBuildID, date
		
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

/// TEST할 때 사용하는 뷰
struct PushNotificationTestView: View {
	
	var body: some View {
		VStack {
			Button {
				Task {
					let instance = PushNotificationManager(currentUserDeviceToken: "H")
					let valseDevice = Bundle.main.object(forInfoDictionaryKey: "VALSE_DEVICE_TOKEN") as? String ?? ""
					
//					await instance.sendPushNotification(
//						with: .knock(title: "knockMessage", body: "Knock 내용", fromUser: "", knockID: ""),
//						to: UserInfo(id: UUID().uuidString, createdDate: .now, githubUserName: "Valselee", githubID: 000, deviceToken: valseDevice, emailTo: "", blockedUserIDs: [""])
//					)
					
//					await instance.sendNotification(
//						with: .knock(title: "", body: "", nameOfKnockedPerson: "", knockID: ""),
//						to: UserInfo(id: UUID().uuidString, createdDate: .now, githubUserName: "Valselee", githubID: 000, deviceToken: valseDevice, emailTo: "", blockedUserIDs: [""])
//						)
					
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
