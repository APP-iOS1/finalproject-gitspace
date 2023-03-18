//
//  KeyChainManager.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/03/09.
//

import Foundation
import FirebaseAuth

//enum KeyChainItemClassType {
//    case kSecClassGenericPassword
//    case kSecClassInternetPassword
//    case kSecClassCertificate
//    case kSecClassKey
//    case kSecClassIdentity
//}

// FIXME: 반복해서 사용할 수 있도록 프로토콜로 만들기
/// AT도 KeyChain에 저장해야 하므로 KeyChain Manager를 Protocol로 구분할 필요가 있다.
// MARK: KeyChain CRUD
/// KeyChain을 사용하는 기능을 관리합니다.
final class KeyChainManager {
    
    static func create(authCredential: AuthCredential) -> Bool {
        let query: [CFString: Any] = [
            kSecClass : kSecClassGenericPassword, /*필수*/
            kSecAttrLabel : "credential",
            kSecAttrAccount : "credential", /*필수*/
            kSecValueData : authCredential  /*필수*/
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    static func read() -> AuthCredential? {
        let query: [CFString: Any] = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount : "credential",
            kSecReturnAttributes : true
        ]
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess else {
            print(#function, "error")
            return nil
        }
        guard let existingItem = item as? [String: Any],
              let data = existingItem[kSecValueData as String] as? AuthCredential else {
            print(#function, "existing item")
            return nil
        }
        return data
    }
    
    static func delete() -> Bool {
        let query: [CFString: Any] = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount : "credential",
            kSecReturnAttributes : true
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}


