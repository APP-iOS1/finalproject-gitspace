//
//  ImageCacheManager.swift
//  GitSpace
//
//  Created by 원태영 on 2023/02/20.
//

import SwiftUI

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private let memoryWarningNotification = UIApplication.didReceiveMemoryWarningNotification
    
    private init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(removeAllImages),
                                               name: memoryWarningNotification,
                                               object: nil)
    }
    
    @objc
    private func removeAllImages() {
        ImageCacheManager.shared.removeAllObjects()
    }
}
