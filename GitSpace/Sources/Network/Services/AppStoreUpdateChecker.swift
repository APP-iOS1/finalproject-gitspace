//
//  AppStoreUpdateChecker.swift
//  GitSpace
//
//  Created by 원태영 on 2023/07/03.
//

import Foundation

enum AppStoreUpdateCheckerError: Error {
    case invalidInfoDictionary
    case invalidBundleID
    case invalidCurrentVersionNumber
    case invalidItunesURL
    case invalidResponse
    case failToDecoding
    case unexpectedStatusCode
    case unknown
    case emptyResponse
    case invalidVersionFormat
}

final class AppStoreUpdateChecker {
    
    private static func compareVersion(
        client: String,
        store: String
    ) -> Result<Bool, AppStoreUpdateCheckerError> {
        // 3개의 숫자 사이가 .으로 연결되어있는지 검사하는 정규식 패턴 ex. 1.2.3 / 123.456.789
        let pattern: String = #"^\d+\.\d+\.\d+$"#
        
        // 두 버전 값이 패턴에 일치하는지, 문자열로 된 숫자가 Int로 변환이 되는지 검사
        guard
            client.isValidPattern(pattern: pattern),
            store.isValidPattern(pattern: pattern)
        else {
            return .failure(.invalidVersionFormat)
        }
        
        var clientVersionArr: [Int?] = client.components(separatedBy: ".").map{Int($0)}
        var storeVersionArr: [Int?] = store.components(separatedBy: ".").map{Int($0)}
        
        
        var isNewVersionAvailable: Bool = false
        let minCount = min(
            clientVersionArr.count,
            storeVersionArr.count
        )
        
        /// Major -> Minor -> Patch 순서로 비교
        /// client가 store보다 높은 숫자가 있으면 최신 버전으로 확정하고 클로저 종료
        /// store가 client보다 높은 숫자가 있으면 업데이트 가능으로 확정하고 클로저 종료
        (1...minCount).forEach { _ in
            guard
                let clientNum: Int = clientVersionArr.removeFirst(),
                let storeNum: Int = storeVersionArr.removeFirst()
            else {
                return
            }
            
            if clientNum > storeNum {
                isNewVersionAvailable = false
                return
            } else if clientNum < storeNum {
                isNewVersionAvailable = false
                return
            }
        }
        
        return .success(isNewVersionAvailable)
    }
    
    /**
     클라이언트 앱 버전과 App Store의 릴리즈 앱 버전을 비교해서 업데이트 가능 여부를 반환하는 함수입니다.
     
     - Author: 태영, 다혜
     
     - Since: 2023.07.03
     
     - Returns: 현재 버전과 릴리즈 버전이 동일한지를 반환합니다.
     */
    static func isNewVersionAvailable() async -> Result<Bool, AppStoreUpdateCheckerError> {
        // 앱 번들 인포 리스트 딕셔너리
        guard let infoDictionary = Bundle.main.infoDictionary else {
            return .failure(.invalidInfoDictionary)
        }
        
        // 앱 번들 ID
        guard let bundleID = Bundle.main.bundleIdentifier else {
            return .failure(.invalidBundleID)
        }
        
        /// 앱 버전
        /// ex) 1.0.0
        guard var currentVersionNumber = infoDictionary["CFBundleShortVersionString"] as? String else {
            return .failure(.invalidCurrentVersionNumber)
        }
        
        /// 클라이언트에서 제공하는 앱 버전은 마지막 숫자가 0이면 스킵하여 제공함
        /// ex) 1.0.0 -> 1.0
        /// API에서 제공받은 버전과 비교하기 위해 스킵된 경우 동일한 형식으로 맞추기 위해 .0을 뒤에 추가
        if currentVersionNumber.components(separatedBy: ".").count <= 2 {
            currentVersionNumber += ".0"
        }
        
        // ItunesAPI 요청 URL
        guard let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(bundleID)") else {
            return .failure(.invalidItunesURL)
        }
        
        do {
            let (data, urlResponse) = try await URLSession.shared.data(from: url)

            guard let response = urlResponse as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            
            guard Array(200...299).contains(response.statusCode) else {
                return .failure(.unexpectedStatusCode)
            }

            guard let decodedResponse = try? JSONDecoder().decode(
                AppInfo.self,
                from: data
            ) else {
                return .failure(.failToDecoding)
            }
            
            // decoded된 AppInfo 객체는 Lookup API 특성상 results 배열이 비어있는 경우(0), 정보가 정상적으로 담긴 경우(1)가 존재합니다.
            guard let latestVersionNumber = decodedResponse.results.first?.version else {
                return .failure(.emptyResponse)
            }
            
            return .success(currentVersionNumber != latestVersionNumber)

        } catch {
            return .failure(.unknown)
        }
    }
    
}
