// MARK: -Process
/// 1. TextEditor에 쓰일 Font를 전달받는다
/// 2. Font를 UIFont로 변환한 연산 프로퍼티를 통해 텍스트 한 줄의 높이를 계산한다 (lineHeight)
/// 3. 행간을 추가로 max 높이에 더해주기 위해 라인 간격을 필수 파라미터로 받는다
/// 4. Font 높이, 라인 갯수, 행간, 여유공간을 모두 더해서 TextEditor 높이를 실시간으로 업데이트한다
///

// MARK: -Memo
/// 1. Font 이니셜라이저를 통해 UIFont -> Font 타입으로 변환
///     Font.init(font: CTFont(UIFont 타입))
/// 2. Font -> UIFont 타입으로 변환
///     UIFont.preferredFont(from: Font(스유 Font 타입))

import SwiftUI

struct GSTextEditor {
    
    // MARK: Style Enum
    enum GSTextEditorStyle {
        case message
    }
    
    // MARK: -View
    struct CustomTextEditorView : View {
        
        // MARK: -Properties
        // MARK: Stored Properties
        let const = Constant.TextEditorConst.self
        
        // MARK: TextEditor 관련 프로퍼티
        let style: GSTextEditorStyle
        let text: Binding<String>
        let font: Font
        let lineSpace: CGFloat
        let isBlocked: Bool
        
        // MARK: Initializer에서 계산을 통해 결정되는 프로퍼티
        let maxLineCount: CGFloat
        let uiFont: UIFont
        let maxHeight: CGFloat
        
        // MARK: SendButton 관련 프로퍼티
        let sendableImage: String
        let unSendableImage: String
        let action: () -> Void
        
        @State private var currentTextEditorHeight: CGFloat = 0
        @State private var maxTextWidth: CGFloat = 0
        
        // MARK: Computed Properties
        // 현재 text에 개행문자에 의한 라인 갯수가 몇 줄인지 계산하는 프로퍼티
        private var newLineCount: CGFloat {
            let currentText: String = text.wrappedValue
            let currentLineCount: Int = currentText.filter{$0 == "\n"}.count + 1
            return currentLineCount > maxLineCount.asInt
            ? maxLineCount
            : currentLineCount.asFloat
        }
        
        // 개행 문자 기준으로 텍스트를 분리하고, 각 텍스트 길이가 Editor 길이를 초과하는지 체크하여 필요한 줄바꿈 수를 계산하는 프로퍼티
        private var autoLineCount: CGFloat {
            var counter: Int = 0
            text.wrappedValue.components(separatedBy: "\n").forEach { line in
                let label = UILabel()
                label.font = .fontToUIFont(from: font)
                label.text = line
                label.sizeToFit()
                let currentTextWidth = label.frame.width
                counter += (currentTextWidth / maxTextWidth).asInt
            }
            return counter.asFloat
        }
        
        // 메세지 문자열이 비어있는지, 공백으로만 이루어져있는지를 체크해서 메시지 전송 가능 여부를 반환하는 연산 프로퍼티
        private var isMessageSendable: Bool {
            let messageText = text.wrappedValue
            guard messageText.isEmpty == false else { return false }
            let pattern: String = "^[ \n]*$"
            if messageText.range(of: pattern,
                                 options: .regularExpression) != nil {
                return false
            }
            return true
        }
        
        // MARK: -Initializer
        /// 파라미터 font = .body, lineSpace = 2 기본값 지정
        init (
            style: GSTextEditorStyle,
            text: Binding<String>,
            font: Font = .body,
            lineSpace: CGFloat = 2,
            isBlocked: Bool,
            sendableImage: String,
            unSendableImage: String,
            action: @escaping () -> Void
        ) {
            self.style = style
            self.text = text
            self.font = font
            self.lineSpace = lineSpace
            self.isBlocked = isBlocked
            
            self.sendableImage = sendableImage
            self.unSendableImage = unSendableImage
            self.action = action
            
            self.maxLineCount = const.TEXTEDITOR_MAX_LINE_COUNT.asFloat
            self.uiFont = UIFont.fontToUIFont(from: font)
            self.maxHeight = (maxLineCount * (uiFont.lineHeight + lineSpace)) + const.TEXTEDITOR_FRAME_HEIGHT_FREESPACE
        }
        
        // MARK: -Methods
        // MARK: textEditor 시작 높이를 세팅해주는 메서드
        private func setTextEditorStartHeight() {
            currentTextEditorHeight = uiFont.lineHeight + const.TEXTEDITOR_FRAME_HEIGHT_FREESPACE
        }
        
        // MARK: text가 가질 수 있는 최대 길이를 세팅해주는 메서드
        private func setMaxTextWidth(proxy: GeometryProxy) {
            maxTextWidth = proxy.size.width - (const.TEXTEDITOR_INSET_HORIZONTAL * 2 + 10)
        }
        
        // MARK: line count를 통해 textEditor 현재 높이를 계산해서 업데이트하는 메서드
        private func updateTextEditorCurrentHeight() {
            
            // 총 라인 갯수
            let totalLineCount = newLineCount + autoLineCount
            
            // 총 라인 갯수가 maxCount 이상이면 최대 높이로 고정
            guard totalLineCount < maxLineCount else {
                currentTextEditorHeight = maxHeight
                return
            }
            
            // 라인 갯수로 계산한 현재 Editor 높이
            let currentHeight = (totalLineCount * (uiFont.lineHeight + lineSpace))
            + const.TEXTEDITOR_FRAME_HEIGHT_FREESPACE
            
            // View의 높이를 결정하는 State 변수에 계산된 현재 높이를 할당하여 뷰에 반영
            currentTextEditorHeight = currentHeight
        }
        
        // MARK: -View
        var body: some View {
            switch style {
            case .message:
                
                if isBlocked {
                    TextEditor(
                        text: .constant(const.TEXTEDITOR_BLOCKED_LABEL)
                    )
                    .modifier(
                        GSTextEditorLayoutModifier(
                            font: font,
                            color: .gsGray1,
                            lineSpace: lineSpace,
                            maxHeight: currentTextEditorHeight,
                            horizontalInset: const.TEXTEDITOR_INSET_HORIZONTAL,
                            bottomInset: const.TEXTEDITOR_INSET_BOTTOM
                        )
                    )
                    .disabled(true)
                    .overlay {
                        RoundedRectangle(cornerRadius: const.TEXTEDITOR_STROKE_CORNER_RADIUS)
                            .stroke()
                            .foregroundColor(.gsGray2)
                            .background(
                                Color.gsGray3.opacity(0.7)
                            )
                            .cornerRadius(const.TEXTEDITOR_STROKE_CORNER_RADIUS)
                    }
                    .onAppear {
                        setTextEditorStartHeight()
                    }
                    
                } else {
                    HStack {
                        GeometryReader { proxy in
                            TextEditor(text: text)
                                .modifier(
                                    GSTextEditorLayoutModifier(
                                        font: font,
                                        color: .primary,
                                        lineSpace: lineSpace,
                                        maxHeight: currentTextEditorHeight,
                                        horizontalInset: const.TEXTEDITOR_INSET_HORIZONTAL,
                                        bottomInset: const.TEXTEDITOR_INSET_BOTTOM
                                    )
                                )
                                .overlay {
                                    RoundedRectangle(cornerRadius: const.TEXTEDITOR_STROKE_CORNER_RADIUS)
                                        .stroke()
                                        .foregroundColor(.gsGray2)
                                }
                                .onAppear {
                                    setTextEditorStartHeight()
                                    setMaxTextWidth(proxy: proxy)
                                }
                                .onChange(of: text.wrappedValue) { n in
                                    updateTextEditorCurrentHeight()
                                }
                        }
                        .frame(maxHeight: currentTextEditorHeight)
                    }
                    
                    Button {
                        action()
                    } label: {
                        Image(
                            systemName: isMessageSendable
                            ? sendableImage
                            : unSendableImage
                        )
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: const.TEXTEDITOR_SEND_BUTTON_SIZE,
                            height: const.TEXTEDITOR_SEND_BUTTON_SIZE
                        )
                        .foregroundColor(
                            isMessageSendable
                            ? .primary
                            : .gsGray2
                        )
                    }
                    .disabled(!isMessageSendable)
                    
                }
            }
        }
    }
}


