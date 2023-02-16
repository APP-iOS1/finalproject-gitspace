//
//  Utility.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import SwiftUI
import FirebaseAuth

enum Utility {
    // FIXME: loginUserID -> 유저 객체 참조로 변경하려하였으나, Model 연산 프로퍼티에서 유저 ID가 필요한 로직으로 구성하여 바로 포팅할 수 없음. 이후에 로직 수정 후 유저 객체로 변경 예정 230215 By. 태영
    static var loginUserID: String = ""
    
    static var MessageCellWidth: CGFloat {
        return UIScreen.main.bounds.width / 5 * 3
    }
    
    static var UIWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
}
