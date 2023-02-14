//
//  Utility.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import SwiftUI
import FirebaseAuth
//아래는 원태영 userID
//        return "lX1YHIOZiLXVtB76QDIeekxKgt33"
//아래는 정예슬 userID
//        return "u87hDEGpJ6WQcLXe8GM9yaGwT993"
//아래는 홍길동 userID
//        return "lX1YHIOZiLXVtB76QDIeekxKgt34"


enum Utility {
     static var loginUserID: String = "aw6BYepF9EhL50sPbhL3NsaD0Fz1"
//    static var loginUserID: String = "PJjxY5xHGZXXsMGqpyWExd50iDP2"
    
    static var MessageCellWidth: CGFloat {
        return UIScreen.main.bounds.width / 5 * 3
    }
    
    static var UIWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
}
