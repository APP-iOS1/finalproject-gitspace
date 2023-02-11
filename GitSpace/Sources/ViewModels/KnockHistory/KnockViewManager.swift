//
//  KnockNetworkManager.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/11.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

final class KnockNetworkManager: ObservableObject {
	@Published var eachKnock: Knock?
	@Published var receivedKnockList: [Knock] = []
	@Published var sentKnockList: [Knock] = []
	
	private let currentUser = "Valselee"
	private let firebaseDatabase = Firestore.firestore().collection("Knock")
	
	public let trailingTransition = AnyTransition
		.asymmetric(
			insertion: .move(edge: .trailing),
			removal: .move(edge: .trailing)
		)
	
	public let leadingTransition = AnyTransition
		.asymmetric(
			insertion: .move(edge: .leading),
			removal: .move(edge: .leading)
		)
	
	// MARK: - METHODS
	public func addSnapshotToKnock() async {
		firebaseDatabase
			.addSnapshotListener { snapshot, err in
				// snapshot이 비어있으면 에러 출력 후 리턴
				guard let eachSnap = snapshot else {
					print("Error fetching documents: \(err!)")
					return
				}

				eachSnap.documentChanges.forEach { diff in
					switch diff.type {
					case .added:
						print("added")
						print(diff.document.documentID)
						Task {
							await self.requestKnockList()
						}
					case .modified:
						print("modified")
						print(diff.document.documentID)
					case .removed:
						print("removed")
					}
				}
			}
	}
	
	// MARK: - In Normal Situation(foreground)
	public func requestKnockList() async -> Void {
		do {
			let snapshot = try await firebaseDatabase.getDocuments()
			for docs in snapshot.documents {
				let eachKnock = try docs.data(as: Knock.self)
				await appendKnockElement(eachKnock: eachKnock)
			}
		} catch {
			dump("DEBUG: REQUEST FALIED: \(error)")
		}
	}
	
	@MainActor
	private func appendKnockElement(eachKnock: Knock) -> Void {
		// block 했을 때 수신함에 쌓이지 않도록 확인하는 로직 필요
		if eachKnock.receivedUserName == currentUser {
			receivedKnockList.append(eachKnock)
			print(receivedKnockList, "RECEIVED")
		} else {
			sentKnockList.append(eachKnock)
			print(sentKnockList, "SENT")
		}
	}
	
	// MARK: - In Push Notification(Background, foreground)
	public func requestKnockWithID(knockID: String) async -> Knock? {
		let document = firebaseDatabase.document("\(knockID)")
		
		do {
			let requestKnock = try await document.getDocument(as: Knock.self)
			return self.eachKnock
		} catch {
			dump(error.localizedDescription)
		}
		return nil
	}
	
	// Create
	public func createKnock(knock: Knock) async -> Void {
		let document = firebaseDatabase.document("\(knock.id)")
		
		do {
			try await document.setData([
				"id": knock.id,
				"date": Timestamp(date: knock.date),
				"declineMessage": knock.declineMessage,
				"knockCategory": knock.knockCategory,
				"knockStatus": Constant.KNOCK_WAITING,
				"knockMessage": knock.knockMessage,
				"receivedUserName": knock.receivedUserName,
				"sentUserName": knock.sentUserName,
			])
		} catch {
			dump(error.localizedDescription)
		}
	}
}

