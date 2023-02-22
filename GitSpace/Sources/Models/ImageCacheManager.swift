//
//  ImageCacheManager.swift
//  GitSpace
//
//  Created by 원태영 on 2023/02/20.
//

import SwiftUI

final class ImageCacheManager {
    
    // MARK: - Properties
    // MEMO: NSCache의 Key는 AnyObject 타입으로 되어있기 때문에, 구조체인 String 타입은 Key로 사용할 수 없습니다. 그래서 클래스인 NSString을 Key로 사용하며, 호출 시점에서 String을 Key로 사용하기 전에 NSString으로 변환 과정을 거칩니다. By. 태영
    static let shared = NSCache<NSString, UIImage>()
    private let memoryWarningNotification = UIApplication.didReceiveMemoryWarningNotification
    
    // MARK: - Initializers
    private init() {
        // MARK: 메모리 부족을 감지하여 removeAllImages 메서드를 호출하는 옵저버를 생성합니다.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(removeAllImages),
                                               name: memoryWarningNotification,
                                               object: nil)
    }
    
    deinit {
        // MARK: 이미지 캐시 매니저가 더 이상 사용되지 않을 때, 메모리 부족 감지 옵저버를 해제합니다.
        NotificationCenter.default.removeObserver(self,
                                                  name: memoryWarningNotification,
                                                  object: nil)
    }
    
    // MARK: - Methods
    /**
     전달받은 Key를 NSString 타입으로 변환한 뒤, NSCache에 접근하여 저장된 UIImage 리소스를 반환합니다.
     - Author: 태영
     - Since: 2023.02.21
     - Parameters:
        - forKey: NSCache에 저장된 UIImage에 접근하기 위한 String Key입니다.
     - Returns: Key에 해당하는 저장된 UIImage를 반환합니다. Dictionary에 접근하기 때문에 옵셔널로 반환됩니다.
     */
    static func getObject(forKey key: String) -> UIImage? {
        let cacheKey = NSString(string: key)
        let cachedImage = shared.object(forKey: cacheKey)
        return cachedImage
    }
    
    /**
     전달받은 Key를 NSString 타입으로 변환한 뒤, NSCache에 forKey:setImage 형태로 저장합니다.
     - Author: 태영
     - Since: 2023.02.21
     - Parameters:
        - forKey: NSCache에 UIImage를 저장하기 위한 Key입니다.
        - setImage: forKey에 해당하는 value로 저장될 UIImage입니다.
     */
    static func setObject(forKey key: String, setImage: UIImage) {
        let cacheKey = NSString(string: key)
        shared.setObject(setImage, forKey: cacheKey)
    }
    
    /**
     NSCache 싱글턴 인스턴스인 shared의 캐시 이미지를 모두 삭제합니다.
     - Author: 태영
     - Since: 2023.02.21
     */
    @objc
    private func removeAllImages() {
        ImageCacheManager.shared.removeAllObjects()
    }
}
