//
//  Color+.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/23.
//

import SwiftUI

extension Color {
	init(hex: Int, opacity: Double = 1.0) {
		let red = Double((hex >> 16) & 0xff) / 255
		let green = Double((hex >> 8) & 0xff) / 255
		let blue = Double((hex >> 0) & 0xff) / 255
		
		self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
	}
	
	init(hex: String) {
		let scanner = Scanner(string: hex)
		_ = scanner.scanString("#")
		
		var rgb: UInt64 = 0
		scanner.scanHexInt64(&rgb)
		
		let r = Double((rgb >> 16) & 0xFF) / 255.0
		let g = Double((rgb >>  8) & 0xFF) / 255.0
		let b = Double((rgb >>  0) & 0xFF) / 255.0
		self.init(red: r, green: g, blue: b)
	}
}

extension Color {
	static var gsGreenPrimary: Self {
		.init(hex: "#BDFF01")
	}
	
	static var gsGreenPressed: Self {
		.init(hex: "#E0FF66")
	}
	
	static var gsYellowPrimary: Self {
		.init(hex: "#FAFF10")
	}
	
	static var gsRed: Self {
		.init(hex: "#FF611E")
	}
	
	/// Disabled Button Color in Lightmode and Darkmode
	static var gsLightGray1: Self {
		.init(hex: "#8D8F97")
	}
	
	/// SearchBar Input Background Color in Lightmode and Darkmode
	static var gsLightGray2: Self {
		.init(hex: "#A8AeB4")
	}
	
	static var gsDarkGray: Self {
		.init(hex: "#27292E")
	}
	
	static let captionRed = Color(hex: "#cc0000")
	static let captionGreen = Color(hex: "#6aa84f")
	static let textAccent = Color(hex: "#efbb1a")
	static let backAccent = Color(hex: "#FFE577")
    
    //Color Asset에 넣어놓은 색상들. (라이트 / 다크 자동 호환)
    static let gsGray1 = Color("GSGray1")
    static let gsGray2 = Color("GSGray2")
    static let gsGray3 = Color("GSGray3")
    
    //ChatListSection에서 캡슐과 텍스트에 쓰일 색상
    static let unreadMessageCapsule = Color("UnreadMessageCapsule")
    static let unreadMessageText = Color("UnreadMessageText")
	
}
