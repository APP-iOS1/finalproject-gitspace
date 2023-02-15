//
//  GSText.swift
//  GitSpace
//
//  Created by 정예슬 on 2023/02/03.
//

import SwiftUI

public struct GSText {
    
    // MARK: - 사용법
    /*
     GSText.CustomTextView(
        style: .title1,
        string: "this is title1")
     
     위와 같은 방법으로 사용할 수 있도록 제작. 사용하는 텍스트들의 종류에 맞게 GSTextStyle의 enum값을 넘겨주고 화면에 보여줄 string 값을 함께 넘겨주면 정해진 디자인에 맞게 화면에 출력됨. text style과 string은 기본적으로 필요한 값으로 꼭 넣어줘야하는 인자.
     각 케이스는 텍스트의 크기, weight, 색상값이 정해져있다. 이는 Utilities/Constant.swift 파일에서 확인 가능.
     */
    
    public enum GSTextStyle {
        case title1
        case title2
        case title3
        case title4
        case sectionTitle
        case body1
        case body2
        case caption1
        case caption2
        case captionPrimary1
        case captionPrimary2
        case description
        case description2
    }
    
    struct CustomTextView: View {
        public let style: GSTextStyle
        public let string: String
        
        var body: some View {
            switch style {
            //MARK: - Title 종류 -> title1, title2, title3, sectionTitle
            /*
             강조, 이탤릭 등 마크다운 효과를 적용하기 위해 LocalizedStringKey의 initializer를 사용한 Text를 만듭니다.
             */
            case .title1:
                Text(.init(string))
                    .font(.system(size: Constant.GSTextConst.TITLE1_SIZE))
                    .fontWeight(Constant.GSTextConst.TITLE1_FONT_WEIGHT)
                    .foregroundColor(Constant.GSTextConst.TITLE1_COLOR)
            case .title2:
                Text(.init(string))
                    .font(.system(size: Constant.GSTextConst.TITLE2_SIZE))
                    .fontWeight(Constant.GSTextConst.TITLE2_FONT_WEIGHT)
                    .foregroundColor(Constant.GSTextConst.TITLE2_COLOR)
            case .title3:
                Text(.init(string))
                    .font(.system(size: Constant.GSTextConst.TITLE3_SIZE))
                    .fontWeight(Constant.GSTextConst.TITLE3_FONT_WEIGHT)
                    .foregroundColor(Constant.GSTextConst.TITLE3_COLOR)
            case .title4:
                Text(.init(string))
                    .font(.system(size: Constant.GSTextConst.TITLE4_SIZE))
                    .fontWeight(Constant.GSTextConst.TITLE4_FONT_WEIGHT)
                    .foregroundColor(Constant.GSTextConst.TITLE4_COLOR)
            case .sectionTitle:
                Text(.init(string))
                    .font(.system(size: Constant.GSTextConst.SECTION_TITLE_SIZE))
                    .fontWeight(Constant.GSTextConst.SECTION_TITLE_FONT_WEIGHT)
                    .foregroundColor(Constant.GSTextConst.SECTION_TITLE_COLOR)
                
            //MARK: -  body 종류 -> body1, body2
            case .body1:
                Text(.init(string))
                    .font(.system(size: Constant.GSTextConst.BODY1_SIZE))
                    .fontWeight(Constant.GSTextConst.BODY1_FONT_WEIGHT)
                    .foregroundColor(Constant.GSTextConst.BODY1_COLOR)
            case .body2:
                Text(.init(string))
                    .font(.system(size: Constant.GSTextConst.BODY2_SIZE))
                    .fontWeight(Constant.GSTextConst.BODY2_FONT_WEIGHT)
                    .foregroundColor(Constant.GSTextConst.BODY2_COLOR)
                
            //MARK: - 그 외 종류 -> caption1, caption2, description
            case .caption1:
                Text(.init(string))
                    .font(.system(size: Constant.GSTextConst.CAPTION1_SIZE))
                    .fontWeight(Constant.GSTextConst.CAPTION1_FONT_WEIGHT)
                    .foregroundColor(Constant.GSTextConst.CAPTION1_COLOR)
            case .caption2:
                Text(.init(string))
                    .font(.system(size: Constant.GSTextConst.CAPTION2_SIZE))
                    .fontWeight(Constant.GSTextConst.CAPTION2_FONT_WEIGHT)
                    .foregroundColor(Constant.GSTextConst.CAPTION2_COLOR)
            case .captionPrimary1:
                Text(.init(string))
                    .font(.system(size: Constant.GSTextConst.CAPTION1_SIZE))
                    .fontWeight(Constant.GSTextConst.CAPTION1_FONT_WEIGHT)
                    .foregroundColor(Constant.GSTextConst.CAPTION_PRIMARY1_COLOR)
            case .captionPrimary2:
                Text(.init(string))
                    .font(.system(size: Constant.GSTextConst.CAPTION2_SIZE))
                    .fontWeight(Constant.GSTextConst.CAPTION2_FONT_WEIGHT)
                    .foregroundColor(Constant.GSTextConst.CAPTION_PRIMARY2_COLOR)
            case .description:
                Text(.init(string))
                    .font(.system(size: Constant.GSTextConst.DESCRIPTION_SIZE))
                    .fontWeight(Constant.GSTextConst.DESCRIPTION_FONT_WEIGHT)
                    .foregroundColor(Constant.GSTextConst.DESCRIPTION_COLOR)
            case .description2:
                Text(.init(string))
                    .font(.system(size: Constant.GSTextConst.DESCRIPTION2_SIZE))
                    .fontWeight(Constant.GSTextConst.DESCRIPTION2_FONT_WEIGHT)
                    .foregroundColor(Constant.GSTextConst.DESCRIPTION2_COLOR)
            }
        }
        
        init(style: GSTextStyle, string: String) {
            self.style = style
            self.string = string
        }
        
    }
}

// Preview Test를 위한 코드
struct Test_text: View {
    var body: some View {
        VStack {
            GSText.CustomTextView(
                style: .title1,
                string: "this is title1")
            
            GSText.CustomTextView(
                style: .title2,
                string: "this is title 2")
            
            GSText.CustomTextView(
                style: .title3,
                string: "this is title3")
            
            GSText.CustomTextView(
                style: .sectionTitle,
                string: "this is section title")
            
            GSText.CustomTextView(
                style: .body1,
                string: "this is body1")
            
            GSText.CustomTextView(
                style: .body2,
                string: "this is body2")
            
            GSText.CustomTextView(
                style: .caption1,
                string: "this is caption1")
            
            GSText.CustomTextView(
                style: .caption2,
                string: "this is caption2")
            
            GSText.CustomTextView(
                style: .description,
                string: "this is description")
        }
    }
    
}

struct GSText_Previews: PreviewProvider {
    static var previews: some View {
        Test_text()
    }
}
