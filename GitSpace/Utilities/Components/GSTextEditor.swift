import SwiftUI

struct GSTextEditor {
    enum GSTextEditorStyle {
        case message
    }
    
    // MARK: -Properties
    let style: GSTextEditorStyle
    let text: Binding<String>
    let font: Font?
    let lineSpace: CGFloat?
    
    
}

