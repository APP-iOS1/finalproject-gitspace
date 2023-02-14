//
//  Keychain.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/14.
//

import Foundation
import Security

final class Keychain: NSObject {
	public class func saveData(
		serviceIdentifier: NSString,
		userAccount: NSString,
		data: String
	) {
		self.save(
			service: serviceIdentifier,
			userAccount: userAccount,
			data: data
		)
	}
	
	public class func loadData(
		serviceIdentifier: NSString,
		userAccount: NSString
	) -> String? {
		let data = self.load(
			service: serviceIdentifier,
			userAccount: userAccount
		)
		
		return data
	}
	
	private class func save(
		service: NSString,
		userAccount: NSString,
		data: String
	) {
		let dataFromString: Data = data.data(using: String.Encoding.utf8)!
		
		// Instantiate a new default keychain query
		let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword as String,
									kSecAttrService as String: service,
									kSecAttrAccount as String: userAccount,
									kSecValueData as String: dataFromString]
		
		// Delete any existing items
		SecItemDelete(query as CFDictionary)
		
		// Add the new keychain item
		SecItemAdd(query as CFDictionary, nil)
	}
	
	private class func load(
		service: NSString,
		userAccount: NSString
	) -> String? {
		// Instantiate a new default keychain query
		// Tell the query to return a result
		// Limit our results to one item
		let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword as String,
									kSecAttrService as String: service,
									kSecAttrAccount as String: userAccount,
									kSecReturnData as String: kCFBooleanTrue!,
									kSecMatchLimit as String: kSecMatchLimitOne as String]
		
		var retrievedData: NSData?
		var dataTypeRef:AnyObject?
		var contentsOfKeychain: String?
		
		let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
		
		if (status == errSecSuccess) {
			retrievedData = dataTypeRef as? NSData
			contentsOfKeychain = String(data: retrievedData! as Data, encoding: String.Encoding.utf8)
		}
		else
		{
			print("Nothing was retrieved from the keychain. Status code \(status)")
			contentsOfKeychain = nil
		}
		
		return contentsOfKeychain
	}
}
