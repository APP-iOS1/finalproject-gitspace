//
//  EncryptionUpdateViewModel.swift
//  GitSpace
//
//  Created by 박제균 on 2023/07/04.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class EncryptionUpdateViewModel {

    private let db = Firestore.firestore()
    private let const = Constant.FirestorePathConst.self

    func readChatDocuments() async {
        do {
            let snapshot = try await db
                .collection(const.COLLECTION_CHAT)
                .getDocuments()

            for document in snapshot.documents {
                guard let knockContent = document.data()["knockContent"] as? String else { return }
                guard let lastConetent = document.data()["lastContent"] as? String else { return }
                print(knockContent)
                print(lastConetent)
            }

        } catch {
            print("Error-\(#file)-\(#function) : \(error.localizedDescription)")
        }

    }

    func applyChatContentEncryption() async {

      do {
          let snapshot = try await db
              .collection(const.COLLECTION_CHAT)
              .getDocuments()

          for document in snapshot.documents {
              guard let knockContent = document.data()["knockContent"] as? String else { return }
              guard let lastContent = document.data()["lastContent"] as? String else { return }

              try await document.reference.updateData(["knockContent": knockContent.asBase64 ?? ""])
              try await document.reference.updateData(["lastContent": lastContent.asBase64 ?? ""])
          }
      } catch {
          print("Error-\(#file)-\(#function) : \(error.localizedDescription)")
      }

    }

    func applyDecryption() async {

      do {
          let snapshot = try await db
              .collection(const.COLLECTION_CHAT)
              .getDocuments()

          for document in snapshot.documents {
              guard let knockContent = document.data()["knockContent"] as? String else { return }
              guard let lastContent = document.data()["lastContent"] as? String else { return }

            try await document.reference.updateData(["knockContent": knockContent.decodedBase64String ?? ""])
              try await document.reference.updateData(["lastContent": lastContent.decodedBase64String ?? ""])
          }
      } catch {
          print("Error-\(#file)-\(#function) : \(error.localizedDescription)")
      }

    }

    func readMessageDocuments() async {
        do {
            let snapshot = try await db
                .collection(const.COLLECTION_CHAT)
                .getDocuments()

            for document in snapshot.documents {
                let messages = try await document.reference.collection(const.COLLECTION_MESSAGE).getDocuments()

                for message in messages.documents {
                    guard let textContent = message.data()["textContent"] as? String else { return }
                    print(textContent)
                }
            }
        } catch {
            print("Error-\(#file)-\(#function) : \(error.localizedDescription)")
        }
    }

    func applyMessageContentEncryption() async {
        do {
            let snapshot = try await db
                .collection(const.COLLECTION_CHAT)
                .getDocuments()

            for document in snapshot.documents {
                let messages = try await document.reference.collection(const.COLLECTION_MESSAGE).getDocuments()

                for message in messages.documents {
                    guard let textContent = message.data()["textContent"] as? String else { return }
                    try await message.reference.updateData(["textContent": textContent.asBase64 ?? ""])
                }
            }
    func readTagDocuments() async {
        do {
            print("[알림] 모든 Tag를 출력합니다.")
            
            let snapshot = try await db
                .collection(const.COLLECTION_USER_INFO)
                .getDocuments()
            
            for document in snapshot.documents {
                let tags = try await document.reference.collection(const.COLLECTION_TAG).getDocuments()
                
                for tag in tags.documents {
                    guard let tagName = tag.data()["tagName"] as? String else { return }
                    print(tagName)
                }
            }
            
            print("[알림] 모든 Tag를 출력했습니다.")
        } catch {
            print("Error-\(#file)-\(#function) : \(error.localizedDescription)")
        }
    }
    func readKnockDocuments() async {
        do {
            print("[알림] 모든 Knock를 출력합니다.")
            
            let snapshot = try await db
                .collection("Knock")
                .getDocuments()
            
            for document in snapshot.documents {
                guard let knock = document.data()["knockMessage"] as? String else { return }
                print(knock)
            }
            
            print("[알림] 모든 Knock를 출력했습니다.")
        } catch {
            print("Error-\(#file)-\(#function) : \(error.localizedDescription)")
        }
    }

  }

