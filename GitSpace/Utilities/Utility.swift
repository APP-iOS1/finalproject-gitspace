//
//  Utility.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import SwiftUI
import FirebaseAuth

enum Utility {
    static var loginUserID : String {
        //아래는 원태영 userID
//        return "lX1YHIOZiLXVtB76QDIeekxKgt33"
        //아래는 정예슬 userID
        return "u87hDEGpJ6WQcLXe8GM9yaGwT993"
    }
    
    static var MessageCellWidth: CGFloat {
        return UIScreen.main.bounds.width / 5 * 3
    }
    
    static var UIWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
}
