//
//  Constant.swift
//  GitSpace
//
//  Created by 이승준, 원태영, 이다혜, 최한호, 정예슬, 박제균, 최예은 on 2023/02/03.
//

import SwiftUI

public enum Constant {
	// 전체가 정적인 텍스트만 상수로 관리
	static let KNOCK_WAITING: String = "Waiting"
	static let KNOCK_ACCEPTED: String = "Accepted"
	static let KNOCK_DECLINED: String = "Declined"
	static let KNOCK_ALL: String = "All"
	
	static let KNOCK_RECEIVED: String = "Received"
	static let KNOCK_SENT: String = "Sent"
    
	/// AppStorage에 유저 설정을 저장할 때의 키값을 보관하는 상수 입니다.
	enum AppStorageConst {
		static let KNOCK_ALL_NOTIFICATION: String = "isAllKnockNotificationEnabled"
		static let KNOCK_DECLINED_NOTIFICATION: String = "isDeclinedKnockNotificationEnabeld"
        static let CHATROOM_NOTIFICATION: String = "isChatRoomNotificationEnabled"
        static let USER_CHAT_BLOCK: String = "isUserChatBlocked"
	}
	
	enum PushNotification {
		static let SERVER_KEY: String = Bundle.main.object(forInfoDictionaryKey: "SERVER_KEY") as? String ?? ""
		static let PUSH_NOTIFICATION_ENDPOINT: String = Bundle.main.object(forInfoDictionaryKey: "PUSH_NOTIFICATION_ENDPOINT") as? String ?? ""
        static let USER_DEVICE_TOKEN: String = "userDeviceToken"
	}
    
    enum FirestorePathConst {
        static let COLLECTION_CHAT: String = "Chat"
        static let FIELD_JOINED_MEMBER_IDS: String = "joinedMemberIDs"
        static let FIELD_LAST_CONTENT_DATE: String = "lastContentDate"
        static let FIELD_LAST_CONTENT: String = "lastContent"
        static let FIELD_UNREAD_MESSAGE_COUNT: String = "unreadMessageCount"
        
        static let COLLECTION_MESSAGE: String = "Message"
        static let FIELD_SENT_DATE: String = "sentDate"
        static let FIELD_TEXT_CONTENT: String = "textContent"
        
        static let COLLECTION_USER_INFO: String = "UserInfo"
        static let FIELD_GITHUB_ID: String = "githubID"
        static let FIELD_DEVICE_TOKEN: String = "deviceToken"
        static let FIELD_BLOCKED_USER_IDS: String = "blockedUserIDs"
        
        static let COLLECTION_TAG: String = "Tag"
        static let FIELD_REPOSITORIES: String = "repositories"
    }
	
    //MARK: - Text DesignSystem에 들어갈 속성값들
    enum GSTextConst {
        static let TITLE1_SIZE: CGFloat = 28
        static let TITLE1_FONT_WEIGHT: Font.Weight = .semibold
        static let TITLE1_COLOR: Color = Color.primary
        
        static let TITLE2_SIZE: CGFloat = 20
        static let TITLE2_FONT_WEIGHT: Font.Weight = .semibold
        static let TITLE2_COLOR: Color = Color.primary
        
        static let TITLE3_SIZE: CGFloat = 16
        static let TITLE3_FONT_WEIGHT: Font.Weight = .semibold
        static let TITLE3_COLOR: Color = Color.primary
        
        static let TITLE4_SIZE: CGFloat = 13
        static let TITLE4_FONT_WEIGHT: Font.Weight = .semibold
        static let TITLE4_COLOR: Color = Color.primary
        
        static let SECTION_TITLE_SIZE: CGFloat = 13
        static let SECTION_TITLE_FONT_WEIGHT: Font.Weight = .regular
        static let SECTION_TITLE_COLOR: Color = Color.gsGray2
        
        static let BODY1_SIZE: CGFloat = 16
        static let BODY1_FONT_WEIGHT: Font.Weight = .regular
        static let BODY1_COLOR: Color = Color.primary

        static let BODY2_SIZE: CGFloat = 12
        static let BODY2_FONT_WEIGHT: Font.Weight = .regular
        static let BODY2_COLOR: Color = Color.gsGray1

        static let CAPTION1_SIZE: CGFloat = 13
        static let CAPTION1_FONT_WEIGHT: Font.Weight = .medium
        static let CAPTION1_COLOR: Color = Color.gsGray2
        static let CAPTION_PRIMARY1_COLOR: Color = Color.primary
        
        static let CAPTION2_SIZE: CGFloat = 12
        static let CAPTION2_FONT_WEIGHT: Font.Weight = .regular
        static let CAPTION2_COLOR: Color = Color.gsGray2
        static let CAPTION_PRIMARY2_COLOR: Color = Color.primary
        
        static let DESCRIPTION_SIZE: CGFloat = 16
        static let DESCRIPTION_FONT_WEIGHT: Font.Weight = .medium
        static let DESCRIPTION_COLOR: Color = Color.gsGray2
        
        static let DESCRIPTION2_SIZE: CGFloat = 13
        static let DESCRIPTION2_FONT_WEIGHT: Font.Weight = .regular
        static let DESCRIPTION2_COLOR: Color = Color.gsGray2
        
        static let BUTTON_TITLE1_SIZE: CGFloat = 16
        static let BUTTON_TITLE1_FONT_WEIGHT: Font.Weight = .semibold
        static let BUTTON_TITLE1_COLOR: Color = Color.black

    }
    
    enum TextFieldConst {
        static let SEARCHBAR_SYMBOL_PLACEHOLDER_SPACE: CGFloat = 8
        static let SEARCHBAR_INSET_HORIZONTAL: CGFloat = 14
        static let SEARCHBAR_INSET_VERTICAL: CGFloat = 12
        static let SEARCHBAR_CORNER_RADIUS: CGFloat = 10
        static let SEARCHBAR_FIELD_SYMBOL_NAME: String = "magnifyingglass"
        static let SEARCHBAR_FIELD_PLACEHOLDER: String = "Search"
        
        static let ADDTAG_INSET_HORIZONTAL: CGFloat = 10
        static let ADDTAG_INSET_VERTICAL: CGFloat = 10
        static let ADDTAG_CORNER_RADIUS: CGFloat = 10
        static let ADDTAG_FIELD_PLACEHOLDER: String = "Tag name"
    }
    
    enum TextEditorConst {
        static let TEXTEDITOR_DEFAULT_LINE_COUNT: Int = 1
        static let TEXTEDITOR_MAX_LINE_COUNT: Int = 5
        static let TEXTEDITOR_INSET_HORIZONTAL: CGFloat = 10
        static let TEXTEDITOR_STROKE_CORNER_RADIUS: CGFloat = 20
        static let TEXTEDITOR_FRAME_HEIGHT_FREESPACE: CGFloat = 20
    }

	public enum LabelHierarchy {
		case primary
		case secondary
		case tertiary(isSelected: Bool? = nil)
	}
}
