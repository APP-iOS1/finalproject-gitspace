import SwiftUI

struct GSTextEditor {
    enum GSTextEditorStyle {
        case message
    }
    
    // MARK: -Properties
    // MARK: Stored Properties
    let style: GSTextEditorStyle
    let text: Binding<String>
    let font: Font?
    let lineSpace: CGFloat?
    
    // MARK: Computed Properties
    // font 사이즈 관련 프로퍼티를 활용하기 위해 Font -> UIFont로 변환
    private var mainUIFont: UIFont {
        if let font {
            return UIFont.fontToUIFont(from: font)
        }
        return UIFont.fontToUIFont(from: .body)
    }
    
    init (
        style: GSTextEditorStyle,
        text: Binding<String>,
        font: Font? = .body,
        lineSpace: CGFloat? = 2
    ) {
        self.style = style
        self.text = text
        self.font = font
        self.lineSpace = lineSpace
    }
    
    
}

