# GitSpace Design System Doc
> GitSpace 팀의 공식 디자인 시스템 문서입니다. GitSpace 팀의 디자인 시스템에 대한 고민을 확인할 수 있습니다.
> 작성일 : 230127 금요일
> 작성자 : 이승준, 이다혜, 박제균, 원태영, 정예슬, 최예은, 최한호

---
## Intro
- 본 문서의 "디자인 시스템"은 여러 작업자가 여러 플랫폼에서 동시에 정합적이고 효율적인 방식으로 UI 컴포넌트를 구성할 수 있도록 하는 추상화된 코드 체계를 의미합니다.

- GitSpace 팀은 아토믹 단위의 디자인 요소를 타겟으로 추상화를 진행하며, [Headless UI](https://medium.com/cstech/headless-ui-components-creating-re-usable-logic-without-thinking-about-design-69ac9fad6400)의 관점에 따라 각 디자인 요소의 최소 기능은 살리되, UI는 구현 시점에 커스텀하여 제공할 수 있도록 코드를 구성합니다.
    - why : 프로젝트의 디자인 요소 숫자가 방대하지 않지만 반복되는 디자인 요소가 존재하며, 이 요소들이 화면과 구성해야 하는 UI 컴포넌트에 따라 재구성되는 경우가 많기 때문

### 목적
- **도전** :
    - 실제 현업 단계에서의 디자인 요소는 코드로 추상화되어 있기 때문에, 그 환경을 직접 구현하고 빠르게 적응하기 위함
- **편의** : 
    - 사용자 피드백을 수용하고 빠르게 대응하기 위해 추상화된 보일러 플레이트를 수정하면 해당 보일러 플레이트를 활용한 모든 곳에서 변경사항을 적용하기 위함
    - 작업자가 디자인에 대한 고민없이 빠르게 요소를 구성하고 호출하기 위함
- **통일성** :
    - 각 디자인 요소를 적재적소에서 동일한 형태로 활용하고, 더 나아가 여러 플랫폼에서도 동일하게 대응하기 위함

---
## SwiftUI와 추상화 요령
> GitSpace 팀이 디자인 시스템을 구현하기 위해 고민한 내용과 마주한 문제상황을 비교하고 적합한 추상화 요령을 찾아가는 과정을 작성합니다.

### `ViewModifer`를 활용한 추상화
- 장점 :
    - 구현이 편리하고 쉬움
    - 구성해야 하는 UI 컴포넌트에 필요한 모디파이어만 호출하여 사용 가능
    - 함수형 프로그래밍처럼 일관된 사용이 가능하기에 작업 전 러닝커브 최소화
- 단점 : 
    - `ForEach` 구문과의 궁합이 좋지 않음
    - **사용을 강제하는 수단이 HR에 종속되며 휴먼 에러에 취약함**
    - `ViewModifier` 구조체가 가져야 하는 속성이 매우 많아질 수 있으며, 호출의 편의성을 위해 수많은 생성자를 따로 정의해야 할 수 있음
    - 모디파이어의 구현 범위를 규정하는 데에 따르는 어려움 존재

- 해결 방안 :
    - 컴파일 시점에 작업자가 적합한 디자인 시스템을 활용하여 뷰를 구성하지 않았을 때, 에러가 일어나도록 강제하는 방안 탐색
    - 기존 SwiftUI API와 충돌을 일으키지 않는 방식의 필요에 따라 기존 뷰를 확장하거나 기본 UI 요소 자체를 리턴할 수 있는 속성 혹은 메소드 구현
    - 팀 내의 모든 작업자가 쉽게 이해하고 구현하면서도 극복 가능한 도전으로서의 코드 추상화 필요
    ---
### 커스텀 구조체 정의
- 장점 :
    - 컴파일 시점에서의 통제 가능
    - `ViewModifier` 의 구현 범위 규정에 어려움이 있던 것과는 달리, 기본 디자인 요소만을 타겟으로 추상화를 진행할 수 있음
    - 여러 커스텀 구조체를 구성하여 하나의 UI 컴포넌트를 구성할 수 있음
- 단점 :
    - 보일러 플레이트 구현의 어려움
    - 내부 로직의 복잡도에 따라 작업자의 러닝커브가 가파르게 높아질 수 있음


## 커스텀 구조체와 뷰 추상화
- GitSpace 팀은 위와 같이 추상화를 위한 수단을 정리 및 비교하였고, 긴 회의를 통해 커스텀 구조체를 활용한 디자인 시스템을 채택했습니다.
    - 이유 1 : 커스텀 구조체의 단점이 현 시점 GitSpace 에게 필요한 도전과제로서 작용
    - 이유 2 : 모든 팀원이 추상화에 참여할 수 있고, 편리하게 사용이 가능함

---
## Keynote
> 추상화 구현된 Button의 일부 코드
```swift
// MARK: - 모든 작업자는 Button 대신 GSButton을 호출하여 버튼을 사용합니다.
public struct GSButton {
    
    /*
    GSButtonStyle 열거형으로 버튼의 종류를 나누고
    버튼의 기능에 따라 필요한 속성을 연관값으로 전달합니다.
    이로써 작업자들은 특정 케이스의 뷰가 어떤 기능을 수행하는지,
    어떤 속성이 필요한지 플레이스홀더로 확인할 수 있습니다.
    */
    public enum GSButtonStyle {
        case primary(isDisabled: Bool)
        case secondary(isDisabled: Bool)
        case tag(isEditing: Bool,
                 isSelected: Bool = false)
        case plainText(isDestructive: Bool)
        case homeTab(tabName: String,
                     tabSelection: Binding<String>)
    }
    
    struct CustomButtonView<CustomLabelType: View>: View {
        public let style: GSButtonStyle
        public let action: () -> Void
        
        // any View 프로토콜 타입으로 선언할 수 없던 문제를 제너릭으로 해결합니다.
        public var label: CustomLabelType?
    
        var body: some View {
            switch style {
            case .primary(let isDisabled):
                // code
            
            case .secondary(let isDisabled):
                // code
                
            case .tag(let isEditing, let isSelected):
                // code

            case .plainText(let isDestructive):
                // code
        
            case .homeTab(let tabName,
                          let tabSelection):
                // code
            }
        }
        
        // 생성자를 하나로 통일하고 열거형의 연관값으로 세부 내용을 전달합니다.
        init(style: GSButtonStyle,
             action: @escaping () -> Void,
             @ViewBuilder label: () -> CustomLabelType) {
            self.style = style
            self.action = action
            self.label = label()
        }
    }
}
```
---
## 후속 글
- 추상화 코드와 다크모드 대응
- 추상화 코드 속에서 `ViewModifier`의 추가적인 활용

---
## 참고 자료
1. [Atomic Design](https://bradfrost.com/blog/post/atomic-web-design/)
2. [Headless UI Components: Creating re-usable logic without thinking about design](https://medium.com/cstech/headless-ui-components-creating-re-usable-logic-without-thinking-about-design-69ac9fad6400)