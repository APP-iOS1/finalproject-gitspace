//
//  PushNotificationManager.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/08.
//

import Foundation

final class PushNotificationManager {
	private let serverKey = Bundle.main.object(forInfoDictionaryKey: "SERVER_KEY") as? String ?? ""
	private let deviceToken = Bundle.main.object(forInfoDictionaryKey: "VALSE_DEVICE_TOKEN") as? String ?? ""
	
	public func sendPushNoti(url: String) async -> Void {
		guard let url = URL(string: url) else {
			print("?", url)
			return
		}
		
		let messageTitle = "코드푸쉬성공"
		let messageBody = "푸쉬내용은 아무거나입니당 키킥"
		let json: [String: Any] =
			[
				"to" : "fGaJW44Wp0UOtH63n_6g7t:APA91bHY5fUK5Y2872Du4kXTz8o706FGCSNaJtOxV01MnyZhjUYaam9QWbk9UxaaNjny_Yg8VnBlWfL45XxrcnN-X6ypeS0nIA7HuouM5e67AgOXsa0LrPjrNZ39j8-31XlqUqI8ZTZc",
				"notification": [
					"title": messageTitle,
					"body": messageBody
				],
				"data" : [
					"userName": "valselee"
				]
			]

		
		let httpBody = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
		
		do {
			guard let httpBody else { return }
			let uploadPayload = try await URLSession.shared.upload(for: request, from: httpBody)
			dump("\(deviceToken), \(serverKey)")
			// 가져온 데이터에서 유저의 이름과 채팅방 정보, 노크 정보 등이 있어야 뷰를 그려서 랜딩시킬 수 있을 듯
			dump("DEBUG: PUSH POST SUCCESSED - \(uploadPayload.0)")
		} catch {
			dump("DEBUG: PUSH POST FAILED - \(error)")
		}
		
	}
}
